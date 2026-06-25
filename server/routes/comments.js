var express = require('express');
var router = express.Router();
var db = require('../db');

// retrieve all testimonials / comments
router.get('/', function(req, res) {
  db.query(
    "SELECT id, name, subject, message, created_at FROM comments ORDER BY created_at DESC",
    function(err, results) {
      if (err) {
        res.status(500).json({ error: "Failed to fetch testimonials." });
        return;
      }
      res.json(results);
    }
  );
});

// feedback / contact message
router.post('/', function(req, res) {
  var name = req.body.name;
  var email = req.body.email;
  var subject = req.body.subject;
  var message = req.body.message;

  //fields needed
  if (!name || !email || !message) {
    res.status(400).json({ error: "Name, email, and message are required." });
    return;
  }

  // Email validation
  var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    res.status(400).json({ error: "Invalid email address." });
    return;
  }

  // Message lenght requirement
  if (message.trim().length < 10) {
    res.status(400).json({ error: "Message must be at least 10 characters." });
    return;
  }

  // sanitization
  function sanitize(str) {
    return str ? str.replace(/<[^>]*>/g, "").trim() : "";
  }

  var cleanName = sanitize(name);
  var cleanEmail = sanitize(email);
  var cleanSubject = sanitize(subject);
  var cleanMessage = sanitize(message);

  db.query(
    "INSERT INTO comments (name, email, subject, message) VALUES (?, ?, ?, ?)",
    [cleanName, cleanEmail, cleanSubject, cleanMessage],
    function(err) {
      if (err) {
        res.status(500).json({ error: "Failed to save your message. Please try again." });
        return;
      }

      res.status(201).json({ message: "Thank you! Your message has been received." });
    }
  );
});

module.exports = router;
