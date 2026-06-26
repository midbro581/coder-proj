/*
 * CODER — routes/comments.js
 * GET  /api/comments  → fetch all testimonials ordered by newest first
 * POST /api/comments  → submit a new contact/feedback message
 */

const express = require('express');
const router  = express.Router();
const db      = require('../db');

// -- GET all testimonials --------------------------------------
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.execute(
      'SELECT id, name, subject, message, created_at FROM comments ORDER BY created_at DESC'
    );
    res.json(rows);
  } catch (err) {
    console.error('GET /api/comments error:', err);
    res.status(500).json({ error: 'Failed to fetch testimonials.' });
  }
});

// -- POST new feedback / contact message -----------------------
router.post('/', async (req, res) => {
  const { name, email, subject, message } = req.body;

  // Required field validation
  if (!name || !email || !message) {
    return res.status(400).json({ error: 'Name, email, and message are required.' });
  }

  // Email format validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ error: 'Invalid email address.' });
  }

  // Message length validation
  if (message.trim().length < 10) {
    return res.status(400).json({ error: 'Message must be at least 10 characters.' });
  }

  // Strip HTML tags to prevent XSS
  const sanitize = (str) => str ? str.replace(/<[^>]*>/g, '').trim() : '';

  try {
    await db.execute(
      'INSERT INTO comments (name, email, subject, message) VALUES (?, ?, ?, ?)',
      [sanitize(name), sanitize(email), sanitize(subject), sanitize(message)]
    );
    res.status(201).json({ message: 'Thank you! Your message has been received.' });
  } catch (err) {
    console.error('POST /api/comments error:', err);
    res.status(500).json({ error: 'Failed to save your message. Please try again.' });
  }
});

module.exports = router;
