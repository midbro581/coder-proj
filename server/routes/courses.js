const express = require('express');
const router = express.Router();
const db = require('../db');

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM courses ORDER BY id');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch courses.' });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM courses WHERE id = ?', [req.params.id]);
    if (rows.length === 0) return res.status(404).json({ error: 'Course not found.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch course.' });
  }
});

module.exports = router;
