/* =============================================================
   CODER — team.js
   Loads team members and history table from API
   ============================================================= */

const AVATAR_COLORS = ['#00d4aa', '#7c3aed', '#58a6ff', '#e3b341', '#f85149', '#3fb950'];

async function loadTeam() {
  const el = document.getElementById('team-grid');
  if (!el) return;
  try {
    const team = await apiFetch('/api/content/team');
    el.innerHTML = team.map((m, i) => `
      <div class="team-card">
        <div class="team-avatar" style="background: linear-gradient(135deg, ${AVATAR_COLORS[i % AVATAR_COLORS.length]}, ${AVATAR_COLORS[(i + 2) % AVATAR_COLORS.length]});">
          ${m.name.split(' ').map(w => w[0]).slice(0, 2).join('')}
        </div>
        <h3>${m.name}</h3>
        <div class="team-role">${m.role}</div>
        <p class="team-bio">${m.bio}</p>
        <div class="team-links">
          <a href="${m.linkedin || '#'}" title="LinkedIn" aria-label="LinkedIn"><i class="fab fa-linkedin"></i></a>
          <a href="${m.github || '#'}" title="GitHub" aria-label="GitHub"><i class="fab fa-github"></i></a>
        </div>
      </div>`).join('');
  } catch {
    el.innerHTML = '<p style="color:var(--text-muted); text-align:center;">Failed to load team members.</p>';
  }
}

async function loadProgressTable() {
  const tbody = document.getElementById('progress-tbody');
  if (!tbody) return;
  try {
    const history = await apiFetch('/api/content/history');
    tbody.innerHTML = history.map((h, i) => `
      <tr style="border-bottom:1px solid var(--border); background:${i % 2 === 0 ? 'transparent' : 'rgba(255,255,255,0.02)'};">
        <td style="padding:1rem; font-weight:700; color:var(--accent);">${h.year_val}</td>
        <td style="padding:1rem; font-weight:600;">${h.milestone}</td>
        <td style="padding:1rem; color:var(--text-secondary); font-size:0.9rem;">${h.description}</td>
      </tr>`).join('');
  } catch {
    tbody.innerHTML = '<tr><td colspan="3" style="padding:1rem; color:var(--text-muted);">Failed to load data.</td></tr>';
  }
}

document.addEventListener('DOMContentLoaded', () => {
  loadTeam();
  loadProgressTable();
});
