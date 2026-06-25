/*
The functions below are callbacks 
*/

var AVATAR_COLORS = ['#00d4aa', '#7c3aed', '#58a6ff', '#e3b341', '#f85149', '#3fb950'];


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

/* the function below loads the team members */
function loadTeam() {
  var el = document.getElementById('team-grid');
  if (!el) return;

  apiGet('/api/content/team', function(err, team) {
    if (err) {
      el.innerHTML = '<p style="color:var(--text-muted); text-align:center;">Failed to load team members.</p>';
      return;
    }

    var html = "";

    for (var i = 0; i < team.length; i++) {
      var m = team[i];
      var initials = "";
      var parts = m.name.split(" ");

      for (var j = 0; j < parts.length && j < 2; j++) {
        initials += parts[j][0];
      }

      var color1 = AVATAR_COLORS[i % AVATAR_COLORS.length];
      var color2 = AVATAR_COLORS[(i + 2) % AVATAR_COLORS.length];

      html +=
        '<div class="team-card">' +
          '<div class="team-avatar" style="background: linear-gradient(135deg, ' + color1 + ', ' + color2 + ');">' +
            initials +
          '</div>' +
          '<h3>' + m.name + '</h3>' +
          '<div class="team-role">' + m.role + '</div>' +
          '<p class="team-bio">' + m.bio + '</p>' +
          '<div class="team-links">' +
            '<a href="' + (m.linkedin || '#') + '" title="LinkedIn" aria-label="LinkedIn"><i class="fab fa-linkedin"></i></a>' +
            '<a href="' + (m.github || '#') + '" title="GitHub" aria-label="GitHub"><i class="fab fa-github"></i></a>' +
          '</div>' +
        '</div>';
    }

    el.innerHTML = html;
  });
}

/*The function below loads the history table*/
function loadProgressTable() {
  var tbody = document.getElementById('progress-tbody');
  if (!tbody) return;

  apiGet('/api/content/history', function(err, history) {
    if (err) {
      tbody.innerHTML =
        '<tr><td colspan="3" style="padding:1rem; color:var(--text-muted);">Failed to load data.</td></tr>';
      return;
    }

    var html = "";

    for (var i = 0; i < history.length; i++) {
      var h = history[i];
      var bg = (i % 2 === 0) ? 'transparent' : 'rgba(255,255,255,0.02)';

      html +=
        '<tr style="border-bottom:1px solid var(--border); background:' + bg + ';">' +
          '<td style="padding:1rem; font-weight:700; color:var(--accent);">' + h.year_val + '</td>' +
          '<td style="padding:1rem; font-weight:600;">' + h.milestone + '</td>' +
          '<td style="padding:1rem; color:var(--text-secondary); font-size:0.9rem;">' + h.description + '</td>' +
        '</tr>';
    }

    tbody.innerHTML = html;
  });
}

document.addEventListener('DOMContentLoaded', function() {
  loadTeam();
  loadProgressTable();
});
