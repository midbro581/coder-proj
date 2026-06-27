var http = require('http');
var fs = require('fs');
var path = require('path');
var urlModule = require('url');

var server = http.createServer(function(req, res) {
  var parsedUrl = urlModule.parse(req.url);
  var sanitizePath = path.normalize(parsedUrl.pathname).replace(/^(\.\.[\/\\])+/, '');
  var pathname = path.join(__dirname, '../public', sanitizePath);

  fs.exists(pathname, function(exist) {
    if(!exist) {
      res.statusCode = 404;
      res.end('File not found!');
      return;
    }

    if (fs.statSync(pathname).isDirectory()) {
      pathname += '/index.html';
    }

    fs.readFile(pathname, function(err, data){
      if(err){
        res.statusCode = 500;
        res.end('Error getting the file.');
      } else {
        var ext = path.parse(pathname).ext;
        var map = {
          '.ico': 'image/x-icon',
          '.html': 'text/html',
          '.js': 'text/javascript',
          '.json': 'application/json',
          '.css': 'text/css',
          '.png': 'image/png',
          '.jpg': 'image/jpeg',
          '.wav': 'audio/wav',
          '.mp3': 'audio/mpeg',
          '.svg': 'image/svg+xml',
          '.pdf': 'application/pdf',
          '.doc': 'application/msword'
        };
        res.setHeader('Content-type', map[ext] || 'text/plain' );
        res.end(data);
      }
    });
  });
});

server.listen(3333, function() {
  console.log('Static files server running at http://localhost:3333');
});
