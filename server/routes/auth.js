/*
 * CODER — routes/auth.js
 * Login and Register endpoints using bcryptjs + MySQL
 */

const express  = require('express');
const router   = express.Router();
const bcrypt   = require('bcryptjs');
const db       = require('../db');

// POST /api/auth/register
router.post('/register', async (req, res) => {
  const { username, email, password } = req.body;

  // Server-side validation
  if (!username || !email || !password)
    return res.status(400).json({ error: 'All fields are required.' });

  if (username.length > 50)
    return res.status(400).json({ error: 'Username must be 50 characters or fewer.' });
  if (email.length > 254)
    return res.status(400).json({ error: 'Email address is too long.' });
  if (password.length < 6)
    return res.status(400).json({ error: 'Password must be at least 6 characters.' });
  if (password.length > 128)
    return res.status(400).json({ error: 'Password must be 128 characters or fewer.' });

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email))
    return res.status(400).json({ error: 'Invalid email address.' });

  try {
    // Check if user already exists
    const [existing] = await db.execute(
      'SELECT id FROM users WHERE email = ? OR username = ?',
      [email, username]
    );
    if (existing.length > 0)
      return res.status(409).json({ error: 'Username or email already exists.' });

    // Hash the password before storing (bcryptjs)
    const hashed = await bcrypt.hash(password, 10);

    await db.execute(
      'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
      [username, email, hashed]
    );

    // Fetch the newly created user's id
    const [newUser] = await db.execute('SELECT id FROM users WHERE email = ?', [email]);
    const newId = newUser.length > 0 ? newUser[0].id : null;
    res.status(201).json({ message: 'Account created successfully!', username, email, id: newId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error. Please try again.' });
  }
});

// POST /api/auth/login
// Accepts EITHER an email OR a username via the "identifier" field.
// Falls back to the old "email" field for backwards compatibility.
router.post('/login', async (req, res) => {
  const identifier = (req.body.identifier || req.body.email || '').trim();
  const { password } = req.body;

  if (!identifier || !password)
    return res.status(400).json({ error: 'Email/username and password are required.' });

  if (identifier.length > 254)
    return res.status(400).json({ error: 'Invalid email or username.' });

  try {
    // Look up by email OR username — a single query handles both cases
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ? OR username = ? LIMIT 1',
      [identifier, identifier]
    );

    if (rows.length === 0)
      return res.status(401).json({ error: 'Invalid email/username or password.' });

    const user = rows[0];

    // Compare entered password with stored hash
    const match = await bcrypt.compare(password, user.password);
    if (!match)
      return res.status(401).json({ error: 'Invalid email/username or password.' });

    res.json({ message: 'Login successful!', id: user.id, username: user.username, email: user.email, role: user.role });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error. Please try again.' });
  }
});

module.exports = router;
