/*
 * CODER — Company Profile
 * server.js — Clean Express server (no auth, no compiler, no rate-limiting)
 * Pages: index, about, courses, team, contact
 */

var express = require('express');
var path    = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

var app = express();

// ── Body Parsing ─────────────────────────────────────────────
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ── Static Assets ─────────────────────────────────────────────
// Serve /public directory (CSS, JS, images)
app.use(express.static(path.join(__dirname, '../public')));

// Serve /data directory so the browser can fetch XML and JSON files
app.use('/data', express.static(path.join(__dirname, '../data')));

// ── API Routes ────────────────────────────────────────────────
app.use('/api/courses',  require('./routes/courses'));   // Products / Services
app.use('/api/content',  require('./routes/content'));   // Company history, founders, team, awards
app.use('/api/comments', require('./routes/comments'));  // Contact form / Testimonials

// ── Page Routes (5 pages only) ────────────────────────────────
var pages = ['index', 'about', 'courses', 'team', 'contact'];

pages.forEach(p => {
  app.get('/' + (p === 'index' ? '' : p), (req, res) => {
    res.sendFile(path.join(__dirname, '../public/' + p + '.html'));
  });
});

// Serve sitemap.xml with correct content-type
app.get('/sitemap.xml', (req, res) => {
  res.type('application/xml');
  res.sendFile(path.join(__dirname, '../public/sitemap.xml'));
});

// ── 404 Fallback ──────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).sendFile(path.join(__dirname, '../public/404.html'));
});

// ── Start Server ──────────────────────────────────────────────
var PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`\n  Coder Company Profile running at http://localhost:${PORT}\n`);
});
