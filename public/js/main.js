/*
 * CODER — main.js (external JavaScript file)
 * Global utilities: auth state management, navbar, API helper
 */

// -- Auth State -----------------------------------------------
// We store the logged-in username (and optionally id/email)
// in localStorage after a successful login.

function getUser() {
  const username = localStorage.getItem('coder_username');
  const id       = localStorage.getItem('coder_user_id');
  const email    = localStorage.getItem('coder_email');
  if (!username) return null;
  return { username, id: id ? parseInt(id, 10) : null, email: email || '' };
}

function logout() {
  localStorage.removeItem('coder_username');
  localStorage.removeItem('coder_user_id');
  localStorage.removeItem('coder_email');
  window.location.href = 'index.html';
}

function updateNavAuth() {
  const user      = getUser();
  const navAuth   = document.getElementById('navAuth');
  const userInfo  = document.getElementById('nav-user-info');
  const nameEl    = document.getElementById('nav-username');
  const profileLinkEl = document.getElementById('nav-profile-link');

  if (user) {
    if (navAuth)  navAuth.style.display  = 'none';
    if (userInfo) userInfo.style.display = 'flex';
    if (nameEl)   nameEl.textContent     = user.username;
    // Update the profile link text to show username
    if (profileLinkEl) {
      profileLinkEl.innerHTML = `<i class="fas fa-user-circle"></i> ${escapeHtml(user.username)}`;
    }
  } else {
    if (navAuth)  navAuth.style.display  = 'flex';
    if (userInfo) userInfo.style.display = 'none';
  }
}

// -- Hamburger Menu -------------------------------------------
function initHamburger() {
  const btn   = document.getElementById('hamburger');
  const links = document.getElementById('navLinks');
  if (!btn || !links) return;

  btn.addEventListener('click', () => links.classList.toggle('open'));
  links.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => links.classList.remove('open'));
  });
}

// -- API Fetch Helper -----------------------------------------
// Wraps fetch() to always send/receive JSON and throw on error responses
async function apiFetch(url, options = {}) {
  const user = getUser();
  const authHeaders = (user && user.username)
    ? { 'X-Username': user.username, 'X-User-Id': String(user.id || '') }
    : {};
  const headers = { 'Content-Type': 'application/json', ...authHeaders, ...(options.headers || {}) };
  const res  = await fetch(url, { ...options, headers });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || 'Request failed');
  return data;
}

// -- Render star ratings --------------------------------------
function renderStars(rating) {
  return Array.from({ length: 5 }, (_, i) =>
    '<i class="fas fa-star" style="color:' + (i < rating ? 'var(--yellow)' : 'var(--border)') + '"></i>'
  ).join('');
}

// -- Escape HTML to prevent XSS when displaying user content -
function escapeHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// -- Homepage: Load Courses Preview --------------------------
async function loadHomeCourses() {
  const container = document.getElementById('home-courses');
  if (!container) return;
  try {
    const res  = await fetch('/data/courses.json');
    const data = await res.json();
    const top3 = data.courses.slice(0, 3);
    container.innerHTML = top3.map(c => `
      <div class="card" style="display:flex;flex-direction:column;gap:1rem;">
        <div style="font-size:2rem;"><i class="${c.icon || 'fas fa-code'}"></i></div>
        <h3 style="font-size:1.1rem;margin:0;">${escapeHtml(c.title)}</h3>
        <p style="color:var(--text-sub);font-size:0.875rem;margin:0;flex:1;">${escapeHtml(c.description || '')}</p>
        <span style="display:inline-block;background:rgba(108,99,255,.15);color:var(--accent);padding:.25rem .75rem;border-radius:999px;font-size:.78rem;font-weight:600;">${escapeHtml(c.difficulty || c.level || '')}</span>
      </div>
    `).join('');
  } catch (err) {
    container.innerHTML = '<p style="color:var(--text-sub);text-align:center;">Could not load courses.</p>';
  }
}

// -- Homepage: Load Testimonials Preview ----------------------
async function loadHomeTestimonials() {
  const container = document.getElementById('home-testimonials');
  if (!container) return;
  try {
    const data  = await apiFetch('/api/comments');
    const items = Array.isArray(data) ? data : (data.comments || []);
    const top3  = items.slice(0, 3);
    if (top3.length === 0) throw new Error('empty');
    container.innerHTML = top3.map(c => `
      <div class="card" style="display:flex;flex-direction:column;gap:.75rem;">
        <div style="display:flex;align-items:center;gap:.75rem;">
          <div style="width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,var(--accent),#a78bfa);display:flex;align-items:center;justify-content:center;font-weight:700;color:#fff;flex-shrink:0;">${escapeHtml((c.name || '?')[0].toUpperCase())}</div>
          <div>
            <div style="font-weight:600;font-size:.95rem;">${escapeHtml(c.name || 'Anonymous')}</div>
            <div style="color:var(--text-muted);font-size:.78rem;">${escapeHtml(c.email || '')}</div>
          </div>
        </div>
        <p style="color:var(--text-sub);font-size:.9rem;line-height:1.6;margin:0;">"${escapeHtml(c.message || c.body || '')}"</p>
      </div>
    `).join('');
  } catch (err) {
    container.innerHTML = '<p style="color:var(--text-sub);text-align:center;">No testimonials yet.</p>';
  }
}

// -- Init on every page ---------------------------------------
document.addEventListener('DOMContentLoaded', () => {
  updateNavAuth();
  initHamburger();
  loadHomeCourses();
  loadHomeTestimonials();
});
