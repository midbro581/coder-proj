//This connects the coder_db to the server
var mysql = require('mysql');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "coder_db"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});
