/* =============================================================
   CODER — public/js/about.js
   Data sources:
     1. MySQL via Node.js API  → /api/content/history  → #history-timeline
     2. XML + XSLT transform   → /data/awards.xml + awards.xsl → #awards-xslt-output
     3. MySQL via Node.js API  → /api/content/founders → #founders-grid
   ============================================================= */

// -- Utility ---------------------------------------------------

function escapeHtml(str) {
  return String(str || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function setLoading(id, msg) {
  const el = document.getElementById(id);
  if (el) el.innerHTML = `<div class="loading-container"><div class="spinner"></div>${msg ? `<p style="color:var(--text-muted);margin-top:1rem;font-size:0.85rem;">${msg}</p>` : ''}</div>`;
}

function setError(id, msg) {
  const el = document.getElementById(id);
  if (el) el.innerHTML = `<p style="color:var(--text-muted);text-align:center;padding:2rem;">${msg}</p>`;
}

// ===============================================================
// STEP 1 — MySQL: Company History Timeline
// Endpoint: GET /api/content/history
// Container: id="history-timeline"
// ===============================================================

async function loadCompanyHistory() {
  const container = document.getElementById('history-timeline');
  if (!container) return;

  setLoading('history-timeline');

  try {
    const res = await fetch('/api/content/history');
    if (!res.ok) throw new Error(`Server error ${res.status}`);
    const history = await res.json();

    if (!history.length) {
      setError('history-timeline', 'No history records found.');
      return;
    }

    container.innerHTML = history.map((item, i) => `
      <div class="timeline-item" style="
        display:grid;
        grid-template-columns:80px 1fr;
        gap:1.5rem;
        padding:1.5rem 0;
        border-bottom:1px solid var(--border);
        align-items:start;
        ${i === history.length - 1 ? 'border-bottom:none;' : ''}
      ">
        <div style="
          text-align:center;
          padding:0.6rem 0.5rem;
          background:linear-gradient(135deg, var(--accent, #6c63ff), #a78bfa);
          border-radius:10px;
          font-weight:800;
          font-size:0.95rem;
          color:#fff;
          letter-spacing:0.5px;
          line-height:1.3;
        ">${escapeHtml(String(item.year_val))}</div>
        <div>
          <h4 style="
            font-size:1rem;
            font-weight:700;
            color:var(--text);
            margin:0 0 0.4rem;
          ">${escapeHtml(item.milestone)}</h4>
          <p style="
            color:var(--text-sub);
            font-size:0.875rem;
            line-height:1.7;
            margin:0;
          ">${escapeHtml(item.description)}</p>
        </div>
      </div>`).join('');

  } catch (err) {
    console.error('loadCompanyHistory error:', err);
    setError('history-timeline', 'Could not load company history. Is the server running?');
  }
}

// ===============================================================
// STEP 2 — XML + XSLT: Awards & Honours
// Sources: /data/awards.xml  +  /data/awards.xsl
// Container: id="awards-xslt-output"
// ===============================================================

async function loadAwards() {
  const container = document.getElementById('awards-xslt-output');
  if (!container) return;

  setLoading('awards-xslt-output');

  // Guard: XSLTProcessor is only available in real browsers, not all environments
  if (typeof XSLTProcessor === 'undefined') {
    setError('awards-xslt-output', 'XSLTProcessor not supported in this browser.');
    return;
  }

  try {
    // Fetch both files in parallel
    const [xmlRes, xslRes] = await Promise.all([
      fetch('/data/awards.xml'),
      fetch('/data/awards.xsl')
    ]);

    if (!xmlRes.ok) throw new Error(`Failed to fetch awards.xml (${xmlRes.status})`);
    if (!xslRes.ok) throw new Error(`Failed to fetch awards.xsl (${xslRes.status})`);

    const [xmlText, xslText] = await Promise.all([
      xmlRes.text(),
      xslRes.text()
    ]);

    // Parse both documents
    const parser     = new DOMParser();
    const xmlDoc     = parser.parseFromString(xmlText, 'application/xml');
    const xslDoc     = parser.parseFromString(xslText, 'application/xml');

    // Check for parse errors
    const xmlError = xmlDoc.querySelector('parsererror');
    const xslError = xslDoc.querySelector('parsererror');
    if (xmlError) throw new Error('awards.xml is malformed: ' + xmlError.textContent);
    if (xslError) throw new Error('awards.xsl is malformed: ' + xslError.textContent);

    // Apply XSLT transformation
    const processor = new XSLTProcessor();
    processor.importStylesheet(xslDoc);
    const resultFragment = processor.transformToFragment(xmlDoc, document);

    // Clear spinner and append the transformed HTML
    container.innerHTML = '';
    container.appendChild(resultFragment);

  } catch (err) {
    console.error('loadAwards (XSLT) error:', err);
    setError('awards-xslt-output', `XSLT transform failed: ${err.message}`);
  }
}

// ===============================================================
// BONUS — MySQL: Founders Grid
// Endpoint: GET /api/content/founders
// Container: id="founders-grid"
// ===============================================================

async function loadFounders() {
  const container = document.getElementById('founders-grid');
  if (!container) return;

  try {
    const res = await fetch('/api/content/founders');
    if (!res.ok) throw new Error(`Server error ${res.status}`);
    const founders = await res.json();

    if (!founders.length) {
      setError('founders-grid', 'No founder records found.');
      return;
    }

    container.innerHTML = founders.map(f => `
      <div class="card" style="text-align:center; padding:2rem 1.5rem;">
        <div style="
          width:80px; height:80px; border-radius:50%;
          background:linear-gradient(135deg, var(--accent,#6c63ff), #a78bfa);
          display:flex; align-items:center; justify-content:center;
          font-size:2rem; font-weight:800; color:#fff;
          margin:0 auto 1rem; flex-shrink:0;
        ">${escapeHtml(f.name[0])}</div>
        <h4 style="font-size:1rem; font-weight:700; margin:0 0 0.25rem;">${escapeHtml(f.name)}</h4>
        <p style="color:var(--accent,#6c63ff); font-size:0.82rem; font-weight:600; margin:0 0 0.75rem;">${escapeHtml(f.title)}</p>
        <p style="color:var(--text-sub); font-size:0.85rem; line-height:1.7; margin:0;">${escapeHtml(f.bio)}</p>
        ${f.linkedin && f.linkedin !== '#'
          ? `<a href="${escapeHtml(f.linkedin)}" style="display:inline-block;margin-top:1rem;color:var(--accent);font-size:0.82rem;" target="_blank" rel="noopener">
               <i class="fab fa-linkedin"></i> LinkedIn
             </a>`
          : ''}
      </div>`).join('');

  } catch (err) {
    console.error('loadFounders error:', err);
    setError('founders-grid', 'Could not load founder data.');
  }
}

// -- Init ------------------------------------------------------

document.addEventListener('DOMContentLoaded', () => {
  loadFounders();
  loadCompanyHistory();
  loadAwards();
});
