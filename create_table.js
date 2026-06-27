var mysql = require('mysql2');

var con = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: ''
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected to MySQL for table creation!");
  
  con.query("CREATE DATABASE IF NOT EXISTS coder_db", function(err) {
    if (err) throw err;
    console.log("Database 'coder_db' checked/created.");
    
    con.query("USE coder_db", function(err) {
      if (err) throw err;
      
      var queries = [
        "CREATE TABLE IF NOT EXISTS courses (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(100) NOT NULL, description TEXT, language VARCHAR(50), level VARCHAR(50), duration VARCHAR(50), lessons INT DEFAULT 0, icon VARCHAR(100), color VARCHAR(20), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS team (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, role VARCHAR(100), bio TEXT, image VARCHAR(255), linkedin VARCHAR(255), github VARCHAR(255))",
        "CREATE TABLE IF NOT EXISTS founders (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), role VARCHAR(100))",
        "CREATE TABLE IF NOT EXISTS company_history (id INT AUTO_INCREMENT PRIMARY KEY, year_val INT NOT NULL, milestone VARCHAR(200) NOT NULL, description TEXT)",
        "CREATE TABLE IF NOT EXISTS awards (id INT AUTO_INCREMENT PRIMARY KEY, year_val INT, title VARCHAR(255))",
        "CREATE TABLE IF NOT EXISTS testimonials (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), text TEXT)",
        "CREATE TABLE IF NOT EXISTS comments (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL, subject VARCHAR(200), message TEXT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
      ];

      var completed = 0;
      for (var i = 0; i < queries.length; i++) {
        con.query(queries[i], function(err, result) {
          if (err) throw err;
          completed++;
          if (completed === queries.length) {
            console.log("All tables created successfully.");
            con.end();
          }
        });
      }
    });
  });
});
