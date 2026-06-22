/* =============================================================
   CODER — profile.js
   Loads user profile data and course progress from API,
   renders stats, circular progress indicators, activity feed.
   ============================================================= */

// ── XP level thresholds (every 100 XP = 1 level) ─────────────
function getLevel(xp) {
  return Math.floor(xp / 100) + 1;
}
function getXpInLevel(xp) {
  return xp % 100;
}
function getXpToNextLevel() {
  return 100;
}

// ── Build circular SVG progress indicator ────────────────────
// radius=34, circumference=2*pi*34≈213.6
function buildCircularProgress(pct, color) {
  const circ   = 213.6;
  const offset = circ - (pct / 100) * circ;
  return `
    <div class="circular-progress">
      <svg viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
        <circle class="bg-circle" cx="40" cy="40" r="34"/>
        <circle class="fg-circle" cx="40" cy="40" r="34"
          style="stroke:${color}; stroke-dashoffset:${offset}"/>
      </svg>
      <div class="circular-pct" style="color:${color};">${pct}%</div>
    </div>`;
}

// ── Language colours for circular indicators ─────────────────
const LANG_COLORS = {
  python:     '#2196f3',
  java:       '#f57c00',
  javascript: '#f0c000',
  cpp:        '#005fa3',
  html:       '#e44d26',
  sql:        '#336791',
};

// ── Render course progress grid ───────────────────────────────
function renderCourseProgress(courses, lessonCounts, completedIds) {
  const grid = document.getElementById('profile-courses-grid');
  if (!grid) return;

  if (courses.length === 0) {
    grid.innerHTML = '<p style="color:var(--text-muted); font-size:0.875rem; grid-column:1/-1;">No courses available.</p>';
    return;
  }

  grid.innerHTML = courses.map(course => {
    const total     = lessonCounts[course.id] || 0;
    const done      = completedIds.filter(id => {
      // We tagged each lesson id with course_id when fetching
      return true; // We'll filter by course below using lessonIdsByCourse
    }).length;
    // Use per-course completed count stored in lessonIdsByCourse
    const courseDone = (window._profileCourseDone || {})[course.id] || 0;
    const pct        = total > 0 ? Math.round((courseDone / total) * 100) : 0;
    const color      = LANG_COLORS[course.language] || 'var(--accent)';
    const started    = courseDone > 0;

    return `
      <a href="course.html?id=${course.id}" class="profile-course-card" style="text-decoration:none;">
        ${buildCircularProgress(pct, color)}
        <div class="profile-course-name">${escapeHtml(course.title)}</div>
        <div class="profile-course-sub">${courseDone} / ${total} lessons</div>
        ${started ? '' : '<div style="font-size:0.72rem; color:var(--text-muted); margin-top:0.3rem;">Not started</div>'}
      </a>`;
  }).join('');

  // Animate circles after insertion
  requestAnimationFrame(() => {
    document.querySelectorAll('.fg-circle').forEach(el => {
      const offset = parseFloat(el.style.strokeDashoffset);
      el.style.strokeDashoffset = '213.6';
      requestAnimationFrame(() => {
        el.style.transition = 'stroke-dashoffset 1s ease';
        el.style.strokeDashoffset = offset;
      });
    });
  });
}

// ── Render recent activity feed ───────────────────────────────
function renderActivity(completedLessons) {
  const feed = document.getElementById('activity-feed');
  if (!feed) return;

  if (!completedLessons || completedLessons.length === 0) {
    feed.innerHTML = `
      <div style="background:var(--bg-card); border:1px solid var(--border); border-radius:10px; padding:2rem; text-align:center; color:var(--text-muted);">
        <i class="fas fa-leaf" style="font-size:2rem; margin-bottom:0.75rem; display:block;"></i>
        No activity yet. Complete your first lesson to get started!
      </div>`;
    return;
  }

  // Show last 10, most recent first
  const recent = [...completedLessons].reverse().slice(0, 10);

  feed.innerHTML = recent.map(item => `
    <div class="activity-item">
      <div class="activity-icon green"><i class="fas fa-check"></i></div>
      <div class="activity-text">
        <strong>Completed: ${escapeHtml(item.title || 'Lesson')}</strong>
        <p>${escapeHtml(item.course_title || '')} ${item.language ? '· ' + item.language.charAt(0).toUpperCase() + item.language.slice(1) : ''}</p>
      </div>
      <span class="activity-xp">+${item.xp_reward || 10} XP</span>
    </div>`).join('');
}

// ── Update the profile stats in the sidebar ───────────────────
function updateStats(totalXp, lessonsCompleted, coursesStarted) {
  const level    = getLevel(totalXp);
  const xpIn     = getXpInLevel(totalXp);
  const xpTo     = getXpToNextLevel();
  const xpPct    = Math.round((xpIn / xpTo) * 100);

  const setEl = (id, val) => { const el = document.getElementById(id); if (el) el.textContent = val; };
  setEl('stat-xp',      totalXp);
  setEl('stat-lessons', lessonsCompleted);
  setEl('stat-courses', coursesStarted);
  setEl('xp-level-label', 'Level ' + level);
  setEl('xp-next-label',  xpIn + ' / ' + xpTo + ' XP');

  // Streak: calculate from localStorage (simple approach)
  const streak = parseInt(localStorage.getItem('coder_streak') || '1', 10);
  setEl('stat-streak',    streak);
  setEl('streak-display', streak + (streak === 1 ? ' day' : ' days'));

  // XP bar
  const bar = document.getElementById('xp-bar-fill');
  if (bar) {
    bar.style.width = '0%';
    requestAnimationFrame(() => {
      bar.style.transition = 'width 0.8s ease';
      bar.style.width = xpPct + '%';
    });
  }
}

// ── Main init ─────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', async () => {
  const user = getUser();

  const gate    = document.getElementById('profile-gate');
  const content = document.getElementById('profile-content');

  if (!user) {
    // Show login gate
    if (gate)    gate.style.display    = 'flex';
    if (content) content.style.display = 'none';
    return;
  }

  if (gate)    gate.style.display    = 'none';
  if (content) content.style.display = 'block';

  // Fill in basic info
  const initial = (user.username || 'U').charAt(0).toUpperCase();
  const avatarEl = document.getElementById('profile-avatar');
  const nameEl   = document.getElementById('profile-username');
  const emailEl  = document.getElementById('profile-email');
  if (avatarEl) avatarEl.textContent = initial;
  if (nameEl)   nameEl.textContent   = user.username;
  if (emailEl)  emailEl.textContent  = user.email || '';

  // Update page title
  document.title = user.username + "'s Profile — Coder";

  try {
    // Fetch courses
    const courses = await apiFetch('/api/courses');

    // Fetch lesson counts per course and progress
    const lessonCountMap = {};
    const lessonsByCourse = {};

    const lessonFetches = courses.map(c =>
      apiFetch('/api/lessons/' + c.id)
        .then(lessons => {
          lessonCountMap[c.id] = lessons.length;
          lessonsByCourse[c.id] = lessons.map(l => l.id);
        })
        .catch(() => { lessonCountMap[c.id] = 0; lessonsByCourse[c.id] = []; })
    );
    await Promise.all(lessonFetches);

    // Fetch user's completed lesson ids (requires user.id)
    let completedIds = [];
    let completedDetails = [];
    if (user.id) {
      try {
        completedIds = await apiFetch('/api/progress/' + user.id);
      } catch { completedIds = []; }

      // Fetch full details for activity feed (best-effort)
      try {
        completedDetails = await apiFetch('/api/progress/details/' + user.id);
      } catch { completedDetails = []; }
    }

    // Compute per-course completion counts
    window._profileCourseDone = {};
    let coursesStarted = 0;
    courses.forEach(c => {
      const cIds = lessonsByCourse[c.id] || [];
      const done  = cIds.filter(id => completedIds.includes(id)).length;
      window._profileCourseDone[c.id] = done;
      if (done > 0) coursesStarted++;
    });

    // Compute total XP (10 XP per lesson as fallback)
    const totalXp = completedIds.length * 15; // avg estimate if no details

    updateStats(totalXp, completedIds.length, coursesStarted);
    renderCourseProgress(courses, lessonCountMap, completedIds);
    renderActivity(completedDetails.length > 0 ? completedDetails : []);

  } catch (err) {
    const grid = document.getElementById('profile-courses-grid');
    if (grid) grid.innerHTML = `<p style="color:var(--red); grid-column:1/-1;">Failed to load profile data. Is the server running?</p>`;
  }
});
