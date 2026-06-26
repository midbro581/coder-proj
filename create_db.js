var mysql = require('mysql');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  port: 3306,
  charset: "utf8mb4"
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
        level ENUM('Beginner','Intermediate','Advanced') DEFAULT 'Beginner',
        duration VARCHAR(50),
        lessons INT DEFAULT 0,
        icon VARCHAR(100),
        color VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `;
    con.query(courses, function(err) {
      if (err) throw err;
      console.log("Table 'courses' created!");
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
      console.log("Table 'team' created!");
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
      console.log("Table 'history' created!");
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
      console.log("Table 'comments' created!");
    });

    // Clear existing data to avoid duplicates when running multiple times
    con.query("TRUNCATE TABLE company_history");
    con.query("TRUNCATE TABLE team");
    con.query("TRUNCATE TABLE courses");
    con.query("TRUNCATE TABLE comments");

    //Data insertion into history table
    var historyData = [
      [2026, "Company Founded", "Started at UOWD by a team of Computer Science students."],
      [2026, "Platform Launch", "Successfully launched the Coder platform with 6 interactive courses."],
      [2026, "First 1,000 Users", "Reached 1,000 registered learners within the first month of launch."]
    ];
    con.query("INSERT INTO company_history (year_val, milestone, description) VALUES ?", [historyData],
      function(err) {
        if (err) throw err;
        console.log("Inserted data into 'history' table");
      }
    );

    //Data insertion into team table
    var teamData = [
      ["Midhlaj Abubacker", "Co-Founder / Lead Developer", "CS student at UOWD specializing in AI & Big Data. Built the full backend and database architecture for Coder.", "https://ui-avatars.com/api/?name=Midhlaj+Abubacker&background=6c63ff&color=fff&size=128", "#", "#"],
      ["Ahmed Almarouf", "Co-Founder / Frontend Engineer", "CS student at UOWD passionate about UI/UX design and interactive web experiences. Designed the Coder platform interface.", "https://ui-avatars.com/api/?name=Ahmed+Almarouf&background=a78bfa&color=fff&size=128", "#", "#"],
      ["Ted Lokolo", "Co-Founder / Curriculum Lead", "CS student at UOWD focused on education technology. Authored the structured lesson plans and course content for Coder.", "https://ui-avatars.com/api/?name=Ted+Lokolo&background=34d399&color=fff&size=128", "#", "#"]
    ];
    con.query("INSERT INTO team (name, role, bio, image, linkedin, github) VALUES ?", [teamData],
      function(err) {
        if (err) throw err;
        console.log("Inserted data into 'team' table");
      }
    );

    //Data insertion into courses table
    var coursesData = [
      ["Python Foundations", "Start from zero and build a solid foundation in Python. Variables, loops, functions, and real mini-projects.", "Python", "Beginner", "4 weeks", 12, "🐍", "#3776ab"],
      ["Advanced JavaScript", "Go beyond the basics. Closures, async/await, the event loop, and modern ES2025 patterns.", "JavaScript", "Advanced", "6 weeks", 18, "⚡", "#f7df1e"],
      ["Web Technology", "Master HTML5, CSS3, and how the web works under the hood. Build responsive, accessible websites from scratch.", "HTML/CSS", "Beginner", "3 weeks", 10, "🌐", "#e44d26"]
    ];
    con.query("INSERT INTO courses (title, description, language, level, duration, lessons, icon, color) VALUES ?", [coursesData],
      function(err) {
        if (err) throw err;
        console.log("Inserted data into 'courses' table");
      }
    );
    
    //Data insertion into comments table
    var commentsData = [
      ["Sarah J.", "Great Platform", "The interactive compiler completely changed how our corporate team learns Python.", "sarah.j@example.com"],
      ["Ahmed M.", "Highly Recommended", "The Web Technology course is incredibly well-structured. Best training provider in Dubai.", "ahmed.m@example.com"],
      ["Elena R.", "Fantastic Support", "Clean UI and the step-by-step methodology makes complex topics easy to grasp.", "elena.r@example.com"]
    ];
    con.query("INSERT INTO comments (name, subject, message, email) VALUES ?", [commentsData],
      function(err) {
        if (err) throw err;
        console.log("Inserted data into 'comments' table");
      }
    );

    // End the connection once all queries are complete
    con.end(function(err) {
      if (err) throw err;
      console.log("Data inserted and setup complete!");
    });
  });
});
