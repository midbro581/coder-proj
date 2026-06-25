var mysql = require('mysql');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: ""
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");

  // Create coder_db database if not exist
  con.query("CREATE DATABASE IF NOT EXISTS coder_db", function(err) {
    if (err) throw err;
    console.log("Database created or already exists.");

    con.query("USE coder_db");

    // Create courses table if not exist
    var courses = `
      CREATE TABLE IF NOT EXISTS courses (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(100) NOT NULL,
        description TEXT,
        language VARCHAR(50),
        level VARCHAR(50),
        duration VARCHAR(50),
        lessons INT DEFAULT 0,
        icon VARCHAR(100),
        color VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `;
    con.query(courses, function(err) {
      if (err) throw err;
      console.log("Table 'courses' created!")
    });

    // Create team table if not exist
    var team = `
      CREATE TABLE IF NOT EXISTS team (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        role VARCHAR(100),
        bio TEXT,
        image VARCHAR(255),
        linkedin VARCHAR(255),
        github VARCHAR(255)
      )
    `;
    con.query(team, function(err) {
      if (err) throw err;
      console.log("Table 'team' created")
    });

    // Create history table if not exist
    var history = `
      CREATE TABLE IF NOT EXISTS company_history (
        id INT AUTO_INCREMENT PRIMARY KEY,
        year_val INT NOT NULL,
        milestone VARCHAR(200) NOT NULL,
        description TEXT
      )
    `;
    con.query(history, function(err) {
      if (err) throw err;
      console.log("Table 'history' created")
    });

    // Create comments table if not exist
    var comments = `
      CREATE TABLE IF NOT EXISTS comments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        subject VARCHAR(200),
        message TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `;
    con.query(comments, function(err) {
      if (err) throw err;
      console.log("Table 'comments' created")
    });

    console.log("Tables created.");

    //Data insertion into history table
    var historyData = [
      [2026, "Company Founded", "Started at UOWD by a team of CS students."],
      [2026, "Platform Launch", "Launched the Coder platform with 6 courses."],
      [2026, "First 1,000 Users", "Reached 1,000 users in the first month."]
    ];
    con.query("INSERT INTO company_history (year_val, milestone, description) VALUES ?", [historyData],
      function(err) {
        if (err) throw err;
        console.log("Inserted data into 'history' table");
      }
    );

    //Data insertion into team table
    var teamData = [
      ["Midhlaj Abubacker", "Co-Founder / Lead Developer", "CS student specializing in AI & Big Data.", "img1.png", "#", "#"],
      ["Ahmed Almarouf", "Co-Founder / Frontend Engineer", "CS student passionate about UI/UX.", "img2.png", "#", "#"],
      ["Ted Lokolo", "Co-Founder / Curriculum Lead", "CS student focused on EdTech.", "img3.png", "#", "#"]
    ];
    con.query("INSERT INTO team (name, role, bio, image, linkedin, github) VALUES ?", [teamData],
      function(err) {
        if (err) throw err;
        console.log("Inserted data into 'team' table");
      }
    );

    //Data insertion into courses table
    var coursesData = [
      ["Python Foundations", "Learn Python from zero.", "Python", "Beginner", "4 weeks", 12, "🐍", "#3776ab"],
      ["Advanced JavaScript", "Closures, async, ES2025.", "JavaScript", "Advanced", "6 weeks", 18, "⚡", "#f7df1e"],
      ["Web Technology", "HTML5, CSS3, responsive design.", "HTML/CSS", "Beginner", "3 weeks", 10, "🌐", "#e44d26"]
    ];
    con.query("INSERT INTO courses (title, description, language, level, duration, lessons, icon, color) VALUES ?", [coursesData],
      function(err) {
        if (err) throw err;
        console.log("Inserted data into 'courses' table");
      }
    );

    console.log("Data inserted.");
  });
});
