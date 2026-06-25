 function apiGet(url, callback) {
  var request = new XMLHttpRequest();
  request.open('GET', url, true);

  request.onload = function() {
    if (request.status === 200) {
      callback(null, JSON.parse(request.responseText));
    } else {
      callback(true, null);
    }
  };

  request.onerror = function() {
    callback(true, null);
  };

  request.send();
}

/* The function below converts certain characters ton safe texts so no code can be executed*/
function escapeHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

/* The function below renders the star ratings */
function renderStars(rating) {
  var html = "";
  for (var i = 0; i < 5; i++) {
    html += '<i class="fas fa-star" style="color:' +
      (i < rating ? 'var(--yellow)' : 'var(--border)') +
      '"></i>';
  }
  return html;
}

/* The function below displays a hamburger menu */
function hamburger() {
  var btn   = document.getElementById('hamburger');
  var links = document.getElementById('navLinks');
  if (!btn || !links) return;

  btn.addEventListener('click', function() {
    links.classList.toggle('open');
  });

  var anchors = links.querySelectorAll('a');
  for (var i = 0; i < anchors.length; i++) {
    anchors[i].addEventListener('click', function() {
      links.classList.remove('open');
    });
  }
}

/* The function below previews the courses available on the homepage */
function loadHomeCourses() {
  var container = document.getElementById('home-courses');
  if (!container) return;

  apiGet('/data/courses.json', function(err, data) {
    if (err || !data || !data.courses) {
      container.innerHTML =
        '<p style="color:var(--text-sub);text-align:center;">Could not load courses.</p>';
      return;
    }

    var top3 = data.courses.slice(0, 3);
    var html = "";

    for (var i = 0; i < top3.length; i++) {
      var c = top3[i];
      html +=
        '<div class="card" style="display:flex;flex-direction:column;gap:1rem;">' +
          '<div style="font-size:2rem;"><i class="' + (c.icon || 'fas fa-code') + '"></i></div>' +
          '<h3 style="font-size:1.1rem;margin:0;">' + escapeHtml(c.title) + '</h3>' +
          '<p style="color:var(--text-sub);font-size:0.875rem;margin:0;flex:1;">' +
            escapeHtml(c.description || '') +
          '</p>' +
          '<span style="display:inline-block;background:rgba(108,99,255,.15);color:var(--accent);padding:.25rem .75rem;border-radius:999px;font-size:.78rem;font-weight:600;">' +
            escapeHtml(c.difficulty || c.level || '') +
          '</span>' +
        '</div>';
    }

    container.innerHTML = html;
  });
}

/* The function below previews the testimonials on the homepage*/
function loadHomeTestimonials() {
  var container = document.getElementById('home-testimonials');
  if (!container) return;

  apiGet('/api/comments', function(err, data) {
    if (err || !data) {
      container.innerHTML =
        '<p style="color:var(--text-sub);text-align:center;">No testimonials yet.</p>';
      return;
    }

    var items = Array.isArray(data) ? data : (data.comments || []);
    var top3 = items.slice(0, 3);

    if (top3.length === 0) {
      container.innerHTML =
        '<p style="color:var(--text-sub);text-align:center;">No testimonials yet.</p>';
      return;
    }

    var html = "";

    for (var i = 0; i < top3.length; i++) {
      var c = top3[i];
      var initial = escapeHtml((c.name || '?')[0].toUpperCase());

      html +=
        '<div class="card" style="display:flex;flex-direction:column;gap:.75rem;">' +
          '<div style="display:flex;align-items:center;gap:.75rem;">' +
            '<div style="width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,var(--accent),#a78bfa);display:flex;align-items:center;justify-content:center;font-weight:700;color:#fff;flex-shrink:0;">' +
              initial +
            '</div>' +
            '<div>' +
              '<div style="font-weight:600;font-size:.95rem;">' + escapeHtml(c.name || 'Anonymous') + '</div>' +
              '<div style="color:var(--text-muted);font-size:.78rem;">' + escapeHtml(c.email || '') + '</div>' +
            '</div>' +
          '</div>' +
          '<p style="color:var(--text-sub);font-size:.9rem;line-height:1.6;margin:0;">"' +
            escapeHtml(c.message || c.body || '') +
          '"</p>' +
        '</div>';
    }

    container.innerHTML = html;
  });
}

document.addEventListener('DOMContentLoaded', function() {
  initHamburger();
  loadHomeCourses();
  loadHomeTestimonials();
});
