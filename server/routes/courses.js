var express = require('express');
var router = express.Router();
var db = require('../db');

// The code below gets all courses
router.get('/', function(req, res) {
  db.query("SELECT * FROM courses ORDER BY id", function(err, results) {
    if (err) {
      res.status(500).json({ error: "Failed to fetch courses." });
      return;
    }
    res.json(results);
  });
});

// The code below will get the course by ID
router.get('/:id', function(req, res) {
  db.query("SELECT * FROM courses WHERE id = ?", [req.params.id], function(err, results) {
    if (err) {
      res.status(500).json({ error: "Failed to fetch course." });
      return;
    }

    if (results.length === 0) {
      res.status(404).json({ error: "Course not found." });
      return;
    }

    res.json(results[0]);
  });
});

module.exports = router;
