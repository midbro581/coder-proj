/**/
function escapeHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

/* This function maps a color based on the level of the course */
var LEVEL_COLORS = {
  'Beginner':     { bg: 'rgba(16,185,129,0.15)', text: '#10b981' },
  'Intermediate': { bg: 'rgba(234,179,8,0.15)',  text: '#eab308' },
  'Advanced':     { bg: 'rgba(239,68,68,0.15)',  text: '#ef4444' }
};

function levelBadge(level) {
  var c = LEVEL_COLORS[level] || { bg: 'rgba(108,99,255,0.15)', text: '#6c63ff' };
  return '<span style="background:' + c.bg + '; color:' + c.text +
    '; padding:0.25rem 0.7rem; border-radius:20px; font-size:0.72rem; font-weight:700; letter-spacing:0.5px; text-transform:uppercase;">' +
    escapeHtml(level) + '</span>';
}

/* The function below builds a card for a course*/
function buildCard(course) {
  var color = course.color || '#6c63ff';
  var icon  = course.icon  || 'fas fa-code';

  return '' +
    '<div class="card course-card" data-level="' + escapeHtml(course.level) + '"' +
         ' style="padding:1.75rem; display:flex; flex-direction:column; gap:1rem; transition:transform 0.2s;">' +

      '<div style="width:52px; height:52px; border-radius:12px; background:' + color + '22;' +
      ' display:flex; align-items:center; justify-content:center; font-size:1.5rem; color:' + color + '; flex-shrink:0;">' +
        '<i class="' + escapeHtml(icon) + '"></i>' +
      '</div>' +

      '<div style="display:flex; align-items:center; gap:0.6rem; flex-wrap:wrap;">' +
        '<h3 style="font-size:1.05rem; font-weight:700; margin:0;">' + escapeHtml(course.title) + '</h3>' +
        levelBadge(course.level) +
      '</div>' +

      '<p style="color:var(--text-sub); font-size:0.875rem; line-height:1.7; margin:0; flex:1;">' +
        escapeHtml(course.description) +
      '</p>' +

      '<div style="display:flex; gap:1.25rem; flex-wrap:wrap; padding-top:0.75rem; border-top:1px solid var(--border); font-size:0.8rem; color:var(--text-muted);">' +
        '<span><i class="fas fa-clock" style="color:' + color + '; margin-right:0.3rem;"></i>' + escapeHtml(course.duration) + '</span>' +
        '<span><i class="fas fa-book-open" style="color:' + color + '; margin-right:0.3rem;"></i>' + course.lessons + ' lessons</span>' +
        '<span><i class="fas fa-code" style="color:' + color + '; margin-right:0.3rem;"></i>' + escapeHtml(course.language) + '</span>' +
      '</div>' +

    '</div>';
}

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


var allCourses = []; // cache

function loadServices() {
  var container =
    document.getElementById('courses-grid') ||
    document.getElementById('services-container');

  if (!container) return;

  container.innerHTML =
    '<div class="loading-container"><div class="spinner"></div></div>';

  apiGet('/data/courses.json', function(err, data) {
    if (err || !data || !data.courses || !data.courses.length) {
      container.innerHTML =
        '<p style="color:var(--text-muted);text-align:center;padding:2rem;">Could not load services.</p>';
      return;
    }

    allCourses = data.courses;
    renderCards(allCourses, container);
    initFilters(container);
  });
}

/* This renders the cards on the website*/
function renderCards(courses, container) {
  if (!courses.length) {
    container.innerHTML =
      '<p style="color:var(--text-muted);text-align:center;padding:2rem;grid-column:1/-1;">No courses match this filter.</p>';
    return;
  }

  var html = '';
  for (var i = 0; i < courses.length; i++) {
    html += buildCard(courses[i]);
  }

  container.innerHTML = html;
}

/* This function helps filter the courses based on their level*/
function initFilters(container) {
  var buttons = document.querySelectorAll('.filter-btn');
  if (!buttons.length) return;

  for (var i = 0; i < buttons.length; i++) {
    (function(btn) {
      btn.addEventListener('click', function() {

        for (var j = 0; j < buttons.length; j++) {
          buttons[j].classList.remove('active');
        }
        btn.classList.add('active');

        var filter = btn.getAttribute('data-filter');
        var filtered =
          filter === 'all'
            ? allCourses
            : allCourses.filter(function(c) {
                return c.level === filter;
              });

        renderCards(filtered, container);
      });
    })(buttons[i]);
  }
}

document.addEventListener('DOMContentLoaded', function() {
  loadServices();
});
