/*
 * CODER — server/routes/leaderboard.js
 * GET /api/leaderboard — top 20 users ranked by total XP
 */

const express = require('express');
const router  = express.Router();
const db      = require('../db');

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT
        u.id,
        u.username,
        COALESCE(SUM(l.xp_reward), 0)  AS total_xp,
        COUNT(up.lesson_id)             AS lessons_done
      FROM users u
      LEFT JOIN user_progress up ON up.user_id  = u.id
      LEFT JOIN lessons l        ON l.id         = up.lesson_id
      GROUP BY u.id, u.username
      ORDER BY total_xp DESC, lessons_done DESC
      LIMIT 20
    `);
    res.json(rows);
  } catch (err) {
    console.error('GET /api/leaderboard error:', err);
    res.status(500).json({ error: 'Failed to fetch leaderboard.' });
  }
});

module.exports = router;
