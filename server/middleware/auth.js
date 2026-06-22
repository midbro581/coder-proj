/*
 * CODER — middleware/auth.js
 * Simple middleware to check if a username was provided in the request body.
 * Used as optional protection for admin-only routes.
 */

function requireLogin(req, res, next) {
  // For this student project, login state is managed client-side (localStorage).
  // Server-side protection checks that a username header is present.
  const username = req.headers['x-username'];
  if (!username) {
    return res.status(401).json({ error: 'You must be logged in.' });
  }
  req.username = username;
  next();
}

module.exports = { requireLogin };
