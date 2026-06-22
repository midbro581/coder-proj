/*
 * CODER — server/routes/lessons.js
 * API routes for lessons
 *
 * GET  /api/lessons/single/:id   — full single lesson (content, code, prev/next ids)
 * GET  /api/lessons/:courseId    — lightweight list for a course (no content/code)
 */

const express = require('express');
const router  = express.Router();
const db      = require('../db');

// ── GET /api/lessons/single/:id ───────────────────────────────
// MUST be registered first so Express does not treat "single" as a courseId.
// Returns full lesson with content, code_example, prev_id, next_id.
router.get('/single/:id', async (req, res) => {
  try {
    const [rows] = await db.execute(
      'SELECT * FROM lessons WHERE id = ?',
      [req.params.id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Lesson not found.' });
    }

    const lesson = rows[0];

    // Prev lesson — same course, highest order_num below current
    const [prevRows] = await db.execute(
      'SELECT id FROM lessons WHERE course_id = ? AND order_num < ? ORDER BY order_num DESC LIMIT 1',
      [lesson.course_id, lesson.order_num]
    );

    // Next lesson — same course, lowest order_num above current
    const [nextRows] = await db.execute(
      'SELECT id FROM lessons WHERE course_id = ? AND order_num > ? ORDER BY order_num ASC LIMIT 1',
      [lesson.course_id, lesson.order_num]
    );

    lesson.prev_id = prevRows.length > 0 ? prevRows[0].id : null;
    lesson.next_id = nextRows.length > 0 ? nextRows[0].id : null;

    res.json(lesson);
  } catch (err) {
    console.error('GET /api/lessons/single/:id error:', err);
    res.status(500).json({ error: 'Failed to fetch lesson.' });
  }
});

// ── GET /api/lessons/:courseId ────────────────────────────────
// Returns lightweight list (id, title, order_num, xp_reward — no content/code).
router.get('/:courseId', async (req, res) => {
  try {
    const [rows] = await db.execute(
      'SELECT id, course_id, title, order_num, xp_reward FROM lessons WHERE course_id = ? ORDER BY order_num',
      [req.params.courseId]
    );
    res.json(rows);
  } catch (err) {
    console.error('GET /api/lessons/:courseId error:', err);
    res.status(500).json({ error: 'Failed to fetch lessons.' });
  }
});

module.exports = router;
