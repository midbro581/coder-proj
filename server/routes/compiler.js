/*
 * CODER — routes/compiler.js
 * Runs code locally using child_process (no external API needed).
 * Supported: Python (python), JavaScript (node), TypeScript (npx ts-node),
 *            Java (javac+java), C++ (g++), C (gcc).
 */

const express = require('express');
const router  = express.Router();
const { exec } = require('child_process');
const fs   = require('fs');
const path = require('path');
const os   = require('os');

const FILE_NAMES = {
  python:     'main.py',
  javascript: 'main.js',
  typescript: 'main.ts',
  java:       'Main.java',
  cpp:        'main.cpp',
  c:          'main.c',
};

// Minimal tsconfig written into the temp dir before running TypeScript.
// Fixes ts-node auto-detecting NodeNext and conflicting with moduleResolution=node10.
const TS_CONFIG = JSON.stringify({
  compilerOptions: {
    target: "ES2022",
    module: "CommonJS",
    esModuleInterop: true,
    strict: false,
    skipLibCheck: true
  }
});

// Scan for compiler bin directories once at startup.
// The server's inherited PATH often misses tools installed under
// Program Files, so we explicitly probe known install locations.
function discoverCompilerPaths() {
  const dirs = ['C:\\ProgramData\\chocolatey\\bin'];

  // Node.js (node, npm, npx)
  if (fs.existsSync('C:\\Program Files\\nodejs')) {
    dirs.push('C:\\Program Files\\nodejs');
  }
  if (fs.existsSync('C:\\Program Files (x86)\\nodejs')) {
    dirs.push('C:\\Program Files (x86)\\nodejs');
  }

  // Python — scan Program Files for any Python3xx folder
  for (const base of ['C:\\Program Files', 'C:\\Program Files (x86)']) {
    if (!fs.existsSync(base)) continue;
    try {
      fs.readdirSync(base)
        .filter(d => /^Python\d+/i.test(d))
        .forEach(d => {
          const root = path.join(base, d);
          dirs.push(root);
          const scripts = path.join(root, 'Scripts');
          if (fs.existsSync(scripts)) dirs.push(scripts);
        });
    } catch {}
  }
  // Also user-level Python (the most common install location for non-admin users)
  const userPython = `C:\\Users\\${process.env.USERNAME || ''}\\AppData\\Local\\Programs\\Python`;
  if (fs.existsSync(userPython)) {
    try {
      fs.readdirSync(userPython)
        .filter(d => /^Python\d+/i.test(d))
        .forEach(d => {
          const root = path.join(userPython, d);
          dirs.push(root);
          const scripts = path.join(root, 'Scripts');
          if (fs.existsSync(scripts)) dirs.push(scripts);
        });
    } catch {}
  }

  // MinGW (gcc/g++) typical locations
  for (const d of ['C:\\tools\\mingw64\\bin', 'C:\\ProgramData\\mingw64\\mingw64\\bin', 'C:\\MinGW\\bin']) {
    if (fs.existsSync(d)) dirs.push(d);
  }

  // JDK directories — scan common vendor locations for any installed JDK
  for (const base of ['C:\\Program Files\\OpenJDK', 'C:\\Program Files\\Eclipse Adoptium', 'C:\\Program Files\\Microsoft']) {
    if (!fs.existsSync(base)) continue;
    try {
      fs.readdirSync(base)
        .filter(d => d.toLowerCase().startsWith('jdk'))
        .map(d => path.join(base, d, 'bin'))
        .filter(d => fs.existsSync(d))
        .forEach(d => dirs.push(d));
    } catch {}
  }

  return dirs;
}

const EXTRA_COMPILER_PATHS = discoverCompilerPaths();

function buildCommand(lang, tmpDir, filePath) {
  const out = path.join(tmpDir, 'out.exe');
  switch (lang) {
    case 'python':     return `python -X utf8 "${filePath}"`;
    case 'javascript': return `node "${filePath}"`;
    case 'typescript': return `npx --yes ts-node --transpile-only "${filePath}"`;
    case 'java':       return `javac "${filePath}" && java -cp "${tmpDir}" Main`;
    case 'cpp':        return `g++ "${filePath}" -o "${out}" && "${out}"`;
    case 'c':          return `gcc "${filePath}" -o "${out}" && "${out}"`;
    default:           return null;
  }
}

/* POST /api/compiler/run */
router.post('/run', (req, res) => {
  const { language, code } = req.body;

  if (!language || !code)
    return res.status(400).json({ error: 'Language and code are required.' });

  const lang = language.toLowerCase();

  if (!FILE_NAMES[lang])
    return res.status(400).json({ error: 'Unsupported language: ' + language });

  if (code.length > 10000)
    return res.status(400).json({ error: 'Code must be under 10,000 characters.' });

  // Write code to a temporary directory
  let tmpDir;
  try {
    tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'coder-'));
    fs.writeFileSync(path.join(tmpDir, FILE_NAMES[lang]), code, 'utf8');
    // Write a tsconfig.json for TypeScript so ts-node uses explicit module settings
    // instead of auto-detecting NodeNext (which causes a moduleResolution conflict)
    if (lang === 'typescript') {
      fs.writeFileSync(path.join(tmpDir, 'tsconfig.json'), TS_CONFIG, 'utf8');
    }
  } catch (err) {
    return res.status(500).json({ error: 'Failed to prepare code file: ' + err.message });
  }

  const filePath = path.join(tmpDir, FILE_NAMES[lang]);
  const command  = buildCommand(lang, tmpDir, filePath);

  // Build a safe environment: pass full process.env MINUS database/auth secrets.
  // gcc, g++, and javac need their own DLLs/runtimes discoverable via PATH and
  // Windows system variables (SystemRoot, TEMP, etc.) — passing only PATH is not enough.
  const EXCLUDED = new Set(['DB_PASSWORD', 'DB_USER', 'DB_HOST', 'DB_NAME', 'DB_PORT', 'JWT_SECRET', 'SESSION_SECRET']);
  const safeEnv  = {};
  for (const [k, v] of Object.entries(process.env)) {
    if (!EXCLUDED.has(k)) safeEnv[k] = v;
  }
  safeEnv.PYTHONUTF8 = '1';
  // Inject compiler paths discovered at startup into the child-process PATH
  const currentPath = safeEnv.PATH || '';
  const missing = EXTRA_COMPILER_PATHS.filter(p => !currentPath.includes(p));
  if (missing.length) {
    safeEnv.PATH = missing.join(';') + ';' + currentPath;
  }

  exec(command, { timeout: 10000, cwd: tmpDir, maxBuffer: 1024 * 1024, env: safeEnv }, (error, stdout, stderr) => {
    // Always clean up temp files
    try { fs.rmSync(tmpDir, { recursive: true, force: true }); } catch {}

    if (error && error.killed) {
      return res.json({ output: '', stderr: 'Execution timed out (10 second limit).', code: 1 });
    }

    return res.json({
      output: (stdout || '').trimEnd(),
      stderr: (stderr || '').trimEnd(),
      code:   error ? (error.code || 1) : 0,
    });
  });
});

module.exports = router;
