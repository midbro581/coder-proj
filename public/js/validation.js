/* =============================================================
   CODER — validation.js
   Client-side form validation utilities
   ============================================================= */

function showError(fieldId, errorId, message) {
  const field = document.getElementById(fieldId);
  const error = document.getElementById(errorId);
  if (field) field.classList.add('input-error');
  if (field) field.classList.remove('input-success');
  if (error) { error.textContent = message; error.classList.add('show'); }
}

function showSuccess(fieldId, errorId) {
  const field = document.getElementById(fieldId);
  const error = document.getElementById(errorId);
  if (field) { field.classList.remove('input-error'); field.classList.add('input-success'); }
  if (error) error.classList.remove('show');
}

function clearField(fieldId, errorId) {
  const field = document.getElementById(fieldId);
  const error = document.getElementById(errorId);
  if (field) { field.classList.remove('input-error', 'input-success'); }
  if (error) error.classList.remove('show');
}

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim());
}

function isValidUsername(username) {
  return /^[a-zA-Z0-9_]{3,20}$/.test(username.trim());
}

// Validate login form — accepts EITHER a valid email or a valid username
function validateLoginForm() {
  let valid = true;
  const identifier = document.getElementById('identifier')?.value.trim();
  const password = document.getElementById('password')?.value;

  if (!identifier) {
    showError('identifier', 'identifier-error', 'Email or username is required.');
    valid = false;
  } else if (!isValidEmail(identifier) && !isValidUsername(identifier)) {
    showError('identifier', 'identifier-error', 'Enter a valid email or username (3–20 letters/numbers/underscores).');
    valid = false;
  } else {
    showSuccess('identifier', 'identifier-error');
  }

  if (!password) {
    showError('password', 'password-error', 'Password is required.');
    valid = false;
  } else if (password.length < 6) {
    showError('password', 'password-error', 'Password must be at least 6 characters.');
    valid = false;
  } else {
    showSuccess('password', 'password-error');
  }

  return valid;
}

// Validate register form — returns true if valid
function validateRegisterForm() {
  let valid = true;
  const username = document.getElementById('username')?.value.trim();
  const email = document.getElementById('email')?.value.trim();
  const password = document.getElementById('password')?.value;
  const confirm = document.getElementById('confirm-password')?.value;

  if (!username) {
    showError('username', 'username-error', 'Username is required.');
    valid = false;
  } else if (!isValidUsername(username)) {
    showError('username', 'username-error', 'Username must be 3–20 characters (letters, numbers, underscores).');
    valid = false;
  } else {
    showSuccess('username', 'username-error');
  }

  if (!email) {
    showError('email', 'email-error', 'Email is required.');
    valid = false;
  } else if (!isValidEmail(email)) {
    showError('email', 'email-error', 'Enter a valid email address.');
    valid = false;
  } else {
    showSuccess('email', 'email-error');
  }

  if (!password) {
    showError('password', 'password-error', 'Password is required.');
    valid = false;
  } else if (password.length < 6) {
    showError('password', 'password-error', 'Password must be at least 6 characters.');
    valid = false;
  } else {
    showSuccess('password', 'password-error');
  }

  if (!confirm) {
    showError('confirm-password', 'confirm-error', 'Please confirm your password.');
    valid = false;
  } else if (confirm !== password) {
    showError('confirm-password', 'confirm-error', 'Passwords do not match.');
    valid = false;
  } else {
    showSuccess('confirm-password', 'confirm-error');
  }

  return valid;
}

// Validate contact form — returns true if valid
function validateContactForm() {
  let valid = true;
  const name = document.getElementById('name')?.value.trim();
  const email = document.getElementById('email')?.value.trim();
  const message = document.getElementById('message')?.value.trim();

  if (!name || name.length < 2) {
    showError('name', 'name-error', 'Please enter your full name (at least 2 characters).');
    valid = false;
  } else {
    showSuccess('name', 'name-error');
  }

  if (!email) {
    showError('email', 'email-error', 'Email is required.');
    valid = false;
  } else if (!isValidEmail(email)) {
    showError('email', 'email-error', 'Enter a valid email address.');
    valid = false;
  } else {
    showSuccess('email', 'email-error');
  }

  if (!message || message.length < 10) {
    showError('message', 'message-error', 'Message must be at least 10 characters.');
    valid = false;
  } else {
    showSuccess('message', 'message-error');
  }

  return valid;
}

// Real-time validation on blur
function attachRealTimeValidation() {
  const emailEl = document.getElementById('email');
  const passwordEl = document.getElementById('password');
  const usernameEl = document.getElementById('username');
  const confirmEl = document.getElementById('confirm-password');
  const nameEl = document.getElementById('name');
  const messageEl = document.getElementById('message');
  const identifierEl = document.getElementById('identifier');

  if (identifierEl) {
    identifierEl.addEventListener('blur', () => {
      const v = identifierEl.value.trim();
      if (!v) showError('identifier', 'identifier-error', 'Email or username is required.');
      else if (!isValidEmail(v) && !isValidUsername(v))
        showError('identifier', 'identifier-error', 'Enter a valid email or username.');
      else showSuccess('identifier', 'identifier-error');
    });
  }

  if (emailEl) {
    emailEl.addEventListener('blur', () => {
      const v = emailEl.value.trim();
      if (!v) showError('email', 'email-error', 'Email is required.');
      else if (!isValidEmail(v)) showError('email', 'email-error', 'Enter a valid email.');
      else showSuccess('email', 'email-error');
    });
  }
  if (passwordEl) {
    passwordEl.addEventListener('blur', () => {
      const v = passwordEl.value;
      if (!v) showError('password', 'password-error', 'Password is required.');
      else if (v.length < 6) showError('password', 'password-error', 'At least 6 characters required.');
      else showSuccess('password', 'password-error');
    });
  }
  if (usernameEl) {
    usernameEl.addEventListener('blur', () => {
      const v = usernameEl.value.trim();
      if (!v) showError('username', 'username-error', 'Username is required.');
      else if (!isValidUsername(v)) showError('username', 'username-error', '3–20 chars, letters/numbers/underscores only.');
      else showSuccess('username', 'username-error');
    });
  }
  if (confirmEl) {
    confirmEl.addEventListener('blur', () => {
      const pw = document.getElementById('password')?.value;
      const v = confirmEl.value;
      if (!v) showError('confirm-password', 'confirm-error', 'Please confirm your password.');
      else if (v !== pw) showError('confirm-password', 'confirm-error', 'Passwords do not match.');
      else showSuccess('confirm-password', 'confirm-error');
    });
  }
  if (nameEl) {
    nameEl.addEventListener('blur', () => {
      const v = nameEl.value.trim();
      if (!v || v.length < 2) showError('name', 'name-error', 'Please enter your full name.');
      else showSuccess('name', 'name-error');
    });
  }
  if (messageEl) {
    messageEl.addEventListener('blur', () => {
      const v = messageEl.value.trim();
      if (!v || v.length < 10) showError('message', 'message-error', 'Message must be at least 10 characters.');
      else showSuccess('message', 'message-error');
    });
  }
}

document.addEventListener('DOMContentLoaded', attachRealTimeValidation);
