-- =============================================================
-- CODER - Learn Programming Online
-- Database Schema + Seed Data
-- =============================================================

CREATE DATABASE IF NOT EXISTS coder_db;
USE coder_db;

-- Users (login/register)
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('student','admin') DEFAULT 'student',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses / Learning Paths
CREATE TABLE IF NOT EXISTS courses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  language VARCHAR(50),
  level ENUM('Beginner','Intermediate','Advanced') DEFAULT 'Beginner',
  duration VARCHAR(50),
  lessons INT DEFAULT 0,
  icon VARCHAR(100),
  color VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Staff / Team
CREATE TABLE IF NOT EXISTS team (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  role VARCHAR(100),
  bio TEXT,
  image VARCHAR(255),
  linkedin VARCHAR(255),
  github VARCHAR(255)
);

-- Founders
CREATE TABLE IF NOT EXISTS founders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  title VARCHAR(100),
  bio TEXT,
  image VARCHAR(255),
  linkedin VARCHAR(255),
  founded_year INT
);

-- Company History / Timeline
CREATE TABLE IF NOT EXISTS company_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  year_val INT NOT NULL,
  milestone VARCHAR(200) NOT NULL,
  description TEXT
);

-- Awards
CREATE TABLE IF NOT EXISTS awards (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(200),
  organization VARCHAR(200),
  year_val INT,
  description TEXT
);

-- Testimonials
CREATE TABLE IF NOT EXISTS testimonials (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_name VARCHAR(100),
  content TEXT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  course_completed VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Contact / Feedback
CREATE TABLE IF NOT EXISTS comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  subject VARCHAR(200),
  message TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- LESSONS TABLE
-- Stores individual lesson content for each course
-- =============================================================
CREATE TABLE IF NOT EXISTS lessons (
  id           INT PRIMARY KEY AUTO_INCREMENT,
  course_id    INT NOT NULL,
  title        VARCHAR(200) NOT NULL,
  content      TEXT NOT NULL,
  code_example TEXT NOT NULL,
  language     VARCHAR(50) NOT NULL,
  order_num    INT NOT NULL DEFAULT 1,
  xp_reward    INT NOT NULL DEFAULT 10,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_lesson_order (course_id, order_num)
);

-- =============================================================
-- USER PROGRESS TABLE
-- Tracks which lessons each user has completed
-- =============================================================
CREATE TABLE IF NOT EXISTS user_progress (
  id           INT PRIMARY KEY AUTO_INCREMENT,
  user_id      INT NOT NULL,
  lesson_id    INT NOT NULL,
  completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_lesson (user_id, lesson_id)
);

-- =============================================================
-- SEED DATA — Original tables
-- =============================================================

INSERT INTO courses (title, description, language, level, duration, lessons, icon, color) VALUES
('Python',      'Master Python from scratch — variables, OOP, data science basics, and real projects.',           'python',     'Beginner',     '8 weeks',  42, 'fab fa-python',   '#3776AB'),
('Java',        'Build robust apps with Java — OOP, data structures, collections, and APIs.',                     'java',        'Intermediate', '10 weeks', 56, 'fab fa-java',     '#ED8B00'),
('JavaScript',  'From DOM manipulation to async/await. Become a full-stack JS developer.',                        'javascript',  'Beginner',     '12 weeks', 68, 'fab fa-js-square','#F7DF1E'),
('C++',         'Systems programming, pointers, memory management, and competitive coding.',                       'cpp',         'Advanced',     '14 weeks', 72, 'fas fa-code',     '#00599C'),
('HTML & CSS',  'Build beautiful responsive websites from scratch using modern HTML5 and CSS3.',                   'html',        'Beginner',     '6 weeks',  35, 'fab fa-html5',    '#E44D26'),
('SQL',         'Design databases, write complex queries, and master relational data modelling.',                  'sql',         'Intermediate', '7 weeks',  38, 'fas fa-database', '#336791');

INSERT INTO team (name, role, bio, image, linkedin, github) VALUES
('Ahmed Al-Rashid', 'Lead Instructor — Python & AI',    'PhD in Computer Science with 8 years teaching Python and machine learning at top universities.', 'images/team1.png','#','#'),
('Sara Mohammed',   'Senior Developer & JS Instructor', 'Full-stack engineer with 6 years in industry. Expert in React, Node.js and modern JS.',           'images/team2.png','#','#'),
('Omar Khalid',     'Database Architect & SQL Instructor','10+ years designing enterprise databases. Simplifies SQL so anyone can master it.',             'images/team3.png','#','#'),
('Fatima Hassan',   'UI/UX Designer & HTML/CSS Instructor','Award-winning designer who makes the web beautiful and accessible for everyone.',              'images/team4.png','#','#'),
('Raj Patel',       'Java & C++ Instructor',            'Former Google engineer turned educator. Makes algorithms fun and approachable.',                   'images/team5.png','#','#');

INSERT INTO founders (name, title, bio, image, linkedin, founded_year) VALUES
('Dr. Khalid Al-Mansoori','CEO & Co-Founder',
 'Former professor with 15 years in software engineering education. PhD from MIT. Passionate about democratising coding in the Middle East. Founded Coder to make world-class programming education accessible to everyone.',
 'images/founder1.png','#',2019),
('Ms. Nour Al-Zahra','CTO & Co-Founder',
 'Serial entrepreneur and software architect. Built 3 successful EdTech startups before Coder. Graduated with honours from Imperial College London. Believes the next generation of builders will come from the Arab world.',
 'images/founder2.png','#',2019);

INSERT INTO company_history (year_val, milestone, description) VALUES
(2019,'Coder Founded',          'Launched in a small Dubai office with 2 founders, 3 courses, and 50 students.'),
(2020,'Reached 5,000 Students', 'Expanded to 6 programming languages and launched our mobile-friendly platform.'),
(2021,'UAE EdTech Award Winner','Won Best E-Learning Platform at the UAE National Technology Awards.'),
(2022,'Live Compiler Launched', 'Introduced in-browser compiler supporting Python, Java, JavaScript, C++, and more.'),
(2023,'UOWD Partnership',       'Officially partnered with University of Wollongong Dubai for student certification.'),
(2024,'50,000 Students Milestone','Crossed 50,000 enrolled students across 45 countries worldwide.'),
(2025,'AI Learning Paths',      'Launched personalised AI-driven curriculum adapting to each student\'s learning pace.'),
(2026,'Regional Expansion',     'Opened physical learning hubs in Dubai, Abu Dhabi, and Riyadh.');

INSERT INTO awards (title, organization, year_val, description) VALUES
('Best EdTech Platform — UAE',     'UAE National Technology Awards',   2021,'Recognised for excellence in digital education and innovative teaching methods.'),
('Top 10 EdTech Startups MENA',    'Forbes Middle East',               2022,'Featured as one of the most impactful education technology companies in the region.'),
('Gold Award — E-Learning Excellence','Gulf Education Technology Forum',2023,'Awarded for outstanding contribution to online STEM education across the GCC.'),
('Best Coding Platform 2024',      'Arab Tech Summit',                  2024,'Voted best coding education platform by over 10,000 developers and students.');

INSERT INTO testimonials (student_name, content, rating, course_completed) VALUES
('Ali Hassan',    'Coder completely changed my career. I went from zero coding knowledge to landing a software engineering job in 8 months!', 5, 'Python'),
('Maria Santos',  'The JavaScript course is incredible. The built-in compiler lets me practice right in the browser — no setup needed!',      5, 'JavaScript'),
('James Okonkwo', 'Best investment I ever made. The Java course is thorough, the instructors are always available, and I got certified in 10 weeks.', 5, 'Java'),
('Priya Sharma',  'The SQL course finally made databases click for me after years of confusion. Omar is an amazing teacher.',                  4, 'SQL'),
('Khalid Ibrahim','The live compiler is a game-changer. Just open the browser and start coding immediately. Love Coder!',                     5, 'C++');

-- =============================================================
-- SEED DATA — Lessons
-- Real lesson content for Python (course_id=1),
-- Java (course_id=2), JavaScript (course_id=3)
-- =============================================================

-- ── Python Lessons (course_id = 1) ────────────────────────────

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES
(1,
 'Introduction to Python',
 'Python is a high-level, interpreted programming language known for its clean and readable syntax. Unlike compiled languages, Python executes code line by line, making it easy to test and debug. It is widely used in web development, data science, artificial intelligence, and automation.',
 '# This is a comment — Python ignores it when running
# Print a message to the screen
print("Hello, World!")

# Python is case-sensitive
name = "Coder"
print("Welcome to", name)

# You can do maths directly
print(2 + 3)     # 5
print(10 / 3)    # 3.333...',
 'python', 1, 10),

(1,
 'Variables & Data Types',
 'A variable is a named container that stores a value. Python has four primary data types: int (whole numbers), float (decimal numbers), str (text), and bool (True or False). You do not need to declare the type — Python figures it out automatically.',
 '# Integer
age = 20
print(age)          # 20

# Float (decimal)
price = 9.99
print(price)        # 9.99

# String (text)
language = "Python"
print(language)     # Python

# Boolean
is_fun = True
print(is_fun)       # True

# Check the type of a variable
print(type(age))    # <class "int">
print(type(price))  # <class "float">',
 'python', 2, 10),

(1,
 'String Operations',
 'Strings are sequences of characters enclosed in quotes. Python provides many built-in methods to work with strings: you can find their length, convert case, combine them (concatenation), and format them with f-strings. F-strings (formatted string literals) are the modern way to embed variables inside a string.',
 '# Concatenation — joining strings with +
first = "Hello"
second = "World"
message = first + " " + second
print(message)           # Hello World

# String length
print(len(message))      # 11

# Upper and lower case
print(message.upper())   # HELLO WORLD
print(message.lower())   # hello world

# F-string — embed variables directly
name = "Ahmed"
score = 95
print(f"Student: {name}, Score: {score}%")
# Output: Student: Ahmed, Score: 95%',
 'python', 3, 10),

(1,
 'Lists',
 'A list is an ordered, mutable collection that can hold items of any type. You access items by their index (starting at 0). Lists are one of the most frequently used data structures in Python — use them whenever you need to store a sequence of items and change them later.',
 '# Create a list
shopping = ["milk", "eggs", "bread", "butter"]

# Access items by index (starts at 0)
print(shopping[0])       # milk
print(shopping[2])       # bread

# Add an item to the end
shopping.append("coffee")
print(shopping)

# Remove an item
shopping.remove("eggs")
print(shopping)

# Length of the list
print(len(shopping))     # 4

# Loop through the list
for item in shopping:
    print("-", item)',
 'python', 4, 15),

(1,
 'If Statements & Conditions',
 'Conditional statements let your program make decisions. The if statement checks a condition; if it is True the block runs. You can chain alternatives with elif (else-if) and provide a fallback with else. Python uses indentation (spaces) — not braces — to define code blocks.',
 '# Simple grade checker
score = 78

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print("Your grade:", grade)   # Your grade: C

# Comparison operators
print(5 > 3)    # True
print(5 == 5)   # True
print(5 != 4)   # True

# Logical operators
age = 20
has_id = True
if age >= 18 and has_id:
    print("Access granted!")
else:
    print("Access denied.")',
 'python', 5, 15);


-- ── Java Lessons (course_id = 2) ──────────────────────────────

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES
(2,
 'Introduction to Java',
 'Java is a compiled, object-oriented language that runs on the Java Virtual Machine (JVM). This means Java code is written once and can run on any operating system that has the JVM installed. Every Java program must have at least one class containing a main method — this is where execution begins.',
 '// Every Java program starts with a class
public class Main {

    // The main method is the entry point
    public static void main(String[] args) {

        // Print a line to the console
        System.out.println("Hello, World!");

        // Print without a newline
        System.out.print("Hello ");
        System.out.println("Java!");

        // Arithmetic
        int result = 10 + 5;
        System.out.println("10 + 5 = " + result);
    }
}',
 'java', 1, 10),

(2,
 'Variables & Data Types',
 'Java is a statically typed language, which means you must declare the data type of every variable before using it. The most common primitive types are int, double, boolean, and char. Strings are not primitives — they are objects of the String class. Java also provides wrapper classes like Integer and Double for when you need objects.',
 'public class Main {
    public static void main(String[] args) {

        // Integer (whole number)
        int age = 22;
        System.out.println("Age: " + age);

        // Double (decimal number)
        double price = 19.99;
        System.out.println("Price: " + price);

        // String (text — note capital S)
        String name = "Coder";
        System.out.println("Name: " + name);

        // Boolean
        boolean isActive = true;
        System.out.println("Active: " + isActive);

        // Constants (use final)
        final double PI = 3.14159;
        System.out.println("PI = " + PI);
    }
}',
 'java', 2, 10),

(2,
 'Control Flow',
 'Control flow statements determine the order in which statements execute. Java supports the same if/else and elif (written as else if) patterns as other languages. For loops are ideal when you know the number of iterations; while loops run as long as a condition is true. Java uses curly braces to define blocks.',
 'public class Main {
    public static void main(String[] args) {

        // if / else if / else
        int score = 85;
        if (score >= 90) {
            System.out.println("Grade: A");
        } else if (score >= 80) {
            System.out.println("Grade: B");
        } else {
            System.out.println("Grade: C or below");
        }

        // for loop — prints 1 to 5
        for (int i = 1; i <= 5; i++) {
            System.out.println("Count: " + i);
        }

        // while loop
        int n = 1;
        while (n <= 3) {
            System.out.println("n = " + n);
            n++;
        }
    }
}',
 'java', 3, 10),

(2,
 'Methods',
 'A method is a named block of code that performs a specific task. Defining methods keeps your code organised, readable, and reusable. Every method has a return type (or void if it returns nothing), a name, and optional parameters. You call a method by its name followed by parentheses.',
 'public class Main {

    // A method that adds two numbers and returns the result
    static int add(int a, int b) {
        return a + b;
    }

    // A method with no return value (void)
    static void greet(String name) {
        System.out.println("Hello, " + name + "!");
    }

    // A method that checks if a number is even
    static boolean isEven(int n) {
        return n % 2 == 0;
    }

    public static void main(String[] args) {
        int sum = add(10, 25);
        System.out.println("Sum: " + sum);      // Sum: 35

        greet("Ahmed");                          // Hello, Ahmed!

        System.out.println(isEven(4));           // true
        System.out.println(isEven(7));           // false
    }
}',
 'java', 4, 15),

(2,
 'Object-Oriented Programming',
 'Object-Oriented Programming (OOP) is the core paradigm of Java. A class is a blueprint that defines the properties (fields) and behaviours (methods) of objects. You create an object by instantiating a class using the new keyword. A constructor is a special method that runs when an object is created to set its initial state.',
 'public class Main {

    // Define a class called Student
    static class Student {
        // Fields (properties)
        String name;
        int age;
        double gpa;

        // Constructor — called when object is created
        Student(String name, int age, double gpa) {
            this.name = name;
            this.age  = age;
            this.gpa  = gpa;
        }

        // Method
        void introduce() {
            System.out.println("Hi, I am " + name +
                ", age " + age +
                ", GPA: " + gpa);
        }
    }

    public static void main(String[] args) {
        // Create two Student objects
        Student s1 = new Student("Ahmed", 20, 3.8);
        Student s2 = new Student("Sara",  22, 3.5);

        s1.introduce();
        s2.introduce();
    }
}',
 'java', 5, 20);


-- ── JavaScript Lessons (course_id = 3) ────────────────────────

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES
(3,
 'Introduction to JavaScript',
 'JavaScript is the programming language of the web. It runs directly in the browser without any installation, enabling interactive web pages. Today, JavaScript also runs on servers via Node.js. It is a dynamically typed language — you do not need to specify types — and supports multiple programming styles including functional and object-oriented.',
 '// Print to the browser console (open DevTools → Console)
console.log("Hello, World!");

// You can do arithmetic
console.log(10 + 5);     // 15
console.log(10 * 3);     // 30
console.log(10 / 4);     // 2.5
console.log(10 % 3);     // 1 (remainder)

// Strings work too
console.log("Hello" + " " + "Coder");

// Template literals (backtick strings)
const name = "JavaScript";
console.log(`Welcome to ${name}!`);',
 'javascript', 1, 10),

(3,
 'Variables: let, const, var',
 'JavaScript has three ways to declare variables. var is the old way — it is function-scoped and can cause bugs due to hoisting, so avoid it in modern code. let declares a block-scoped variable whose value can change. const declares a block-scoped variable that cannot be reassigned — use it by default, and only switch to let when you need to reassign.',
 '// const — cannot be reassigned
const PI = 3.14159;
console.log(PI);          // 3.14159
// PI = 3;               // Error! Cannot reassign a const

// let — can be reassigned
let score = 0;
score = score + 10;
console.log(score);       // 10
score += 5;
console.log(score);       // 15

// var — old style, avoid in modern code
var oldStyle = "avoid me";
console.log(oldStyle);

// Block scope demonstration
if (true) {
    let blockScoped = "I only exist inside this block";
    console.log(blockScoped);  // works
}
// console.log(blockScoped); // Error! Not accessible here',
 'javascript', 2, 10),

(3,
 'Functions',
 'Functions are reusable blocks of code. JavaScript has two main syntaxes: traditional function declarations (hoisted — you can call them before they appear in the code) and arrow functions (a concise modern syntax). Arrow functions are especially popular in callbacks and modern code. Both can accept parameters and return values.',
 '// Traditional function declaration
function greet(name) {
    return "Hello, " + name + "!";
}
console.log(greet("Ahmed"));   // Hello, Ahmed!

// Arrow function — concise syntax
const square = (n) => n * n;
console.log(square(5));        // 25

// Arrow function with block body
const add = (a, b) => {
    const result = a + b;
    return result;
};
console.log(add(10, 20));     // 30

// Default parameters
const power = (base, exp = 2) => base ** exp;
console.log(power(3));         // 9 (3 squared)
console.log(power(2, 10));     // 1024',
 'javascript', 3, 10),

(3,
 'Arrays & Methods',
 'An array is an ordered list of values. JavaScript arrays are dynamic — they grow and shrink automatically. Modern JavaScript provides powerful array methods: push/pop to add/remove from the end, forEach to loop, map to transform each element into a new array, and filter to keep only elements that pass a test.',
 '// Create an array
const fruits = ["apple", "banana", "cherry", "date"];
console.log(fruits[0]);         // apple
console.log(fruits.length);     // 4

// Add and remove
fruits.push("elderberry");      // add to end
console.log(fruits);

fruits.pop();                   // remove last
console.log(fruits);

// forEach — loop over each element
fruits.forEach(fruit => {
    console.log("Fruit:", fruit);
});

// map — transform each element
const upper = fruits.map(f => f.toUpperCase());
console.log(upper);

// filter — keep only matching elements
const longNames = fruits.filter(f => f.length > 5);
console.log(longNames);         // ["banana", "cherry"]',
 'javascript', 4, 15),

(3,
 'DOM Manipulation',
 'The Document Object Model (DOM) is a programming interface that represents an HTML page as a tree of objects. JavaScript can read and modify this tree to make web pages interactive. querySelector selects an element using CSS syntax, innerHTML sets its HTML content, and addEventListener attaches event handlers so you can respond to clicks, key presses, and more.',
 '// Select an element by its CSS selector
// const heading = document.querySelector("h1");
// heading.innerHTML = "New Heading";

// Select by id
// const btn = document.getElementById("myButton");

// Change text content (safer than innerHTML for plain text)
// heading.textContent = "Hello from JavaScript!";

// Add a CSS class
// heading.classList.add("highlight");

// addEventListener — run code when user clicks
// btn.addEventListener("click", () => {
//     alert("Button clicked!");
//     btn.textContent = "Clicked!";
// });

// Create a new element and add it to the page
const para = document.createElement("p");
para.textContent = "This paragraph was created by JavaScript.";
// document.body.appendChild(para);

// This code example is meant to run in a browser with an HTML file.
// In Node.js / the compiler, document is not available.
console.log("DOM manipulation runs in the browser!");
console.log("Open this in an HTML file to see it in action.");',
 'javascript', 5, 20);
