var db = require('../db');

function getComments(req, res) {
  db.query('SELECT id, name, subject, message, created_at FROM comments ORDER BY created_at DESC', function(err, result) {
    if (err) {
      res.writeHead(500, {'Content-Type': 'application/json'});
      return res.end(JSON.stringify({ error: 'Failed to fetch testimonials.' }));
    }
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(result));
  });
}

function postComment(req, res) {
  var body = '';
  req.on('data', function(chunk){ body += chunk; });
  req.on('end', function(){ 
    try {
      var data = JSON.parse(body);
      if (!data.name || !data.email || !data.message) {
        res.writeHead(400, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Name, email, and message are required.' }));
      }
      var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(data.email)) {
        res.writeHead(400, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Invalid email address.' }));
      }
      if (data.message.trim().length < 10) {
        res.writeHead(400, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Message must be at least 10 characters.' }));
      }
      var sanitize = function(str) { return str ? str.replace(/<[^>]*>/g, '').trim() : ''; };
      db.query('INSERT INTO comments (name, email, subject, message) VALUES (?, ?, ?, ?)', 
        [sanitize(data.name), sanitize(data.email), sanitize(data.subject), sanitize(data.message)], 
        function(err, result) {
          if (err) {
            res.writeHead(500, {'Content-Type': 'application/json'});
            return res.end(JSON.stringify({ error: 'Failed to save your message. Please try again.' }));
          }
          res.writeHead(201, {'Content-Type': 'application/json'});
          res.end(JSON.stringify({ message: 'Thank you! Your message has been received.' }));
      });
    } catch (e) {
      res.writeHead(400, {'Content-Type': 'application/json'});
      res.end(JSON.stringify({ error: 'Invalid JSON body.' }));
    }
  });
}

module.exports = {
  getComments: getComments,
  postComment: postComment
};
