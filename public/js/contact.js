
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
  var el = document.getElementById('alert-' + type);
  if (!el) return;
  el.textContent = message;
  el.classList.add('show');

  if (type === 'success') {
    setTimeout(function() {
      el.classList.remove('show');
    }, 6000);
  }
}

function hideAlerts() {
  var e1 = document.getElementById('alert-error');
  var e2 = document.getElementById('alert-success');
  if (e1) e1.classList.remove('show');
  if (e2) e2.classList.remove('show');
}


function apiGet(url, callback) {
  var req = new XMLHttpRequest();
  req.open('GET', url, true);

  req.onload = function() {
    if (req.status === 200) {
      callback(null, JSON.parse(req.responseText));
    } else {
      callback(true, null);
    }
  };

  req.onerror = function() {
    callback(true, null);
  };

  req.send();
}

function apiPost(url, data, callback) {
  var req = new XMLHttpRequest();
  req.open('POST', url, true);
  req.setRequestHeader('Content-Type', 'application/json');

  req.onload = function() {
    var json = {};
    try { json = JSON.parse(req.responseText); } catch(e) {}

    if (req.status >= 200 && req.status < 300) {
      callback(null, json);
    } else {
      callback(true, json);
    }
  };

  req.onerror = function() {
    callback(true, null);
  };

  req.send(JSON.stringify(data));
}

/*this loads testimonials*/
function loadTestimonials() {
  var container = document.getElementById('recent-comments');
  if (!container) return;

  apiGet('/api/comments', function(err, testimonials) {
    if (err || !testimonials || !testimonials.length) {
      container.innerHTML =
        '<p style="color:var(--text-muted); text-align:center; padding:2rem; grid-column:1/-1;">' +
        'No testimonials yet. Be the first to leave feedback!' +
        '</p>';
      return;
    }

    var html = '';
    var max = Math.min(6, testimonials.length);

    for (var i = 0; i < max; i++) {
      var t = testimonials[i];
      var initial = escapeHtml(t.name[0].toUpperCase());

      html +=
        '<div class="card" style="padding:1.5rem;">' +
          '<div style="display:flex; align-items:center; gap:0.75rem; margin-bottom:1rem;">' +
            '<div style="width:42px; height:42px; border-radius:50%;' +
            ' background:linear-gradient(135deg, var(--accent,#6c63ff), #a78bfa);' +
            ' display:flex; align-items:center; justify-content:center;' +
            ' font-weight:700; color:#fff; font-size:1rem; flex-shrink:0;">' +
              initial +
            '</div>' +
            '<div>' +
              '<div style="font-weight:600; font-size:0.95rem;">' + escapeHtml(t.name) + '</div>' +
              '<div style="color:var(--text-muted); font-size:0.75rem;">' + formatDate(t.created_at) + '</div>' +
            '</div>' +
          '</div>' +

          (t.subject
            ? '<div style="font-size:0.82rem; font-weight:600; color:var(--accent,#6c63ff); margin-bottom:0.5rem;">' +
                escapeHtml(t.subject) +
              '</div>'
            : '') +

          '<p style="color:var(--text-sub); font-size:0.875rem; line-height:1.7; margin:0;">"' +
            escapeHtml(t.message) +
          '"</p>' +
        '</div>';
    }

    container.innerHTML = html;
  });
}

/*This loads contact form */
function initContactForm() {
  var form = document.getElementById('contact-form');
  if (!form) return;

  form.addEventListener('submit', function(e) {
    e.preventDefault();
    hideAlerts();

    var name    = document.getElementById('name').value.trim();
    var email   = document.getElementById('email').value.trim();
    var subject = document.getElementById('subject').value.trim() || '';
    var message = document.getElementById('message').value.trim();

    if (!name || !email || !message) {
      showAlert('error', 'Name, email, and message are required.');
      return;
    }

    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      showAlert('error', 'Please enter a valid email address.');
      return;
    }

    if (message.length < 10) {
      showAlert('error', 'Message must be at least 10 characters.');
      return;
    }

    var btn = document.getElementById('submit-btn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';

    apiPost('/api/comments', { name: name, email: email, subject: subject, message: message }, function(err, data) {
      if (err) {
        showAlert('error', (data && data.error) || 'Failed to send. Please try again.');
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Message';
        return;
      }

      showAlert('success', 'Message sent successfully! We will get back to you shortly.');
      form.reset();

      var fields = form.querySelectorAll('.form-control');
      for (var i = 0; i < fields.length; i++) {
        fields[i].classList.remove('input-success', 'input-error');
      }

      btn.disabled = false;
      btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Message';
    });
  });
}

document.addEventListener('DOMContentLoaded', function() {
  initContactForm();
  loadTestimonials();
});
