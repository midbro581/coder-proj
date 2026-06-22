/*
 * CODER — main.js (external JavaScript file)
 * Global utilities: auth state management, navbar, API helper
 */

// ── Auth State ───────────────────────────────────────────────
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

// ── Hamburger Menu ───────────────────────────────────────────
function initHamburger() {
  const btn   = document.getElementById('hamburger');
  const links = document.getElementById('navLinks');
  if (!btn || !links) return;

  btn.addEventListener('click', () => links.classList.toggle('open'));
  links.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => links.classList.remove('open'));
  });
}

// ── API Fetch Helper ─────────────────────────────────────────
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

// ── Render star ratings ──────────────────────────────────────
function renderStars(rating) {
  return Array.from({ length: 5 }, (_, i) =>
    '<i class="fas fa-star" style="color:' + (i < rating ? 'var(--yellow)' : 'var(--border)') + '"></i>'
  ).join('');
}

// ── Escape HTML to prevent XSS when displaying user content ─
function escapeHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// ── Init on every page ───────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  updateNavAuth();
  initHamburger();
});
