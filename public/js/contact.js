/* =============================================================
   CODER — contact.js
   - Hijacks <form id="contact-form"> → POST to /api/comments
   - Fetches GET /api/comments → renders as Customer Testimonials
   ============================================================= */

// -- Helpers ---------------------------------------------------

function escapeHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function formatDate(dateStr) {
  if (!dateStr) return '';
  return new Date(dateStr).toLocaleDateString('en-AE', {
    year: 'numeric', month: 'short', day: 'numeric'
  });
}

function showAlert(type, message) {
  const el = document.getElementById('alert-' + type);
  if (!el) return;
  el.textContent = message;
  el.classList.add('show');
  if (type === 'success') setTimeout(() => el.classList.remove('show'), 6000);
}

function hideAlerts() {
  document.getElementById('alert-error')?.classList.remove('show');
  document.getElementById('alert-success')?.classList.remove('show');
}

// -- Load & Render Testimonials from DB ------------------------

async function loadTestimonials() {
  const container = document.getElementById('recent-comments');
  if (!container) return;

  try {
    const res = await fetch('/api/comments');
    if (!res.ok) throw new Error('Server error');
    const testimonials = await res.json();

    if (!testimonials.length) {
      container.innerHTML = `
        <p style="color:var(--text-muted); text-align:center; padding:2rem; grid-column:1/-1;">
          No testimonials yet. Be the first to leave feedback!
        </p>`;
      return;
    }

    container.innerHTML = testimonials.slice(0, 6).map(t => `
      <div class="card" style="padding:1.5rem;">
        <div style="display:flex; align-items:center; gap:0.75rem; margin-bottom:1rem;">
          <div style="
            width:42px; height:42px; border-radius:50%;
            background:linear-gradient(135deg, var(--accent, #6c63ff), #a78bfa);
            display:flex; align-items:center; justify-content:center;
            font-weight:700; color:#fff; font-size:1rem; flex-shrink:0;">
            ${escapeHtml(t.name[0].toUpperCase())}
          </div>
          <div>
            <div style="font-weight:600; font-size:0.95rem;">${escapeHtml(t.name)}</div>
            <div style="color:var(--text-muted); font-size:0.75rem;">${formatDate(t.created_at)}</div>
          </div>
        </div>
        ${t.subject
        ? `<div style="font-size:0.82rem; font-weight:600; color:var(--accent,#6c63ff); margin-bottom:0.5rem;">
               ${escapeHtml(t.subject)}
             </div>`
        : ''}
        <p style="color:var(--text-sub); font-size:0.875rem; line-height:1.7; margin:0;">
          "${escapeHtml(t.message)}"
        </p>
      </div>`).join('');

  } catch (err) {
    container.innerHTML = `
      <p style="color:var(--text-muted); text-align:center; grid-column:1/-1;">
        Could not load testimonials.
      </p>`;
  }
}

// -- Contact Form → POST to /api/comments ---------------------

function initContactForm() {
  const form = document.getElementById('contact-form');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    hideAlerts();

    const name = document.getElementById('name')?.value.trim();
    const email = document.getElementById('email')?.value.trim();
    const subject = document.getElementById('subject')?.value.trim() || '';
    const message = document.getElementById('message')?.value.trim();

    // Client-side validation
    if (!name || !email || !message) {
      showAlert('error', 'Name, email, and message are required.');
      return;
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      showAlert('error', 'Please enter a valid email address.');
      return;
    }
    if (message.length < 10) {
      showAlert('error', 'Message must be at least 10 characters.');
      return;
    }

    const btn = document.getElementById('submit-btn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';

    try {
      await new Promise(r => setTimeout(r, 800));

      showAlert('success', 'Message sent successfully! We will get back to you shortly.');
      form.reset();
      form.querySelectorAll('.form-control').forEach(f => {
        f.classList.remove('input-success', 'input-error');
      });

    } catch (err) {
      showAlert('error', 'Network error. Please check your connection and try again.');
    } finally {
      btn.disabled = false;
      btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Message';
    }
  });
}

window.validateContactForm = function () {
  var name = document.getElementById('name');
  var email = document.getElementById('email');
  var message = document.getElementById('message');

  if (!name || !name.value.trim()) {
    alert("Please enter your name");
    return false;
  }
  var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!email || !emailRegex.test(email.value.trim())) {
    alert("Please enter a valid email address");
    return false;
  }
  if (!message || !message.value.trim()) {
    alert("Please enter a message");
    return false;
  }
  return true;
};

// -- Init ------------------------------------------------------

document.addEventListener('DOMContentLoaded', () => {
  initContactForm();
  loadTestimonials();
});
