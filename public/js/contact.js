/* =============================================================
   CODER — contact.js
   Contact form submission + load recent comments from DB
   ============================================================= */

function showContactAlert(type, message) {
  const el = document.getElementById('alert-' + type);
  if (!el) return;
  el.textContent = message;
  el.classList.add('show');
  if (type === 'success') setTimeout(() => el.classList.remove('show'), 6000);
}

function hideContactAlerts() {
  document.getElementById('alert-error')?.classList.remove('show');
  document.getElementById('alert-success')?.classList.remove('show');
}

async function loadRecentComments() {
  const el = document.getElementById('recent-comments');
  if (!el) return;
  try {
    const comments = await apiFetch('/api/comments');
    if (!comments.length) {
      el.innerHTML = '<p style="color:var(--text-muted); text-align:center; padding:2rem;">No messages yet. Be the first to leave feedback!</p>';
      return;
    }
    el.innerHTML = comments.slice(0, 6).map(c => `
      <div class="card">
        <div style="display:flex; align-items:center; gap:0.75rem; margin-bottom:0.75rem;">
          <div style="width:38px; height:38px; border-radius:50%; background:linear-gradient(135deg,var(--accent),var(--accent2)); display:flex; align-items:center; justify-content:center; font-weight:700; color:#000; font-size:0.9rem; flex-shrink:0;">
            ${c.name[0].toUpperCase()}
          </div>
          <div>
            <div style="font-weight:600; font-size:0.9rem;">${escapeHtml(c.name)}</div>
            <div style="color:var(--text-muted); font-size:0.75rem;">${formatDate(c.created_at)}</div>
          </div>
        </div>
        ${c.subject ? `<div style="font-size:0.82rem; font-weight:600; color:var(--accent); margin-bottom:0.4rem;">${escapeHtml(c.subject)}</div>` : ''}
        <p style="color:var(--text-secondary); font-size:0.875rem; line-height:1.6;">${escapeHtml(c.message)}</p>
      </div>`).join('');
  } catch {
    el.innerHTML = '<p style="color:var(--text-muted); text-align:center;">Could not load recent messages.</p>';
  }
}

function escapeHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function formatDate(dateStr) {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  return d.toLocaleDateString('en-AE', { year: 'numeric', month: 'short', day: 'numeric' });
}

function initContactForm() {
  const form = document.getElementById('contact-form');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    hideContactAlerts();

    if (!validateContactForm()) return;

    const btn = document.getElementById('submit-btn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';

    try {
      await apiFetch('/api/comments', {
        method: 'POST',
        body: JSON.stringify({
          name: document.getElementById('name').value.trim(),
          email: document.getElementById('email').value.trim(),
          subject: document.getElementById('subject')?.value.trim() || '',
          message: document.getElementById('message').value.trim()
        })
      });

      showContactAlert('success', '✓ Message sent! We\'ll get back to you within 24 hours.');
      form.reset();
      // Remove success/error styling from fields
      form.querySelectorAll('.form-control').forEach(f => f.classList.remove('input-success', 'input-error'));
      // Refresh comments list
      setTimeout(loadRecentComments, 500);
    } catch (err) {
      showContactAlert('error', err.message || 'Failed to send message. Please try again.');
    } finally {
      btn.disabled = false;
      btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Message';
    }
  });
}

document.addEventListener('DOMContentLoaded', () => {
  initContactForm();
  loadRecentComments();
});
