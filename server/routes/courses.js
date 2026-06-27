var db = require('../db');

function getCourses(req, res) {
  db.query('SELECT * FROM courses ORDER BY id', function(err, result) {
    if (err) {
      res.writeHead(500, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Failed to fetch courses.' }));
    }
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(result));
  });
}

function getCourseById(req, res, id) {
  db.query('SELECT * FROM courses WHERE id = ?', [id], function(err, result) {
    if (err) {
      res.writeHead(500, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Failed to fetch course.' }));
    }
    if (result.length === 0) {
      res.writeHead(404, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Course not found.' }));
    }
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(result[0]));
  });
}

module.exports = {
  getCourses: getCourses,
  getCourseById: getCourseById
};
