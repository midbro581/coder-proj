/*
 * CODER — server/routes/progress.js
 * API routes for user progress tracking
 *
 * POST /api/progress                   — mark a lesson complete
 * GET  /api/progress/:userId           — array of completed lesson_ids
 * GET  /api/progress/details/:userId   — completed lessons with title, course, xp
 */

const express = require('express');
const router  = express.Router();
const db      = require('../db');

// ── POST /api/progress ────────────────────────────────────────
// Body: { user_id, lesson_id }
// Inserts into user_progress if not already present (idempotent)
router.post('/', async (req, res) => {
  const { user_id, lesson_id } = req.body;
  if (!user_id || !lesson_id) {
    return res.status(400).json({ error: 'user_id and lesson_id are required.' });
  }
  // Reject non-numeric IDs to prevent injection or IDOR via crafted values
  if (!Number.isInteger(Number(user_id)) || !Number.isInteger(Number(lesson_id))) {
    return res.status(400).json({ error: 'Invalid IDs.' });
  }

  try {
    // INSERT IGNORE prevents duplicate key errors
    await db.execute(
      'INSERT IGNORE INTO user_progress (user_id, lesson_id) VALUES (?, ?)',
      [user_id, lesson_id]
    );
    res.json({ ok: true });
  } catch (err) {
    console.error('POST /api/progress error:', err);
    res.status(500).json({ error: 'Failed to save progress.' });
  }
});

// ── GET /api/progress/details/:userId ─────────────────────────
// Returns completed lessons with title, course title, language, xp_reward
// NOTE: must be registered BEFORE /api/progress/:userId so "details" isn't
//       treated as a userId. We handle this in server.js by mounting this
//       router at /api/progress and defining /details/:userId first.
router.get('/details/:userId', async (req, res) => {
  try {
    const [rows] = await db.execute(
      `SELECT
         l.id,
         l.title,
         l.xp_reward,
         l.language,
         c.title AS course_title,
         up.completed_at
       FROM user_progress up
       JOIN lessons l  ON l.id  = up.lesson_id
       JOIN courses c  ON c.id  = l.course_id
       WHERE up.user_id = ?
       ORDER BY up.completed_at DESC`,
      [req.params.userId]
    );
    res.json(rows);
  } catch (err) {
    console.error('GET /api/progress/details/:userId error:', err);
    res.status(500).json({ error: 'Failed to fetch progress details.' });
  }
});

// ── GET /api/progress/:userId ─────────────────────────────────
// Returns a plain array of completed lesson_ids: [1, 3, 5, ...]
router.get('/:userId', async (req, res) => {
  try {
    const [rows] = await db.execute(
      'SELECT lesson_id FROM user_progress WHERE user_id = ?',
      [req.params.userId]
    );
    res.json(rows.map(r => r.lesson_id));
  } catch (err) {
    console.error('GET /api/progress/:userId error:', err);
    res.status(500).json({ error: 'Failed to fetch progress.' });
  }
});

module.exports = router;
