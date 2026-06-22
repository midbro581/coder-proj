/* =============================================================
   CODER — compiler.js
   In-browser code compiler using Piston API
   ============================================================= */

const STARTER_CODE = {
  python: `# Python — Hello, Coder!
name = "Coder"
print(f"Hello from {name}!")

# Try a loop
for i in range(1, 6):
    print(f"  Line {i}: Learning Python")
`,
  java: `// Java — Hello, Coder!
public class Main {
    public static void main(String[] args) {
        String name = "Coder";
        System.out.println("Hello from " + name + "!");

        // Try a loop
        for (int i = 1; i <= 5; i++) {
            System.out.println("  Line " + i + ": Learning Java");
        }
    }
}
`,
  javascript: `// JavaScript — Hello, Coder!
const name = "Coder";
console.log(\`Hello from \${name}!\`);

// Try a loop
for (let i = 1; i <= 5; i++) {
    console.log(\`  Line \${i}: Learning JavaScript\`);
}
`,
  typescript: `// TypeScript — Hello, Coder!
const name: string = "Coder";
const count: number = 5;

console.log(\`Hello from \${name}!\`);

// Typed function
function greet(lang: string, times: number): void {
    for (let i = 1; i <= times; i++) {
        console.log(\`  Line \${i}: Learning \${lang}\`);
    }
}

greet("TypeScript", count);
`,
  cpp: `// C++ — Hello, Coder!
#include <iostream>
#include <string>
using namespace std;

int main() {
    string name = "Coder";
    cout << "Hello from " << name << "!" << endl;

    // Try a loop
    for (int i = 1; i <= 5; i++) {
        cout << "  Line " << i << ": Learning C++" << endl;
    }
    return 0;
}
`,
  c: `// C — Hello, Coder!
#include <stdio.h>

int main() {
    char name[] = "Coder";
    printf("Hello from %s!\\n", name);

    // Try a loop
    for (int i = 1; i <= 5; i++) {
        printf("  Line %d: Learning C\\n", i);
    }
    return 0;
}
`
};

const FILE_EXTENSIONS = {
  python:     'main.py',
  java:       'Main.java',
  javascript: 'main.js',
  typescript: 'main.ts',
  cpp:        'main.cpp',
  c:          'main.c'
};

let currentLang = 'python';

function setLanguage(lang) {
  currentLang = lang;

  // Update sidebar active state
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.lang === lang);
  });

  // Update header label and filename
  const label = document.querySelector(`.lang-btn[data-lang="${lang}"]`)?.textContent.trim() || lang;
  const labelEl = document.getElementById('current-lang-label');
  const filenameEl = document.getElementById('editor-filename');
  if (labelEl) labelEl.textContent = label;
  if (filenameEl) filenameEl.textContent = FILE_EXTENSIONS[lang] || 'main.' + lang;

  // Load starter code
  const editor = document.getElementById('code-editor');
  if (editor) editor.value = STARTER_CODE[lang] || '// Start coding...\n';

  // Clear output
  const output = document.getElementById('output-display');
  if (output) {
    output.className = 'pending';
    output.textContent = 'Click "Run Code" to execute your program...';
  }
  document.getElementById('run-time').textContent = '';
}

async function runCode() {
  const editor = document.getElementById('code-editor');
  const output = document.getElementById('output-display');
  const runBtn = document.getElementById('btn-run');
  const runTime = document.getElementById('run-time');

  if (!editor || !output) return;

  const code = editor.value.trim();
  if (!code) {
    output.className = 'error';
    output.textContent = 'Error: No code to run.';
    return;
  }

  // Loading state
  runBtn.disabled = true;
  runBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Running...';
  output.className = 'pending';
  output.textContent = 'Compiling and running...';
  runTime.textContent = '';

  const startTime = Date.now();

  try {
    const res = await fetch('/api/compiler/run', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ language: currentLang, code })
    });

    const data = await res.json();
    const elapsed = ((Date.now() - startTime) / 1000).toFixed(2);

    if (!res.ok) {
      output.className = 'error';
      output.textContent = '⚠ Error: ' + (data.error || 'Compiler error.');
    } else if (data.stderr && !data.output) {
      output.className = 'error';
      output.textContent = '✗ Compile Error:\n' + data.stderr;
    } else {
      output.className = '';
      const out = (data.output || '').trim();
      const err = (data.stderr || '').trim();
      output.textContent = out || (err ? '⚠ Warning:\n' + err : '(No output)');
      if (err && out) output.textContent += '\n\n⚠ Warnings:\n' + err;
      runTime.textContent = `✓ Ran in ${elapsed}s`;
    }
  } catch {
    output.className = 'error';
    output.textContent = '⚠ Network error: Could not reach the compiler. Is the server running?';
  } finally {
    runBtn.disabled = false;
    runBtn.innerHTML = '<i class="fas fa-play"></i> Run Code';
  }
}

// Tab key support in the editor
function handleEditorTab(e) {
  if (e.key !== 'Tab') return;
  e.preventDefault();
  const ta = e.target;
  const start = ta.selectionStart;
  const end = ta.selectionEnd;
  ta.value = ta.value.substring(0, start) + '    ' + ta.value.substring(end);
  ta.selectionStart = ta.selectionEnd = start + 4;
}

document.addEventListener('DOMContentLoaded', () => {
  // Read ?lang= query param — map react→javascript, unknown→python
  const LANG_MAP = { react: 'javascript' };
  const params   = new URLSearchParams(window.location.search);
  const rawLang  = params.get('lang') || 'python';
  const lang     = LANG_MAP[rawLang] || (Object.keys(STARTER_CODE).includes(rawLang) ? rawLang : 'python');
  setLanguage(lang);

  // Load pre-filled code from lesson "Try in Compiler" click
  const prefillCode = localStorage.getItem('coder_prefill_code');
  const prefillLang = localStorage.getItem('coder_prefill_lang');
  if (prefillCode) {
    const mappedLang = LANG_MAP[prefillLang] || (Object.keys(STARTER_CODE).includes(prefillLang) ? prefillLang : null);
    if (mappedLang) setLanguage(mappedLang);
    const editor = document.getElementById('code-editor');
    if (editor) editor.value = prefillCode;
    localStorage.removeItem('coder_prefill_code');
    localStorage.removeItem('coder_prefill_lang');
  }

  // Language buttons
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.addEventListener('click', () => setLanguage(btn.dataset.lang));
  });

  // Run button
  document.getElementById('btn-run')?.addEventListener('click', runCode);

  // Ctrl+Enter / Cmd+Enter to run
  document.getElementById('code-editor')?.addEventListener('keydown', (e) => {
    handleEditorTab(e);
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') runCode();
  });

  // Clear button
  document.getElementById('btn-clear')?.addEventListener('click', () => {
    const editor = document.getElementById('code-editor');
    const output = document.getElementById('output-display');
    if (editor) editor.value = '';
    if (output) { output.className = 'pending'; output.textContent = 'Click "Run Code" to execute your program...'; }
    document.getElementById('run-time').textContent = '';
    editor?.focus();
  });
});
