const express = require('express');
const router = express.Router();
const db = require('../db');

// Get all comments
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM comments ORDER BY created_at DESC');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch comments.' });
  }
});

// Submit a comment
router.post('/', async (req, res) => {
  const { name, email, subject, message } = req.body;

  if (!name || !email || !message)
    return res.status(400).json({ error: 'Name, email, and message are required.' });

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email))
    return res.status(400).json({ error: 'Invalid email address.' });

  if (message.trim().length < 10)
    return res.status(400).json({ error: 'Message must be at least 10 characters.' });

  // Sanitize: strip HTML tags
  const sanitize = (str) => str ? str.replace(/<[^>]*>/g, '').trim() : '';

  try {
    await db.execute(
      'INSERT INTO comments (name, email, subject, message) VALUES (?, ?, ?, ?)',
      [sanitize(name), sanitize(email), sanitize(subject), sanitize(message)]
    );
    res.status(201).json({ message: 'Thank you! Your feedback has been submitted.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to save comment.' });
  }
});

module.exports = router;
