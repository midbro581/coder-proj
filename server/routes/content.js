const express = require('express');
const router = express.Router();
const db = require('../db');

router.get('/team', async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM team ORDER BY id');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch team.' });
  }
});

router.get('/founders', async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM founders ORDER BY id');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch founders.' });
  }
});

router.get('/history', async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM company_history ORDER BY year_val');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch history.' });
  }
});

router.get('/awards', async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM awards ORDER BY year_val DESC');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch awards.' });
  }
});

router.get('/testimonials', async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM testimonials ORDER BY id');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch testimonials.' });
  }
});

module.exports = router;
