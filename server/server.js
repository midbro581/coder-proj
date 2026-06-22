/*
 * CODER — server.js
 * Main Node.js + Express server
 * Technologies: Node.js, Express, MySQL
 */

const express    = require('express');
const path       = require('path');
const rateLimit  = require('express-rate-limit');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const app = express();

// Parse incoming JSON and form data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rate limiting — prevent brute-force and compiler abuse
app.use('/api/auth/login',    rateLimit({ windowMs: 15 * 60 * 1000, max: 20,  message: { error: 'Too many login attempts. Try again in 15 minutes.' } }));
app.use('/api/auth/register', rateLimit({ windowMs: 60 * 60 * 1000, max: 10,  message: { error: 'Too many registrations. Try again later.' } }));
app.use('/api/compiler/run',  rateLimit({ windowMs:       60 * 1000, max: 15,  message: { error: 'Too many code runs. Wait a moment and try again.' } }));

// Serve all files in /public as static assets (HTML, CSS, JS, images)
app.use(express.static(path.join(__dirname, '../public')));

// Serve /data folder so the browser can fetch XML and JSON files
app.use('/data', express.static(path.join(__dirname, '../data')));

// ── API Routes ───────────────────────────────────────────────
app.use('/api/auth',     require('./routes/auth'));
app.use('/api/courses',  require('./routes/courses'));
app.use('/api/content',  require('./routes/content'));
app.use('/api/comments', require('./routes/comments'));
app.use('/api/compiler', require('./routes/compiler'));

// Lessons: /single/:id must be registered before /:courseId
// so Express doesn't treat the string "single" as a courseId.
const lessonsRouter = require('./routes/lessons');
app.use('/api/lessons', lessonsRouter);

// Progress: /details/:userId registered before /:userId
app.use('/api/progress',    require('./routes/progress'));
app.use('/api/leaderboard', require('./routes/leaderboard'));

// ── Page Routes ──────────────────────────────────────────────
const pages = [
  'index', 'login', 'register', 'about', 'courses',
  'compiler', 'team', 'contact', '404',
  'course', 'lesson', 'profile',
  'pricing', 'sitemap', 'leaderboard',
  'roadmap', 'resources'
];

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

// 404 fallback
app.use((req, res) => {
  res.status(404).sendFile(path.join(__dirname, '../public/404.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log('\n  Coder is running at http://localhost:' + PORT + '\n');
});
