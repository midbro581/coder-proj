/* =============================================================
   CODER — courses.js
   Loads courses from API, renders SoloLearn-style cards,
   handles filter & modal
   ============================================================= */

const BADGE_CLASS = {
  Beginner:     'badge-beginner',
  Intermediate: 'badge-intermediate',
  Advanced:     'badge-advanced',
};

// Build a SoloLearn-style course card with gradient header
function buildCourseCard(course, progress) {
  const pct = progress ? Math.round((progress.done / progress.total) * 100) : 0;
  const showProgress = progress && progress.total > 0;

  return `
    <div class="course-card" data-level="${course.level}" data-lang="${course.language}"
         onclick="openCourseModal(${course.id})" style="cursor:pointer;">
      <div class="course-card-header">
        <i class="${course.icon} course-card-icon"></i>
        <span class="course-card-level">${course.level}</span>
      </div>
      <div class="course-card-body">
        <h3>${escapeHtml(course.title)}</h3>
        <p>${escapeHtml(course.description)}</p>
        <div class="course-meta">
          <span><i class="fas fa-clock"></i> ${escapeHtml(course.duration)}</span>
          <span><i class="fas fa-book-open"></i> ${course.lessons} lessons</span>
        </div>
        ${showProgress ? `
          <div style="margin-bottom:0.5rem;">
            <div style="display:flex; justify-content:space-between; font-size:0.75rem; color:var(--text-muted); margin-bottom:0.3rem;">
              <span>${progress.done} of ${progress.total} complete</span>
              <span>${pct}%</span>
            </div>
            <div class="course-progress-bar">
              <div class="course-progress-fill" style="width:${pct}%"></div>
            </div>
          </div>
        ` : ''}
        <div class="course-card-footer">
          <span class="lessons-count"><i class="fas fa-book"></i> ${course.lessons} lessons</span>
          <a href="course.html?id=${course.id}" class="btn-start" onclick="event.stopPropagation()">
            ${pct > 0 ? 'Continue' : 'Start'} <i class="fas fa-arrow-right"></i>
          </a>
        </div>
      </div>
    </div>`;
}

// ── Home Page: show courses + testimonials ───────────────────
async function loadHomeContent() {
  const coursesEl      = document.getElementById('home-courses');
  const testimonialsEl = document.getElementById('home-testimonials');

  if (coursesEl) {
    try {
      const courses = await apiFetch('/api/courses');
      coursesEl.innerHTML = courses.map(c => buildCourseCard(c)).join('');
    } catch {
      coursesEl.innerHTML = '<p style="color:var(--text-muted); text-align:center; padding:2rem;">Failed to load courses.</p>';
    }
  }

  if (testimonialsEl) {
    try {
      const testimonials = await apiFetch('/api/content/testimonials');
      testimonialsEl.innerHTML = testimonials.map(t => `
        <div class="testimonial-card">
          <div class="stars">${renderStars(t.rating)}</div>
          <p>"${escapeHtml(t.content)}"</p>
          <div class="testimonial-author">
            <div class="author-avatar">${(t.student_name || 'A')[0].toUpperCase()}</div>
            <div>
              <div class="author-name">${escapeHtml(t.student_name)}</div>
              <div class="author-course">${escapeHtml(t.course_completed)} Graduate</div>
            </div>
          </div>
        </div>`).join('');
    } catch {
      testimonialsEl.innerHTML = '<p style="color:var(--text-muted); text-align:center; padding:2rem;">Failed to load testimonials.</p>';
    }
  }
}

// ── Courses Page: full grid + filter ────────────────────────
let allCourses = [];

async function loadCoursesPage() {
  const grid = document.getElementById('courses-grid');
  if (!grid) return;

  try {
    allCourses = await apiFetch('/api/courses');
    renderCourses(allCourses);
    initFilter();
  } catch {
    grid.innerHTML = '<p style="color:var(--text-muted); text-align:center; padding:2rem;">Failed to load courses. Make sure the server is running.</p>';
  }
}

function renderCourses(courses) {
  const grid = document.getElementById('courses-grid');
  if (!grid) return;
  grid.innerHTML = courses.length
    ? courses.map(c => buildCourseCard(c)).join('')
    : '<p style="color:var(--text-muted); text-align:center; padding:2rem;">No courses found for this filter.</p>';
}

function initFilter() {
  document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const filter = btn.dataset.filter;
      renderCourses(filter === 'all' ? allCourses : allCourses.filter(c => c.level === filter));
    });
  });
}

// ── Course Detail Modal ──────────────────────────────────────
async function openCourseModal(id) {
  const modal   = document.getElementById('course-modal');
  const content = document.getElementById('modal-content');
  if (!modal || !content) return;

  modal.style.display = 'flex';
  content.innerHTML   = '<div class="loading-container"><div class="spinner"></div></div>';

  try {
    const course = await apiFetch('/api/courses/' + id);

    // Load topics from JSON file
    let topics = [];
    try {
      const json  = await fetch('/data/courses.json').then(r => r.json());
      const match = json.courses.find(c => c.language === course.language);
      if (match) topics = match.topics;
    } catch { /* ignore */ }

    content.innerHTML = `
      <div style="display:flex; align-items:center; gap:1rem; margin-bottom:1.5rem;">
        <div style="width:64px; height:64px; border-radius:12px; background:${course.color}22; color:${course.color}; display:flex; align-items:center; justify-content:center; font-size:2rem; flex-shrink:0;">
          <i class="${course.icon}"></i>
        </div>
        <div>
          <h2 style="font-size:1.5rem; font-weight:800; margin-bottom:0.25rem;">${escapeHtml(course.title)}</h2>
          <span class="course-badge ${BADGE_CLASS[course.level] || 'badge-beginner'}">${course.level}</span>
        </div>
      </div>
      <p style="color:var(--text-sub); line-height:1.7; margin-bottom:1.5rem;">${escapeHtml(course.description)}</p>
      <div class="course-meta" style="margin-bottom:1.5rem;">
        <span><i class="fas fa-clock"></i> ${escapeHtml(course.duration)}</span>
        <span><i class="fas fa-book"></i> ${course.lessons} lessons</span>
      </div>
      ${topics.length ? `
        <h4 style="font-size:0.82rem; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:var(--text-muted); margin-bottom:0.75rem;">Topics Covered</h4>
        <div style="margin-bottom:1.5rem;">${topics.map(t => `<span class="topic-tag">${escapeHtml(t)}</span>`).join('')}</div>
      ` : ''}
      <div style="display:flex; gap:1rem; flex-wrap:wrap;">
        <a href="course.html?id=${course.id}" class="btn btn-primary"><i class="fas fa-play"></i> Start Course</a>
        <a href="compiler.html?lang=${encodeURIComponent(course.language)}" class="btn btn-secondary"><i class="fas fa-code"></i> Try Compiler</a>
      </div>`;
  } catch {
    content.innerHTML = '<p style="color:var(--red);">Failed to load course details.</p>';
  }
}

document.addEventListener('DOMContentLoaded', () => {
  // Close modal on button / backdrop / Escape
  const closeBtn = document.getElementById('modal-close');
  const modal    = document.getElementById('course-modal');
  if (closeBtn) closeBtn.addEventListener('click', () => { if (modal) modal.style.display = 'none'; });
  if (modal)    modal.addEventListener('click', (e) => { if (e.target === modal) modal.style.display = 'none'; });
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape' && modal) modal.style.display = 'none'; });

  loadHomeContent();
  loadCoursesPage();
});
