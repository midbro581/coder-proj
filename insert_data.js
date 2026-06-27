var mysql = require('mysql2');

var con = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'coder_db'
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected to MySQL for insertion!");

  // Clear existing data to avoid duplicates
  var truncateQueries = [
    "TRUNCATE TABLE company_history",
    "TRUNCATE TABLE team",
    "TRUNCATE TABLE founders",
    "TRUNCATE TABLE courses",
    "TRUNCATE TABLE comments",
    "TRUNCATE TABLE awards",
    "TRUNCATE TABLE testimonials"
  ];

  var truncateCompleted = 0;
  for (var i = 0; i < truncateQueries.length; i++) {
    con.query(truncateQueries[i], function(err) {
      if (err) throw err;
      truncateCompleted++;
      if (truncateCompleted === truncateQueries.length) {
        insertData();
      }
    });
  }

  function insertData() {
    var historyData = [
      [2026, "Company Founded", "Started at UOWD by a team of Computer Science students."],
      [2026, "Platform Launch", "Successfully launched the Coder platform with 6 interactive courses."],
      [2026, "First 1,000 Users", "Reached 1,000 registered learners within the first month of launch."]
    ];

    var teamData = [
      ["Midhlaj Abubacker", "Co-Founder / Lead Developer", "CS student at UOWD specializing in AI & Big Data. Built the full backend and database architecture for Coder.", "https://ui-avatars.com/api/?name=Midhlaj+Abubacker&background=6c63ff&color=fff&size=128", "#", "#"],
      ["Ahmed Almarouf", "Co-Founder / Frontend Engineer", "CS student at UOWD passionate about UI/UX design and interactive web experiences. Designed the Coder platform interface.", "https://ui-avatars.com/api/?name=Ahmed+Almarouf&background=a78bfa&color=fff&size=128", "#", "#"],
      ["Ted Lokolo", "Co-Founder / Curriculum Lead", "CS student at UOWD focused on education technology. Authored the structured lesson plans and course content for Coder.", "https://ui-avatars.com/api/?name=Ted+Lokolo&background=34d399&color=fff&size=128", "#", "#"]
    ];

    var foundersData = [
      ["Ahmed Almarouf", "CEO"],
      ["Midhlaj Abubacker", "Co-Founder"],
      ["Ted Lokolo", "Co-Founder"]
    ];

    var coursesData = [
      ["Python Foundations", "Start from zero and build a solid foundation in Python. Variables, loops, functions, and real mini-projects.", "Python", "Beginner", "4 weeks", 12, "🐍", "#3776ab"],
      ["Advanced JavaScript", "Go beyond the basics. Closures, async/await, the event loop, and modern ES2025 patterns.", "JavaScript", "Advanced", "6 weeks", 18, "⚡", "#f7df1e"],
      ["Web Technology", "Master HTML5, CSS3, and how the web works under the hood. Build responsive, accessible websites from scratch.", "HTML/CSS", "Beginner", "3 weeks", 10, "🌐", "#e44d26"]
    ];
    
    var commentsData = [
      ["Sarah J.", "Great Platform", "The interactive compiler completely changed how our corporate team learns Python.", "sarah.j@example.com"],
      ["Ahmed M.", "Highly Recommended", "The Web Technology course is incredibly well-structured. Best training provider in Dubai.", "ahmed.m@example.com"],
      ["Elena R.", "Fantastic Support", "Clean UI and the step-by-step methodology makes complex topics easy to grasp.", "elena.r@example.com"]
    ];

    var awardsData = [
      [2026, "Best Startup UOWD"]
    ];

    var testimonialsData = [
      ["Student A", "Great platform!"]
    ];

    var queries = [
      { q: "INSERT INTO company_history (year_val, milestone, description) VALUES ?", v: [historyData] },
      { q: "INSERT INTO team (name, role, bio, image, linkedin, github) VALUES ?", v: [teamData] },
      { q: "INSERT INTO founders (name, role) VALUES ?", v: [foundersData] },
      { q: "INSERT INTO courses (title, description, language, level, duration, lessons, icon, color) VALUES ?", v: [coursesData] },
      { q: "INSERT INTO comments (name, subject, message, email) VALUES ?", v: [commentsData] },
      { q: "INSERT INTO awards (year_val, title) VALUES ?", v: [awardsData] },
      { q: "INSERT INTO testimonials (name, text) VALUES ?", v: [testimonialsData] }
    ];

    var completed = 0;
    for (var i = 0; i < queries.length; i++) {
      con.query(queries[i].q, queries[i].v, function(err) {
        if (err) throw err;
        completed++;
        if (completed === queries.length) {
          console.log("All seed data inserted successfully.");
          con.end();
        }
      });
    }
  }
});
