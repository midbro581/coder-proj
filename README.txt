═══════════════════════════════════════════════════════════════════════════
                              C O D E R
              Learn Programming from Scratch — Web Platform
═══════════════════════════════════════════════════════════════════════════

Built in 2026 by three Computer Science students at the
University of Wollongong in Dubai (UOWD):
    • Ahmed Almarouf    — Co-Founder & CEO
    • Ted Lokolo        — Co-Founder & CTO
    • Midhlaj Abubacker — Co-Founder & Head of Curriculum

Coder is our first company. The mission: help people truly UNDERSTAND
coding from scratch, not just memorise syntax. The platform pairs deep
foundations lessons (how the CPU runs code, memory, the call stack)
with 15 courses, 250+ lessons, and a real in-browser compiler that
runs Python, JavaScript, TypeScript, Java, C, and C++.

═══════════════════════════════════════════════════════════════════════════
QUICK START  (the 5-minute version)
═══════════════════════════════════════════════════════════════════════════

  1.  Read REQUIREMENTS.txt and install what you don't have.
  2.  In the Coder folder, open a Command Prompt and run:
          npm install
  3.  Start XAMPP and click "Start" on Apache + MySQL.
  4.  Go to http://localhost/phpmyadmin → import the SQL files
      (see "DATABASE SETUP" below for exact order).
  5.  Back in your terminal:
          npm start
  6.  Open http://localhost:3001 in your browser. Done.


═══════════════════════════════════════════════════════════════════════════
STEP-BY-STEP SETUP
═══════════════════════════════════════════════════════════════════════════

─── Step 1: Install everything in REQUIREMENTS.txt ────────────────────────

   At minimum you need Node.js and XAMPP. The other tools (Python,
   Java, MinGW) are only needed for the COMPILER feature.

─── Step 2: Install Node dependencies ─────────────────────────────────────

   Open Command Prompt or PowerShell.
   Navigate to this folder:

       cd "C:\Users\YourName\Desktop\Coder"

   Then run:

       npm install

   This downloads Express, mysql2, bcryptjs and the other libraries
   the server uses. Takes about 30 seconds. Creates a node_modules
   folder (which is why it is NOT included in the ZIP — too big).

─── Step 3: Start XAMPP ───────────────────────────────────────────────────

   Open the XAMPP Control Panel.
   Click "Start" next to:
       • Apache
       • MySQL

   Both should show green. If MySQL refuses to start, the port 3306
   is probably in use — close any other MySQL process and try again.

─── Step 4: Set up the database ───────────────────────────────────────────

   Open http://localhost/phpmyadmin in your browser.

   IMPORT THESE FILES IN THIS ORDER (one at a time):

     a) Create the database & seed data:
        - Click "New" in the left sidebar
        - Name it:  coder_db
        - Click "Create"
        - Click the coder_db database
        - Click the "Import" tab → choose file:
              database/schema.sql
        - Click "Go"

     b) Now click the "SQL" tab (with coder_db still selected) and
        paste each of these files one at a time, click Go after each:

          database/more_lessons_v2.sql
          database/more_lessons_v3.sql
          database/more_lessons_v4a.sql
          database/more_lessons_v4b.sql
          database/patch_react_lang.sql
          database/patch_company_v2.sql
          database/foundations_course.sql
          database/computational_thinking_course.sql
          database/reading_code_course.sql
          database/debugging_course.sql
          database/ai_foundations_course.sql
          database/ai_etiquette_course.sql

   To verify everything loaded, paste this into the SQL tab and Go:

       USE coder_db;
       SELECT c.id, c.title, COUNT(l.id) AS lesson_count
       FROM courses c LEFT JOIN lessons l ON l.course_id = c.id
       GROUP BY c.id, c.title ORDER BY c.id;

   You should see 15 courses with their lesson counts.

─── Step 5: Configure the .env file ───────────────────────────────────────

   In the Coder folder, create a NEW file called  .env  (note the dot).
   Paste this in (and edit DB_PASSWORD if your MySQL has a password):

       DB_HOST=localhost
       DB_USER=root
       DB_PASSWORD=
       DB_NAME=coder_db
       JWT_SECRET=change_me_to_a_long_random_string
       PORT=3001

   XAMPP's default MySQL root password is empty — so DB_PASSWORD= is
   correct out of the box. If you set a password during MySQL setup,
   put it here.

─── Step 6: Start the server ──────────────────────────────────────────────

   In the Coder folder, run:

       npm start

   You should see something like:

       Server running on http://localhost:3001
       Connected to MySQL database: coder_db

   If you get "ECONNREFUSED" — MySQL isn't running. Go back to XAMPP.
   If you get "Access denied" — your DB_PASSWORD in .env is wrong.

─── Step 7: Open Coder in your browser ────────────────────────────────────

   Visit:    http://localhost:3001

   That's it. You should see the homepage. Click around — every
   feature works on localhost, no internet needed (except font/icon
   CDNs, which are graceful if they fail).


═══════════════════════════════════════════════════════════════════════════
HOW TO USE CODER
═══════════════════════════════════════════════════════════════════════════

   • Sign up at /register (or log in at /login). You can log in
     using EITHER your email OR your username.

   • Browse courses at /courses — 15 of them, ranging from
     "Programming Foundations" (start here) to "AI Pair-Programming
     Etiquette" (the 2026 must-have).

   • Try the live compiler at /compiler — six languages, runs
     locally on your machine.

   • Open any lesson and click "Try in Compiler" to send the
     lesson code straight to the compiler with one click.


═══════════════════════════════════════════════════════════════════════════
THE 15 COURSES
═══════════════════════════════════════════════════════════════════════════

   LANGUAGE TRACKS
     1.  Python                        — 8 weeks, beginner
     2.  Java                          — 10 weeks, intermediate
     3.  JavaScript                    — 12 weeks, beginner
     4.  C++                           — 14 weeks, advanced
     5.  HTML & CSS                    — 6 weeks, beginner
     6.  SQL                           — 7 weeks, intermediate
     7.  TypeScript                    — 5 weeks, intermediate
     8.  React                         — 8 weeks, intermediate
     9.  Git & GitHub                  — 3 weeks, beginner

   FOUNDATIONS (built on CS-education research)
     10. Programming Foundations       — what code REALLY is
     11. Think Like a Coder            — decompose, pseudocode, brute force first
     12. Reading Code Like a Detective — the skill no one teaches
     13. Debugging Like a Pro          — bugs as the curriculum
     14. AI, ML & LLMs from Scratch    — build a perceptron yourself
     15. AI Pair-Programming Etiquette — 2026's most important skill


═══════════════════════════════════════════════════════════════════════════
PROJECT STRUCTURE
═══════════════════════════════════════════════════════════════════════════

   Coder/
   ├── REQUIREMENTS.txt       ← read this first
   ├── README.txt             ← you are here
   ├── .env                   ← you create this (see Step 5)
   ├── package.json           ← Node dependency list
   ├── public/                ← all the HTML/CSS/JS the browser sees
   │   ├── index.html
   │   ├── courses.html
   │   ├── lesson.html
   │   ├── compiler.html
   │   ├── login.html
   │   ├── register.html
   │   ├── about.html
   │   ├── team.html
   │   ├── css/style.css
   │   └── js/                ← validation, auth, compiler logic, etc.
   ├── server/                ← Node.js + Express backend
   │   ├── server.js          ← entry point
   │   ├── db.js              ← MySQL connection
   │   └── routes/            ← auth, courses, lessons, compiler, etc.
   ├── database/              ← all the SQL files you import in Step 4
   └── data/                  ← static JSON / XML / DTD reference files


═══════════════════════════════════════════════════════════════════════════
TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════════════

   Problem: "Cannot connect to MySQL"
   Fix:     Start MySQL in XAMPP Control Panel. Then restart the
            Node server (Ctrl+C in its window, then npm start again).

   Problem: Compiler says "'python' is not recognized" (or 'gcc', 'javac')
   Fix:     The tool is not installed OR not in PATH. See
            REQUIREMENTS.txt for install steps. After installing,
            restart the Node server.

   Problem: Lesson page shows "No lessons yet"
   Fix:     You missed an SQL import. Go back to Step 4 and import
            the missing files. The verify query at the end of Step 4
            will show 0 lessons for any course missing its content.

   Problem: Port 3001 is already in use
   Fix:     Another process owns it. Either close that process, or
            change PORT=3001 to PORT=3002 in your .env file.

   Problem: I forgot my password / want to reset users
   Fix:     In phpMyAdmin, click coder_db → users table → empty it.
            Register again from /register.


═══════════════════════════════════════════════════════════════════════════
CREDITS
═══════════════════════════════════════════════════════════════════════════

   Founded 2026 at the University of Wollongong in Dubai.
   Curriculum design grounded in CS-education research:
   Sorva 2013 (notional machine), Lister 2004 (read-before-write),
   Ericson 2022 (Parsons problems), Becker 2019 (error messages),
   Anthropic 2026 RCT (AI-pair-programming patterns).

   © 2026 Coder. Built in Dubai.

═══════════════════════════════════════════════════════════════════════════
