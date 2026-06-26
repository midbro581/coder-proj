/* =============================================================
   CODER — public/js/courses.js
   Data source: Static JSON file → /data/courses.json
   Container:   id="courses-grid"   (courses.html)
   Also:        id="services-container" if used on a separate page
   ============================================================= */

// -- Utility ---------------------------------------------------

function escapeHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// Level → badge colour mapping
const LEVEL_COLORS = {
  'Beginner':     { bg: 'rgba(16,185,129,0.15)', text: '#10b981' },
  'Intermediate': { bg: 'rgba(234,179,8,0.15)',  text: '#eab308' },
  'Advanced':     { bg: 'rgba(239,68,68,0.15)',  text: '#ef4444' }
};

function levelBadge(level) {
  const c = LEVEL_COLORS[level] || { bg: 'rgba(108,99,255,0.15)', text: '#6c63ff' };
  return `<span style="
    background:${c.bg}; color:${c.text};
    padding:0.25rem 0.7rem; border-radius:20px;
    font-size:0.72rem; font-weight:700; letter-spacing:0.5px;
    text-transform:uppercase;">${escapeHtml(level)}</span>`;
}

// Build a single service card from a course object
function buildCard(course) {
  const color = course.color || '#6c63ff';
  const icon  = course.icon  || 'fas fa-code';
  return `
    <div class="card course-card"
         data-level="${escapeHtml(course.level)}"
         style="padding:1.75rem; display:flex; flex-direction:column; gap:1rem; transition:transform 0.2s;">
      <!-- Icon -->
      <div style="
        width:52px; height:52px; border-radius:12px;
        background:${color}22;
        display:flex; align-items:center; justify-content:center;
        font-size:1.5rem; color:${color}; flex-shrink:0;">
        <i class="${escapeHtml(icon)}"></i>
      </div>
      <!-- Title + Level -->
      <div style="display:flex; align-items:center; gap:0.6rem; flex-wrap:wrap;">
        <h3 style="font-size:1.05rem; font-weight:700; margin:0;">${escapeHtml(course.title)}</h3>
        ${levelBadge(course.level)}
      </div>
      <!-- Description -->
      <p style="color:var(--text-sub); font-size:0.875rem; line-height:1.7; margin:0; flex:1;">
        ${escapeHtml(course.description)}
      </p>
      <!-- Meta row -->
      <div style="display:flex; gap:1.25rem; flex-wrap:wrap; padding-top:0.75rem;
                  border-top:1px solid var(--border); font-size:0.8rem; color:var(--text-muted);">
        <span><i class="fas fa-clock" style="color:${color}; margin-right:0.3rem;"></i>${escapeHtml(course.duration)}</span>
        <span><i class="fas fa-book-open" style="color:${color}; margin-right:0.3rem;"></i>${course.lessons} lessons</span>
        <span><i class="fas fa-code" style="color:${color}; margin-right:0.3rem;"></i>${escapeHtml(course.language)}</span>
      </div>
    </div>`;
}

// ===============================================================
// STEP 3 — JSON Integration: Load Services from courses.json
// Source:    /data/courses.json
// Container: id="courses-grid"  (primary) or id="services-container"
// ===============================================================

let allCourses = [];  // Cache for filter operations

async function loadServices() {
  // Support both container IDs — courses.html uses "courses-grid",
  // a separate services page can use "services-container"
  const container = document.getElementById('courses-grid')
                 || document.getElementById('services-container');
  if (!container) return;

  container.innerHTML = '<div class="loading-container"><div class="spinner"></div></div>';

  try {
    const res = await fetch('/data/courses.json');
    if (!res.ok) throw new Error(`Failed to load courses.json (${res.status})`);

    const data = await res.json();

    // Validate expected shape
    if (!data.courses || !Array.isArray(data.courses)) {
      throw new Error('courses.json is missing a "courses" array.');
    }

    allCourses = data.courses;

    if (!allCourses.length) {
      container.innerHTML = '<p style="color:var(--text-muted);text-align:center;padding:2rem;">No services found.</p>';
      return;
    }

    renderCards(allCourses, container);
    initFilters(container);

  } catch (err) {
    console.error('loadServices error:', err);
    container.innerHTML = `
      <p style="color:var(--text-muted); text-align:center; padding:2rem; grid-column:1/-1;">
        Could not load services: ${escapeHtml(err.message)}
      </p>`;
  }
}

// Render a given array of course objects into the container
function renderCards(courses, container) {
  if (!container) return;
  if (!courses.length) {
    container.innerHTML = '<p style="color:var(--text-muted);text-align:center;padding:2rem;grid-column:1/-1;">No courses match this filter.</p>';
    return;
  }
  container.innerHTML = courses.map(buildCard).join('');
}

// -- Filter Buttons (Beginner / Intermediate / Advanced / All) -

function initFilters(container) {
  const buttons = document.querySelectorAll('.filter-btn');
  if (!buttons.length) return;

  buttons.forEach(btn => {
    btn.addEventListener('click', () => {
      // Toggle active state
      buttons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const filter = btn.dataset.filter;
      const filtered = filter === 'all'
        ? allCourses
        : allCourses.filter(c => c.level === filter);

      renderCards(filtered, container);
    });
  });
}

// -- Init ------------------------------------------------------

document.addEventListener('DOMContentLoaded', () => {
  loadServices();
});
