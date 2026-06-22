/*
 * CODER — about.js (external JavaScript file)
 * Loads founders, history, and awards from the Node.js API (MySQL).
 * Also demonstrates XML + XSLT transformation using the browser's
 * built-in XSLTProcessor — no extra libraries needed.
 */

// ── Founders (from MySQL via API) ────────────────────────────
async function loadFounders() {
  const el = document.getElementById('founders-grid');
  if (!el) return;
  try {
    const founders = await apiFetch('/api/content/founders');
    el.innerHTML = founders.map(f => {
      // Build initials avatar from first two words of name
      const initials = f.name.split(' ').slice(0, 2).map(w => w[0]).join('');
      return `
        <div class="founder-card">
          <div class="founder-avatar">${initials}</div>
          <div class="founder-info">
            <h3>${escapeHtml(f.name)}</h3>
            <div class="founder-title">${escapeHtml(f.title)}</div>
            <p class="founder-bio">${escapeHtml(f.bio)}</p>
            <p style="margin-top:0.75rem; font-size:0.82rem; color:var(--text-muted);">
              Co-founded Coder in ${f.founded_year}
            </p>
          </div>
        </div>`;
    }).join('');
  } catch (err) {
    document.getElementById('founders-grid').innerHTML =
      '<p style="color:var(--red);">Could not load founders: ' + err.message + '</p>';
  }
}

// ── Company History Timeline (from MySQL via API) ─────────────
async function loadHistory() {
  const el = document.getElementById('history-timeline');
  if (!el) return;
  try {
    const history = await apiFetch('/api/content/history');
    el.innerHTML = history.map(h => `
      <div class="timeline-item">
        <div class="timeline-dot">${h.year_val}</div>
        <div class="timeline-content">
          <div class="timeline-year">${h.year_val}</div>
          <h4>${escapeHtml(h.milestone)}</h4>
          <p>${escapeHtml(h.description)}</p>
        </div>
      </div>`).join('');
  } catch (err) {
    el.innerHTML = '<p style="color:var(--red);">Could not load history.</p>';
  }
}

// ── Awards via XML + XSLT transformation ─────────────────────
// This demonstrates XML and XSLT — a required technology for this assignment.
// We fetch awards.xml and awards.xsl, then use the browser's XSLTProcessor
// to transform the XML into HTML and inject it into the page.
async function loadAwardsFromXML() {
  const el = document.getElementById('awards-xslt-output');
  if (!el) return;

  try {
    // Fetch both the XML data file and the XSL stylesheet in parallel
    const [xmlText, xslText] = await Promise.all([
      fetch('/data/awards.xml').then(r => r.text()),
      fetch('/data/awards.xsl').then(r => r.text())
    ]);

    // Parse both documents using DOMParser
    const parser     = new DOMParser();
    const xmlDoc     = parser.parseFromString(xmlText, 'application/xml');
    const xslDoc     = parser.parseFromString(xslText, 'application/xml');

    // Apply the XSLT transformation using the browser's built-in XSLTProcessor
    const processor  = new XSLTProcessor();
    processor.importStylesheet(xslDoc);
    const resultFrag = processor.transformToFragment(xmlDoc, document);

    // Inject the transformed HTML result into the page
    el.innerHTML = '';
    el.appendChild(resultFrag);

  } catch (err) {
    el.innerHTML = '<p style="color:var(--red);">Could not load awards via XML/XSLT: ' + err.message + '</p>';
  }
}

document.addEventListener('DOMContentLoaded', () => {
  loadFounders();
  loadHistory();
  loadAwardsFromXML();
});
