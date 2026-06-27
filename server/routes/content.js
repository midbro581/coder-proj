var db = require('../db');

function getTeam(req, res) {
  db.query('SELECT * FROM team ORDER BY id', function(err, result) {
    if (err) {
      res.writeHead(500, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Failed to fetch team.' }));
    }
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(result));
  });
}

function getFounders(req, res) {
  db.query('SELECT * FROM founders ORDER BY id', function(err, result) {
    if (err) {
      res.writeHead(500, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Failed to fetch founders.' }));
    }
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(result));
  });
}

function getHistory(req, res) {
  db.query('SELECT * FROM company_history ORDER BY year_val', function(err, result) {
    if (err) {
      res.writeHead(500, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Failed to fetch history.' }));
    }
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(result));
  });
}

function getAwards(req, res) {
  db.query('SELECT * FROM awards ORDER BY year_val DESC', function(err, result) {
    if (err) {
      res.writeHead(500, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Failed to fetch awards.' }));
    }
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(result));
  });
}

function getTestimonials(req, res) {
  db.query('SELECT * FROM testimonials ORDER BY id', function(err, result) {
    if (err) {
      res.writeHead(500, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Failed to fetch testimonials.' }));
    }
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(result));
  });
}

module.exports = {
  getTeam: getTeam,
  getFounders: getFounders,
  getHistory: getHistory,
  getAwards: getAwards,
  getTestimonials: getTestimonials
};
