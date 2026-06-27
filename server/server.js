var http = require('http');
var mysql = require('mysql');
var fs = require('fs');
var path = require('path');

var con = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'coder_db'
});

con.connect(function(err) {
  if (err) {
    console.error("Could not connect to MySQL: " + err);
  } else {
    console.log("Connected to MySQL!");
  }
});

var server = http.createServer(function(req, res) {
  var url = req.url;
  var method = req.method;

  if (url === '/api/comments' && method === 'GET') {
    con.query('SELECT id, name, subject, message, created_at FROM comments ORDER BY created_at DESC', function(err, result) {
      if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({ error: 'Failed to fetch testimonials.' }));
        return;
      }
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end(JSON.stringify(result));
    });
  }
  else if (url === '/api/comments' && method === 'POST') {
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
        con.query('INSERT INTO comments (name, email, subject, message) VALUES (?, ?, ?, ?)', 
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
  else if (url === '/api/content/team' && method === 'GET') {
    con.query('SELECT * FROM team ORDER BY id', function(err, result) {
      if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Failed to fetch team.' }));
      }
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end(JSON.stringify(result));
    });
  }
  else if (url === '/api/content/founders' && method === 'GET') {
    con.query('SELECT * FROM founders ORDER BY id', function(err, result) {
      if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Failed to fetch founders.' }));
      }
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end(JSON.stringify(result));
    });
  }
  else if (url === '/api/content/history' && method === 'GET') {
    con.query('SELECT * FROM company_history ORDER BY year_val', function(err, result) {
      if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Failed to fetch history.' }));
      }
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end(JSON.stringify(result));
    });
  }
  else if (url === '/api/content/awards' && method === 'GET') {
    con.query('SELECT * FROM awards ORDER BY year_val DESC', function(err, result) {
      if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Failed to fetch awards.' }));
      }
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end(JSON.stringify(result));
    });
  }
  else if (url === '/api/content/testimonials' && method === 'GET') {
    con.query('SELECT * FROM testimonials ORDER BY id', function(err, result) {
      if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Failed to fetch testimonials.' }));
      }
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end(JSON.stringify(result));
    });
  }
  else if (url === '/api/courses' && method === 'GET') {
    con.query('SELECT * FROM courses ORDER BY id', function(err, result) {
      if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        return res.end(JSON.stringify({ error: 'Failed to fetch courses.' }));
      }
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end(JSON.stringify(result));
    });
  }
  else if (url.indexOf('/api/courses/') === 0 && method === 'GET') {
    var id = url.split('/')[3];
    con.query('SELECT * FROM courses WHERE id = ?', [id], function(err, result) {
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
  else {
    var filePath;
    var ext = path.extname(url);

    if (url === '/' || url === '/index') filePath = path.join(__dirname, '../public/index.html');
    else if (url === '/about') filePath = path.join(__dirname, '../public/about.html');
    else if (url === '/courses') filePath = path.join(__dirname, '../public/courses.html');
    else if (url === '/team') filePath = path.join(__dirname, '../public/team.html');
    else if (url === '/contact') filePath = path.join(__dirname, '../public/contact.html');
    else if (url === '/sitemap.xml') filePath = path.join(__dirname, '../public/sitemap.xml');
    else if (url.indexOf('/data/') === 0) filePath = path.join(__dirname, '..', url);
    else filePath = path.join(__dirname, '../public', url);

    fs.readFile(filePath, function(err, content) {
      if (err) {
        if (err.code === 'ENOENT') {
          fs.readFile(path.join(__dirname, '../public/404.html'), function(err404, content404) {
            res.writeHead(404, { 'Content-Type': 'text/html' });
            res.end(content404, 'utf-8');
          });
        } else {
          res.writeHead(500);
          res.end('Server Error: ' + err.code);
        }
      } else {
        var contentType = 'text/html';
        ext = path.extname(filePath);
        switch (ext) {
          case '.js': contentType = 'text/javascript'; break;
          case '.css': contentType = 'text/css'; break;
          case '.json': contentType = 'application/json'; break;
          case '.xml': contentType = 'application/xml'; break;
          case '.png': contentType = 'image/png'; break;
          case '.jpg': contentType = 'image/jpg'; break;
          case '.svg': contentType = 'image/svg+xml'; break;
        }
        res.writeHead(200, { 'Content-Type': contentType });
        res.end(content, 'utf-8');
      }
    });
  }
});

server.listen(8080, '0.0.0.0', function() {
  console.log('Coder Company Profile running at http://0.0.0.0:8080 (Accessible on network)');
});
