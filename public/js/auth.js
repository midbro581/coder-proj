/*
 * CODER — auth.js (external JavaScript file)
 * Handles login and register form submissions
 * Communicates with Node.js backend via fetch()
 */

// Show an alert message (error or success)
function showAlert(type, message) {
  const el = document.getElementById('alert-' + type);
  if (!el) return;
  el.textContent = message;
  el.classList.add('show');
  if (type === 'success') {
    setTimeout(() => el.classList.remove('show'), 5000);
  }
}

function hideAlerts() {
  ['error', 'success'].forEach(t => {
    document.getElementById('alert-' + t)?.classList.remove('show');
  });
}

// Toggle button loading state
function setLoading(btnId, isLoading, originalHtml) {
  const btn = document.getElementById(btnId);
  if (!btn) return;
  btn.disabled  = isLoading;
  btn.innerHTML = isLoading
    ? '<i class="fas fa-spinner fa-spin"></i> Please wait...'
    : originalHtml;
}

// ── Password visibility toggle ───────────────────────────────
function initPasswordToggles() {
  [['toggle-pw', 'password'], ['toggle-pw2', 'confirm-password']].forEach(([btnId, inputId]) => {
    const btn   = document.getElementById(btnId);
    const input = document.getElementById(inputId);
    if (!btn || !input) return;
    btn.addEventListener('click', () => {
      const isText  = input.type === 'text';
      input.type    = isText ? 'password' : 'text';
      btn.innerHTML = isText
        ? '<i class="fas fa-eye"></i>'
        : '<i class="fas fa-eye-slash"></i>';
    });
  });
}

// ── Login form ───────────────────────────────────────────────
function initLoginForm() {
  const form = document.getElementById('login-form');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    hideAlerts();

    // Client-side validation first
    if (!validateLoginForm()) return;

    setLoading('login-btn', true, '<i class="fas fa-sign-in-alt"></i> Log In');

    try {
      // POST credentials to Node.js backend.
      // "identifier" may be an email OR a username — the server resolves either.
      const data = await apiFetch('/api/auth/login', {
        method: 'POST',
        body: JSON.stringify({
          identifier: document.getElementById('identifier').value.trim(),
          password:   document.getElementById('password').value
        })
      });

      // Store user info in localStorage (simple client-side auth state)
      localStorage.setItem('coder_username', data.username);
      if (data.id)    localStorage.setItem('coder_user_id', data.id);
      if (data.email) localStorage.setItem('coder_email',   data.email);
      showAlert('success', 'Login successful! Redirecting...');
      setTimeout(() => { window.location.href = 'index.html'; }, 1000);

    } catch (err) {
      showAlert('error', err.message || 'Login failed. Please try again.');
      setLoading('login-btn', false, '<i class="fas fa-sign-in-alt"></i> Log In');
    }
  });
}

// ── Register form ────────────────────────────────────────────
function initRegisterForm() {
  const form = document.getElementById('register-form');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    hideAlerts();

    // Client-side validation first
    if (!validateRegisterForm()) return;

    setLoading('register-btn', true, '<i class="fas fa-user-plus"></i> Create Account');

    try {
      // POST registration data to Node.js backend
      const data = await apiFetch('/api/auth/register', {
        method: 'POST',
        body: JSON.stringify({
          username: document.getElementById('username').value.trim(),
          email:    document.getElementById('email').value.trim(),
          password: document.getElementById('password').value
        })
      });

      // Auto-login after registration — store user info
      localStorage.setItem('coder_username', data.username);
      if (data.id)    localStorage.setItem('coder_user_id', data.id);
      if (data.email) localStorage.setItem('coder_email',   data.email);
      showAlert('success', 'Account created! Redirecting...');
      setTimeout(() => { window.location.href = 'index.html'; }, 1000);

    } catch (err) {
      showAlert('error', err.message || 'Registration failed. Please try again.');
      setLoading('register-btn', false, '<i class="fas fa-user-plus"></i> Create Account');
    }
  });
}

// ── Redirect if already logged in ───────────────────────────
if (getUser()) {
  window.location.href = 'index.html';
}

document.addEventListener('DOMContentLoaded', () => {
  initPasswordToggles();
  initLoginForm();
  initRegisterForm();
});
