var express = require('express');
var router = express.Router();
var db = require('../db');

// retrieves team
router.get('/team', function(req, res) {
  db.query("SELECT * FROM team ORDER BY id", function(err, results) {
    if (err) {
      res.status(500).json({ error: "Failed to fetch team." });
      return;
    }
    res.json(results);
  });
});

// retrieves founders
router.get('/founders', function(req, res) {
  db.query("SELECT * FROM founders ORDER BY id", function(err, results) {
    if (err) {
      res.status(500).json({ error: "Failed to fetch founders." });
      return;
    }
    res.json(results);
  });
});

// retrieves history
router.get('/history', function(req, res) {
  db.query("SELECT * FROM company_history ORDER BY year_val", function(err, results) {
    if (err) {
      res.status(500).json({ error: "Failed to fetch history." });
      return;
    }
    res.json(results);
  });
});

// retrieves awards
router.get('/awards', function(req, res) {
  db.query("SELECT * FROM awards ORDER BY year_val DESC", function(err, results) {
    if (err) {
      res.status(500).json({ error: "Failed to fetch awards." });
      return;
    }
    res.json(results);
  });
});

// retrieves testimonials
router.get('/testimonials', function(req, res) {
  db.query("SELECT * FROM testimonials ORDER BY id", function(err, results) {
    if (err) {
      res.status(500).json({ error: "Failed to fetch testimonials." });
      return;
    }
    res.json(results);
  });
});

module.exports = router;
