function escapeHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function setLoading(id, msg) {
  var el = document.getElementById(id);
  if (el) {
    el.innerHTML =
      '<div class="loading-container"><div class="spinner"></div>' +
      (msg ? '<p style="color:var(--text-muted);margin-top:1rem;font-size:0.85rem;">' + msg + '</p>' : '') +
      '</div>';
  }
}

function setError(id, msg) {
  var el = document.getElementById(id);
  if (el) {
    el.innerHTML =
      '<p style="color:var(--text-muted);text-align:center;padding:2rem;">' +
      msg +
      '</p>';
  }
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

function loadCompanyHistory() {
  var container = document.getElementById('history-timeline');
  if (!container) return;

  setLoading('history-timeline');

  apiGet('/api/content/history', function(err, history) {
    if (err || !history || !history.length) {
      setError('history-timeline', 'No history records found.');
      return;
    }

    var html = '';
    for (var i = 0; i < history.length; i++) {
      var item = history[i];
      var last = (i === history.length - 1);

      html +=
        '<div class="timeline-item" style="' +
        'display:grid; grid-template-columns:80px 1fr; gap:1.5rem; padding:1.5rem 0;' +
        'border-bottom:1px solid var(--border); align-items:start;' +
        (last ? 'border-bottom:none;' : '') +
        '">' +

        '<div style="text-align:center; padding:0.6rem 0.5rem;' +
        'background:linear-gradient(135deg, var(--accent,#6c63ff), #a78bfa);' +
        'border-radius:10px; font-weight:800; font-size:0.95rem; color:#fff;' +
        'letter-spacing:0.5px; line-height:1.3;">' +
        escapeHtml(String(item.year_val)) +
        '</div>' +

        '<div>' +
        '<h4 style="font-size:1rem; font-weight:700; color:var(--text); margin:0 0 0.4rem;">' +
        escapeHtml(item.milestone) +
        '</h4>' +
        '<p style="color:var(--text-sub); font-size:0.875rem; line-height:1.7; margin:0;">' +
        escapeHtml(item.description) +
        '</p>' +
        '</div>' +

        '</div>';
    }

    container.innerHTML = html;
  });
}

function loadAwards() {
  var container = document.getElementById('awards-xslt-output');
  if (!container) return;

  setLoading('awards-xslt-output');

  if (typeof XSLTProcessor === 'undefined') {
    setError('awards-xslt-output', 'XSLTProcessor not supported in this browser.');
    return;
  }

  // this loads the xsl
  apiGet('/data/awards.xml', function(err1, xmlText) {
    if (err1 || !xmlText) {
      setError('awards-xslt-output', 'Failed to load awards.xml');
      return;
    }

    // this loads teh xsl file
    apiGet('/data/awards.xsl', function(err2, xslText) {
      if (err2 || !xslText) {
        setError('awards-xslt-output', 'Failed to load awards.xsl');
        return;
      }

      var parser = new DOMParser();
      var xmlDoc = parser.parseFromString(xmlText, 'application/xml');
      var xslDoc = parser.parseFromString(xslText, 'application/xml');

      var xmlErr = xmlDoc.querySelector('parsererror');
      var xslErr = xslDoc.querySelector('parsererror');

      if (xmlErr) {
        setError('awards-xslt-output', 'awards.xml is malformed.');
        return;
      }
      if (xslErr) {
        setError('awards-xslt-output', 'awards.xsl is malformed.');
        return;
      }

      var processor = new XSLTProcessor();
      processor.importStylesheet(xslDoc);

      var result = processor.transformToFragment(xmlDoc, document);

      container.innerHTML = '';
      container.appendChild(result);
    });
  });
}

function loadFounders() {
  var container = document.getElementById('founders-grid');
  if (!container) return;

  setLoading('founders-grid');

  apiGet('/api/content/founders', function(err, founders) {
    if (err || !founders || !founders.length) {
      setError('founders-grid', 'No founder records found.');
      return;
    }

    var html = '';
    for (var i = 0; i < founders.length; i++) {
      var f = founders[i];

      html +=
        '<div class="card" style="text-align:center; padding:2rem 1.5rem;">' +
          '<div style="width:80px; height:80px; border-radius:50%;' +
          'background:linear-gradient(135deg, var(--accent,#6c63ff), #a78bfa);' +
          'display:flex; align-items:center; justify-content:center;' +
          'font-size:2rem; font-weight:800; color:#fff; margin:0 auto 1rem;">' +
            escapeHtml(f.name[0]) +
          '</div>' +

          '<h4 style="font-size:1rem; font-weight:700; margin:0 0 0.25rem;">' +
            escapeHtml(f.name) +
          '</h4>' +

          '<p style="color:var(--accent,#6c63ff); font-size:0.82rem; font-weight:600; margin:0 0 0.75rem;">' +
            escapeHtml(f.title) +
          '</p>' +

          '<p style="color:var(--text-sub); font-size:0.85rem; line-height:1.7; margin:0;">' +
            escapeHtml(f.bio) +
          '</p>' +

          (f.linkedin && f.linkedin !== '#'
            ? '<a href="' + escapeHtml(f.linkedin) + '" style="display:inline-block;margin-top:1rem;color:var(--accent);font-size:0.82rem;" target="_blank" rel="noopener">' +
                '<i class="fab fa-linkedin"></i> LinkedIn' +
              '</a>'
            : '') +

        '</div>';
    }

    container.innerHTML = html;
  });
}

document.addEventListener('DOMContentLoaded', function() {
  loadFounders();
  loadCompanyHistory();
  loadAwards();
});
