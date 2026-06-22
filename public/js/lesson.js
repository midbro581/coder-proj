/* =============================================================
   CODER — lesson.js
   Loads lesson content from API, renders the lesson page,
   handles mark-complete, and prev/next navigation.
   URL pattern: lesson.html?course=python&lesson=<id>
   ============================================================= */

let currentLesson  = null;
let completedIds   = [];
let allLessons     = [];

// ── Parse URL params ─────────────────────────────────────────
function getLessonParams() {
  const p = new URLSearchParams(window.location.search);
  return {
    courseLang: p.get('course') || 'python',
    lessonId:   parseInt(p.get('lesson'), 10) || 0,
  };
}

// ── Fetch user's completed lesson IDs ────────────────────────
async function fetchCompleted() {
  const user = getUser();
  if (!user || !user.id) return [];
  try {
    return await apiFetch('/api/progress/' + user.id);
  } catch { return []; }
}

// ── Syntax-highlight a code string (single-pass, no self-overlap) ────────
function highlightCode(code, lang) {
  // Escape HTML entities first so raw code is safe
  const s = code
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');

  const kwMap = {
    python:     'def|class|import|from|return|if|elif|else|for|while|in|not|and|or|True|False|None|print|len|range|append|remove|upper|lower|input',
    javascript: 'const|let|var|function|return|if|else|for|while|class|new|import|export|from|of|in|typeof|null|undefined|true|false|console|document|window|addEventListener|querySelector|innerHTML|forEach|map|filter|push|pop|async|await|useState|useEffect|useCallback|useMemo|useContext|useRef|createContext',
    react:      'const|let|var|function|return|if|else|for|while|class|new|import|export|from|of|in|typeof|null|undefined|true|false|console|async|await|useState|useEffect|useCallback|useMemo|useContext|useRef|createContext|memo|Fragment',
    typescript: 'const|let|var|function|return|if|else|for|while|class|new|import|export|from|of|in|typeof|null|undefined|true|false|string|number|boolean|void|any|never|unknown|interface|type|enum|extends|implements|readonly|public|private|protected|abstract|as|async|await|keyof|typeof|infer|satisfies',
    java:       'public|private|protected|class|static|void|int|double|float|boolean|String|return|if|else|for|while|new|this|super|import|package|System|out|println|main|final|abstract|interface|implements|extends|throws|try|catch|finally|instanceof',
    cpp:        'int|double|float|char|bool|void|return|if|else|for|while|class|public|private|include|using|namespace|std|cout|cin|endl|string|new|delete|vector|auto|const|override|virtual|abstract|template|nullptr|struct',
    sql:        'SELECT|FROM|WHERE|INSERT|INTO|VALUES|UPDATE|SET|DELETE|CREATE|TABLE|DROP|ALTER|JOIN|ON|AND|OR|NOT|NULL|PRIMARY|KEY|AUTO_INCREMENT|VARCHAR|INT|TEXT|INDEX|VIEW|TRANSACTION|COMMIT|ROLLBACK|START|EXISTS|DISTINCT|ORDER|BY|GROUP|HAVING|LIMIT|AS|INNER|LEFT|RIGHT|OUTER|UNION|CASE|WHEN|THEN|END',
    bash:       'git|cd|mkdir|echo|ls|rm|mv|cp|cat|grep|npm|node|python|export|source|chmod|sudo|curl|ssh|touch|chmod',
  };

  const kw = kwMap[lang];

  // Single-pass: match comments, then strings, then keywords — left-to-right priority
  // This prevents the string regex from ever running on span tag attributes
  const commentPat = '(\\/\\/[^\\n]*|#[^\\n]*)';
  const stringPat  = '("(?:[^"\\\\]|\\\\.)*"|\'(?:[^\'\\\\]|\\\\.)*\')';
  const kwPat      = kw ? `(\\b(?:${kw})\\b)` : null;

  const flags  = lang === 'sql' ? 'gi' : 'g';
  const source = kwPat
    ? `${commentPat}|${stringPat}|${kwPat}`
    : `${commentPat}|${stringPat}`;

  return s.replace(new RegExp(source, flags), (match, comment, str, keyword) => {
    if (comment  !== undefined) return `<span class="cm">${comment}</span>`;
    if (str      !== undefined) return `<span class="str">${str}</span>`;
    if (keyword  !== undefined) return `<span class="kw">${keyword}</span>`;
    return match;
  });
}

// ── Render the sidebar lesson list ───────────────────────────
function renderSidebar(courseLang, lessons, currentId, completedIds) {
  const titleEl = document.getElementById('sidebar-course-title');
  const listEl  = document.getElementById('sidebar-lesson-list');
  if (!titleEl || !listEl) return;

  // Capitalise language name
  const langLabel = courseLang.charAt(0).toUpperCase() + courseLang.slice(1);
  titleEl.textContent = langLabel;

  if (lessons.length === 0) {
    listEl.innerHTML = '<p style="padding:1rem; text-align:center; color:var(--text-muted); font-size:0.85rem;">No lessons.</p>';
    return;
  }

  listEl.innerHTML = lessons.map((l, idx) => {
    const isActive    = l.id === currentId;
    const isDone      = completedIds.includes(l.id);
    const classes     = ['lesson-sidebar-item',
                         isActive ? 'active' : '',
                         isDone   ? 'completed' : ''].filter(Boolean).join(' ');
    return `
      <a href="lesson.html?course=${encodeURIComponent(courseLang)}&lesson=${l.id}"
         class="${classes}">
        <span class="ls-num">${isDone ? '<i class="fas fa-check"></i>' : (idx + 1)}</span>
        <span style="flex:1;">${escapeHtml(l.title)}</span>
        ${isDone && !isActive ? '<i class="fas fa-check ls-check"></i>' : ''}
      </a>`;
  }).join('');
}

// ── Render the main lesson content ───────────────────────────
function renderLesson(lesson, completedIds) {
  const main = document.getElementById('lesson-main');
  if (!main) return;

  const isDone = completedIds.includes(lesson.id);
  const LANG_LABELS = { python: 'Python', javascript: 'JavaScript', react: 'React', typescript: 'TypeScript', java: 'Java', cpp: 'C++', html: 'HTML & CSS', sql: 'SQL', bash: 'Git & GitHub' };
  const langLabel = LANG_LABELS[lesson.language] || (lesson.language.charAt(0).toUpperCase() + lesson.language.slice(1));

  // File extension map
  const extMap = { python: 'main.py', javascript: 'main.js', react: 'App.jsx', typescript: 'main.ts', java: 'Main.java', cpp: 'main.cpp', html: 'index.html', sql: 'query.sql', bash: 'commands.sh' };
  const filename = extMap[lesson.language] || 'code.' + lesson.language;

  const highlightedCode = highlightCode(lesson.code_example, lesson.language);

  main.innerHTML = `
    <!-- Breadcrumb -->
    <div style="margin-bottom:1.5rem; font-size:0.85rem; color:var(--text-muted);">
      <a href="courses.html" style="color:var(--text-muted);">Courses</a>
      <i class="fas fa-chevron-right" style="font-size:0.65rem; margin:0 0.4rem;"></i>
      <a href="course.html?id=${lesson.course_id}" style="color:var(--text-muted);">${langLabel}</a>
      <i class="fas fa-chevron-right" style="font-size:0.65rem; margin:0 0.4rem;"></i>
      <span style="color:var(--text);">${escapeHtml(lesson.title)}</span>
    </div>

    <!-- Header -->
    <div class="lesson-header">
      <h1>${escapeHtml(lesson.title)}</h1>
      <div class="lesson-xp-badge">
        <i class="fas fa-bolt"></i> ${lesson.xp_reward} XP
      </div>
    </div>

    <!-- Lesson number -->
    <div style="margin-bottom:1.5rem; display:flex; align-items:center; gap:0.6rem;">
      <span style="background:rgba(108,99,255,0.12); border:1px solid rgba(108,99,255,0.25); color:var(--accent); padding:0.25rem 0.75rem; border-radius:999px; font-size:0.78rem; font-weight:700;">
        Lesson ${lesson.order_num}
      </span>
      <span style="background:var(--bg-card); border:1px solid var(--border); color:var(--text-muted); padding:0.25rem 0.75rem; border-radius:999px; font-size:0.78rem;">
        <i class="${getLangIcon(lesson.language)}"></i> ${langLabel}
      </span>
    </div>

    <!-- Explanation -->
    <div class="lesson-explanation">
      ${lesson.content.split('\n\n').filter(p => p.trim()).map(p => `<p>${escapeHtml(p.trim())}</p>`).join('')}
    </div>

    <!-- Code block -->
    <div class="lesson-code-block">
      <div class="code-block-header">
        <div class="code-block-dots">
          <span class="dot dot-red"></span>
          <span class="dot dot-yellow"></span>
          <span class="dot dot-green"></span>
          <span class="code-block-filename" style="margin-left:0.5rem;">${filename}</span>
        </div>
        <span class="code-block-lang">${langLabel}</span>
      </div>
      <pre class="code-block-pre">${highlightedCode}</pre>
    </div>

    <!-- Actions -->
    <div class="lesson-actions">
      <button class="btn-mark-complete ${isDone ? 'done' : ''}" id="btn-mark-complete"
        ${isDone ? 'disabled' : ''}>
        ${isDone
          ? '<i class="fas fa-check-circle"></i> Completed!'
          : '<i class="fas fa-check"></i> Mark Complete'}
      </button>
      <button class="btn-try-compiler" id="btn-try-compiler">
        ${ lesson.language === 'bash'
            ? '<i class="fas fa-copy"></i> Copy to Terminal'
          : lesson.language === 'react'
            ? '<i class="fas fa-copy"></i> Copy (Needs Browser)'
          : NON_RUNNABLE.includes(lesson.language)
            ? '<i class="fas fa-copy"></i> Copy to Clipboard'
            : '<i class="fas fa-terminal"></i> Try in Compiler' }
      </button>
    </div>

    <!-- Completion message -->
    <div id="complete-msg" style="display:none; background:rgba(67,233,123,0.1); border:1px solid rgba(67,233,123,0.25); border-radius:10px; padding:1rem 1.25rem; margin-bottom:1.5rem; color:var(--green); font-weight:600; font-size:0.9rem;">
      <i class="fas fa-star"></i> Lesson completed! You earned <strong>${lesson.xp_reward} XP</strong>. Keep going!
    </div>

    <!-- Prev / Next -->
    <div class="lesson-nav">
      <a id="btn-prev"
         href="${lesson.prev_id ? 'lesson.html?course=' + encodeURIComponent(lesson.language) + '&lesson=' + lesson.prev_id : '#'}"
         class="btn-lesson-nav ${lesson.prev_id ? '' : 'hidden'}">
        <i class="fas fa-arrow-left"></i> Previous
      </a>
      <span style="color:var(--text-muted); font-size:0.8rem;">Lesson ${lesson.order_num}</span>
      <a id="btn-next"
         href="${lesson.next_id ? 'lesson.html?course=' + encodeURIComponent(lesson.language) + '&lesson=' + lesson.next_id : 'course.html?id=' + lesson.course_id}"
         class="btn-lesson-nav">
        ${lesson.next_id ? 'Next <i class="fas fa-arrow-right"></i>' : 'Finish Course <i class="fas fa-flag-checkered"></i>'}
      </a>
    </div>`;

  // Bind mark-complete button
  const markBtn = document.getElementById('btn-mark-complete');
  if (markBtn && !isDone) {
    markBtn.addEventListener('click', () => markComplete(lesson));
  }

  // Bind try-in-compiler button
  const compilerBtn = document.getElementById('btn-try-compiler');
  if (compilerBtn) {
    compilerBtn.addEventListener('click', () => openCompiler(lesson));
  }
}

// ── Mark lesson complete ──────────────────────────────────────
async function markComplete(lesson) {
  const user = getUser();
  if (!user) {
    alert('Please log in to track your progress.');
    window.location.href = 'login.html';
    return;
  }
  if (!user.id) {
    // If we only have username in localStorage (simple auth), skip API call but show feedback
    showCompletionFeedback(lesson);
    return;
  }

  const btn = document.getElementById('btn-mark-complete');
  if (btn) { btn.disabled = true; btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...'; }

  try {
    await apiFetch('/api/progress', {
      method: 'POST',
      body: JSON.stringify({ user_id: user.id, lesson_id: lesson.id }),
    });
    completedIds.push(lesson.id);
    showCompletionFeedback(lesson);
    // Refresh sidebar to show checkmark
    renderSidebar(lesson.language, allLessons, lesson.id, completedIds);
  } catch (err) {
    if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fas fa-check"></i> Mark Complete'; }
    // Show error briefly
    const msg = document.getElementById('complete-msg');
    if (msg) {
      msg.style.display = 'block';
      msg.style.background = 'rgba(243,139,168,0.1)';
      msg.style.borderColor = 'rgba(243,139,168,0.25)';
      msg.style.color = 'var(--red)';
      msg.innerHTML = '<i class="fas fa-exclamation-circle"></i> Could not save progress. Are you logged in?';
    }
  }
}

function showCompletionFeedback(lesson) {
  const btn = document.getElementById('btn-mark-complete');
  if (btn) {
    btn.disabled = true;
    btn.className = 'btn-mark-complete done';
    btn.innerHTML = '<i class="fas fa-check-circle"></i> Completed!';
  }
  const msg = document.getElementById('complete-msg');
  if (msg) {
    msg.style.display = 'block';
    msg.style.background = 'rgba(67,233,123,0.1)';
    msg.style.borderColor = 'rgba(67,233,123,0.25)';
    msg.style.color = 'var(--green)';
    msg.innerHTML = `<i class="fas fa-star"></i> Lesson completed! You earned <strong>${lesson.xp_reward} XP</strong>. Keep going!`;
  }
}

// ── Open compiler with pre-filled code ───────────────────────
// Languages that cannot execute in the local Node/compiler environment
// react = JSX needs a browser bundler (Vite/CRA), not plain Node
// html  = runs in a browser, not Node
// sql   = needs a database engine
// bash  = runs in a terminal
const NON_RUNNABLE = ['bash', 'html', 'sql', 'react'];

function openCompiler(lesson) {
  if (NON_RUNNABLE.includes(lesson.language)) {
    // Copy code to clipboard and show a hint
    navigator.clipboard.writeText(lesson.code_example).catch(() => {});
    const btn = document.getElementById('btn-try-compiler');
    if (btn) {
      const original = btn.innerHTML;
      btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
      setTimeout(() => { btn.innerHTML = original; }, 2000);
    }
    return;
  }
  // Store code in localStorage so compiler.html can pick it up
  localStorage.setItem('coder_prefill_code', lesson.code_example);
  localStorage.setItem('coder_prefill_lang', lesson.language);
  window.location.href = 'compiler.html?lang=' + encodeURIComponent(lesson.language);
}

// ── Small helper: language icon class ────────────────────────
function getLangIcon(lang) {
  const icons = {
    python:     'fab fa-python',
    java:       'fab fa-java',
    javascript: 'fab fa-js-square',
    typescript: 'fas fa-code',
    cpp:        'fas fa-code',
    html:       'fab fa-html5',
    sql:        'fas fa-database',
    bash:       'fab fa-git-alt',
    react:      'fab fa-react',
  };
  return icons[lang] || 'fas fa-code';
}

// ── Main init ─────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', async () => {
  const { courseLang, lessonId } = getLessonParams();

  if (!lessonId) {
    document.getElementById('lesson-main').innerHTML =
      '<div style="padding:3rem; text-align:center; color:var(--red);"><i class="fas fa-exclamation-circle" style="font-size:2rem; display:block; margin-bottom:1rem;"></i>No lesson ID provided.</div>';
    return;
  }

  try {
    // Load lesson + completed progress in parallel; then fetch sibling lessons by course_id
    const [lesson, completed] = await Promise.all([
      apiFetch('/api/lessons/single/' + lessonId),
      fetchCompleted(),
    ]);

    currentLesson = lesson;
    completedIds  = completed;

    // Fetch all lessons for this course using the numeric course_id from the lesson
    allLessons = await apiFetch('/api/lessons/' + lesson.course_id).catch(() => []);

    // Update page title
    document.title = lesson.title + ' — Coder';

    renderSidebar(lesson.language, allLessons, lesson.id, completedIds);
    renderLesson(lesson, completedIds);
  } catch (err) {
    document.getElementById('lesson-main').innerHTML =
      `<div style="padding:3rem; text-align:center; color:var(--red);">
        <i class="fas fa-exclamation-circle" style="font-size:2rem; display:block; margin-bottom:1rem;"></i>
        Failed to load lesson. Make sure the server is running.<br/>
        <small style="color:var(--text-muted); margin-top:0.5rem; display:block;">${err.message || ''}</small>
      </div>`;
  }
});
