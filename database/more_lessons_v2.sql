-- ============================================================
-- CODER — more_lessons_v2.sql
-- Real lessons for C++, HTML & CSS, and SQL (5 each).
-- Import AFTER schema.sql in phpMyAdmin.
-- ============================================================

USE coder_db;

INSERT IGNORE INTO lessons
  (course_id, title, content, code_example, language, order_num, xp_reward)
VALUES

-- ═══════════════════════════════════════════════════
--  C++  (course_id = 4 , orders 1 – 5)
-- ═══════════════════════════════════════════════════

(4,
'Variables and Data Types',

'C++ is a strongly typed language, which means every variable must have a declared type. You are telling the computer exactly what kind of data to expect — an integer, a decimal number, a single character, or a piece of text. This makes C++ programs extremely fast because the computer knows precisely how much memory to reserve.

The most common types are: int for whole numbers, double for decimals, char for a single character, bool for true/false, and string for text (you need to include the string library for this one). You declare a variable by writing the type first, then the name, then the value.

Constants are variables that never change. Use the const keyword before the type to make a variable constant — the compiler will give you an error if you accidentally try to change it later. This is great for things like pi, tax rates, or maximum speeds.',

'// Variables and Data Types in C++
// ──────────────────────────────────
#include <iostream>   // for cout (printing)
#include <string>     // for string type
using namespace std;  // so we can write cout instead of std::cout

int main() {

    // Declaring and assigning variables
    int    age     = 20;          // whole number
    double price   = 9.99;        // decimal number
    char   grade   = ''A'';         // single character (use single quotes)
    bool   passing = true;        // true or false
    string name    = "Ahmed";     // text (use double quotes)

    // Printing variables
    cout << "Name:    " << name    << endl;   // endl = new line
    cout << "Age:     " << age     << endl;
    cout << "Price:   " << price   << endl;
    cout << "Grade:   " << grade   << endl;
    cout << "Passing: " << passing << endl;   // prints 1 (true) or 0 (false)


    // ─────────────────────────────────
    // Constants — values that never change
    const double PI      = 3.14159;
    const int    MAX_AGE = 120;

    // PI = 3.0;   // ERROR: cannot change a constant


    // ─────────────────────────────────
    // Arithmetic
    int x = 10, y = 3;
    cout << x + y << endl;   // 13  addition
    cout << x - y << endl;   // 7   subtraction
    cout << x * y << endl;   // 30  multiplication
    cout << x / y << endl;   // 3   integer division (no remainder)
    cout << x % y << endl;   // 1   modulo (remainder)

    double result = (double)x / y;   // cast x to double first
    cout << result << endl;          // 3.33333

    return 0;   // 0 means the program ran successfully
}',
'cpp', 1, 10),


(4,
'Input and Output — cin and cout',

'In C++, cout (pronounced "see-out") sends output to the screen, and cin (pronounced "see-in") reads input from the keyboard. Both are part of the iostream library, which you include at the top of every C++ program with #include <iostream>.

The << operator with cout means "send this to the output". You can chain multiple things together: cout << "Hello" << name << endl — this prints Hello, the value of name, and then a newline, all in one line. The >> operator with cin means "read from input into this variable".

One important limitation: cin stops reading at whitespace (a space or Enter). So if you want to read a full line of text including spaces, use getline(cin, variable) instead. This reads everything until Enter is pressed.',

'// Input and Output — cin and cout
// ──────────────────────────────────
#include <iostream>
#include <string>
using namespace std;

int main() {

    // ── Output with cout ───────────────────────────────
    cout << "Hello, World!" << endl;           // endl = newline + flush
    cout << "The answer is: " << 42 << endl;

    // You can chain multiple items in one cout
    int a = 5, b = 3;
    cout << a << " + " << b << " = " << (a + b) << endl;


    // ── Input with cin ─────────────────────────────────
    // Note: in the Coder compiler, input() is not interactive.
    // This code shows how it works; run it locally to test input.

    int age;
    cout << "Enter your age: ";
    cin >> age;                  // reads one integer from keyboard
    cout << "You are " << age << " years old." << endl;


    // ── Reading multiple values ─────────────────────────
    double x, y;
    cout << "Enter two numbers: ";
    cin >> x >> y;               // reads two values separated by space
    cout << "Sum: " << (x + y) << endl;


    // ── Reading a full line (with spaces) ───────────────
    string name;
    cout << "Enter your full name: ";
    cin.ignore();                // clear leftover newline from previous cin
    getline(cin, name);          // reads the entire line including spaces
    cout << "Hello, " << name << "!" << endl;


    // ── Formatting output ───────────────────────────────
    // \n is another way to print a newline (faster than endl)
    cout << "Line 1\nLine 2\nLine 3\n";

    // \t is a tab character
    cout << "Name\tAge\tGrade\n";
    cout << "Ahmed\t20\tA\n";
    cout << "Sara\t22\tB\n";

    return 0;
}',
'cpp', 2, 10),


(4,
'Making Decisions — if, else, switch',

'C++ uses the same if/else structure you find in most languages. The condition inside the if parentheses must evaluate to true or false. If it is true, the block runs; if false, the else block (if you wrote one) runs instead. You can chain conditions with else if to handle multiple cases.

C++ comparison operators: == (equals), != (not equals), > and < (greater/less than), >= and <= (greater/less than or equal). Logical operators: && means AND (both conditions must be true), || means OR (at least one must be true), ! means NOT (flips true to false).

The switch statement is clean and fast when you are checking one variable against several specific values. Each case must end with break — without it, execution falls through to the next case, which is usually not what you want (though sometimes it is, like grouping multiple cases together).',

'// Making Decisions in C++
// ──────────────────────────────────
#include <iostream>
using namespace std;

int main() {

    int score = 85;   // Try changing this!

    // if / else if / else
    if (score >= 90) {
        cout << "Grade: A" << endl;
    } else if (score >= 80) {
        cout << "Grade: B" << endl;
    } else if (score >= 70) {
        cout << "Grade: C" << endl;
    } else {
        cout << "Grade: F" << endl;
    }


    // ─────────────────────────────────
    // Combining conditions

    int age = 20;
    bool hasID = true;

    if (age >= 18 && hasID) {      // && = AND — both must be true
        cout << "Welcome in!" << endl;
    }

    bool isRaining  = true;
    bool isCold     = false;

    if (isRaining || isCold) {     // || = OR — at least one must be true
        cout << "Take a jacket." << endl;
    }

    if (!isCold) {                 // ! = NOT — flips the value
        cout << "It is not cold today." << endl;
    }


    // ─────────────────────────────────
    // switch — clean for many fixed values

    int day = 3;   // 1=Monday, 2=Tuesday, 3=Wednesday...

    switch (day) {
        case 1:
            cout << "Monday" << endl;
            break;          // IMPORTANT: break stops it falling to next case

        case 2:
            cout << "Tuesday" << endl;
            break;

        case 3:
            cout << "Wednesday" << endl;
            break;

        case 6:             // cases can share the same code block
        case 7:
            cout << "Weekend!" << endl;
            break;

        default:            // runs if no case matched (like else)
            cout << "Some other day." << endl;
    }

    return 0;
}',
'cpp', 3, 10),


(4,
'Loops — for, while, do-while',

'C++ gives you three types of loops. The for loop is best when you know how many iterations you need — it packs the start, condition, and step all into one line. The while loop runs as long as a condition remains true, and is better when the count is unknown upfront. The do-while loop always runs at least once, because it checks the condition at the end instead of the beginning.

You can also loop over arrays with a range-based for loop (added in C++11), which reads like English: "for each element in the array, do this". This is the preferred modern style when you just want to visit every element.

break and continue work the same as in other languages: break exits the loop immediately, and continue skips the rest of the current iteration and goes to the next one.',

'// Loops in C++
// ──────────────────────────────────
#include <iostream>
using namespace std;

int main() {

    // for loop — best when you know the count
    // Structure: for (start; condition; step)
    for (int i = 1; i <= 5; i++) {
        cout << "Step " << i << endl;   // Step 1, 2, 3, 4, 5
    }

    // Loop backwards
    for (int i = 5; i >= 1; i--) {
        cout << i << " ";
    }
    cout << endl;   // 5 4 3 2 1


    // ─────────────────────────────────
    // while loop — unknown count

    int countdown = 5;
    while (countdown > 0) {
        cout << "Launching in " << countdown << "..." << endl;
        countdown--;   // decrease each time — prevents infinite loop
    }
    cout << "Blast off!" << endl;


    // ─────────────────────────────────
    // do-while — always runs at least once

    int num = 10;
    do {
        cout << "num = " << num << endl;  // always prints at least once
        num++;
    } while (num < 5);   // condition is false from the start — still ran once!


    // ─────────────────────────────────
    // Range-based for loop (modern C++) — over an array

    int scores[] = {85, 92, 78, 95, 88};

    int total = 0;
    for (int score : scores) {    // "for each score in scores"
        total += score;
    }
    cout << "Total: " << total << endl;   // 438
    cout << "Avg:   " << total / 5.0 << endl;   // 87.6


    // ─────────────────────────────────
    // break and continue

    for (int i = 0; i < 10; i++) {
        if (i == 3) continue;   // skip 3
        if (i == 7) break;      // stop at 7
        cout << i << " ";       // 0 1 2 4 5 6
    }

    return 0;
}',
'cpp', 4, 10),


(4,
'Functions — Write Once, Reuse Everywhere',

'A function in C++ is a named block of code that does one specific job. You define it once and call it as many times as you need. Functions make your code shorter, more readable, and much easier to debug — if there is a bug in a calculation, you only have to fix it in one place instead of everywhere you copied it.

Every function has a return type (what kind of value it gives back), a name, and a parameter list (inputs). If the function gives nothing back, the return type is void. In C++, you must either define the function before you use it, or write a forward declaration (called a prototype) so the compiler knows the function exists.

C++ also supports function overloading — you can have multiple functions with the same name, as long as they have different parameter types or counts. The compiler picks the right one based on what you pass.',

'// Functions in C++
// ──────────────────────────────────
#include <iostream>
#include <string>
using namespace std;

// Function prototypes — tell the compiler these functions exist
// (needed when the function is defined BELOW main)
int    add(int a, int b);
double circleArea(double radius);
void   printBanner(string message);
int    max(int a, int b);
double max(double a, double b);   // overloaded version


int main() {

    cout << add(3, 7)       << endl;   // 10
    cout << add(100, -50)   << endl;   // 50

    cout << circleArea(5.0) << endl;   // 78.5398...

    printBanner("Hello from C++!");    // void — no return value

    cout << max(10, 20)     << endl;   // 20  (int version)
    cout << max(3.5, 2.8)   << endl;   // 3.5 (double version)

    return 0;
}


// Function definitions (can be below main since we have prototypes above)

// Takes two ints, returns their sum
int add(int a, int b) {
    return a + b;
}

// Takes a radius, returns the area of a circle
double circleArea(double radius) {
    const double PI = 3.14159265;
    return PI * radius * radius;
}

// Takes a string, prints it with a box — returns nothing (void)
void printBanner(string message) {
    int width = message.length() + 4;
    cout << string(width, ''*'') << endl;     // row of * symbols
    cout << "* " << message << " *" << endl;
    cout << string(width, ''*'') << endl;
}

// Function overloading — same name, different types
int    max(int a, int b)       { return a > b ? a : b; }
double max(double a, double b) { return a > b ? a : b; }',
'cpp', 5, 10),


-- ═══════════════════════════════════════════════════
--  HTML & CSS  (course_id = 5 , orders 1 – 5)
-- ═══════════════════════════════════════════════════

(5,
'Your First Web Page — HTML Structure',

'Every web page you have ever visited is built with HTML — HyperText Markup Language. HTML is not a programming language; it is a structure language. It tells the browser what things ARE: this is a heading, this is a paragraph, this is a link, this is an image. The browser then decides how to display them.

HTML is made up of elements. Each element has an opening tag like <h1> and a closing tag like </h1>. Everything between the tags is the content. Some elements are self-closing (like <img /> and <br />) because they have no content inside them.

Every proper HTML page has the same skeleton: <!DOCTYPE html> tells the browser this is modern HTML5. The <html> tag wraps everything. Inside it, <head> contains invisible settings (title, CSS links), and <body> contains everything the user actually sees on the page.',

'<!DOCTYPE html>
<!-- DOCTYPE tells the browser: this is an HTML5 document -->
<html lang="en">
<!-- lang="en" helps screen readers and search engines -->

<head>
  <!-- The head is invisible — settings and metadata go here -->
  <meta charset="UTF-8" />
  <!-- charset="UTF-8" supports all characters including emoji -->

  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <!-- viewport makes the page look good on phones -->

  <title>My First Web Page</title>
  <!-- title appears in the browser tab -->
</head>

<body>
  <!-- Everything inside body is visible on the page -->

  <h1>Welcome to My Page!</h1>
  <!-- h1 = most important heading. Only use ONE h1 per page. -->

  <h2>About Me</h2>
  <!-- h2 = sub-heading. You can have many h2, h3, h4, h5, h6 -->

  <p>Hello! My name is Ahmed and I am learning HTML.</p>
  <!-- p = paragraph. The browser adds space above and below. -->

  <p>I am a student at the University of Wollongong Dubai.</p>

  <!-- HTML ignores extra spaces and line breaks in your code -->
  <!-- Use tags to control formatting, not spaces -->

  <hr />
  <!-- hr = horizontal rule — a dividing line across the page -->

  <p>Feel free to <strong>explore</strong> and <em>experiment</em>!</p>
  <!-- strong = bold, em = italic (em means emphasis) -->

</body>
</html>',
'html', 1, 10),


(5,
'Text, Links and Images',

'HTML gives you many tags for formatting text. Headings go from h1 (biggest, most important) to h6 (smallest). Paragraphs are wrapped in p tags. For inline formatting inside a paragraph, strong makes text bold, em makes it italic, and code displays text in a monospace font — perfect for showing code snippets in the middle of a sentence.

Links are what make the web a web — they connect pages together. The a tag (anchor) creates a link. The href attribute tells it where to go. You can link to another website, another page in your project, or even an email address (use mailto:email@example.com). The target="_blank" attribute opens the link in a new tab.

Images are added with the img tag. The src attribute gives the path to the image file, and alt gives a text description for screen readers and for when the image fails to load. Always include alt — it matters for accessibility and for search engine ranking.',

'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Text, Links and Images</title>
</head>
<body>

  <!-- ── Headings ─────────────────────────── -->
  <h1>Main Title (h1)</h1>
  <h2>Section Heading (h2)</h2>
  <h3>Sub-section (h3)</h3>
  <!-- h4, h5, h6 get progressively smaller -->


  <!-- ── Text Formatting ──────────────────── -->
  <p>
    This is a <strong>bold word</strong> and this is <em>italic</em>.
    This is <u>underlined</u> and this is <code>monospace code</code>.
    This is <mark>highlighted text</mark>.
  </p>

  <p>Line one.<br />Line two starts here after a forced line break.</p>
  <!-- br = line break — use sparingly; prefer CSS margin for spacing -->


  <!-- ── Links ────────────────────────────── -->
  <!-- External link — opens in same tab -->
  <a href="https://www.google.com">Go to Google</a>

  <br />

  <!-- External link — opens in NEW tab (_blank) -->
  <a href="https://developer.mozilla.org" target="_blank">MDN Web Docs</a>

  <br />

  <!-- Link to another page in your project -->
  <a href="about.html">About Page</a>

  <br />

  <!-- Email link — opens the mail app -->
  <a href="mailto:hello@example.com">Send us an email</a>

  <br />

  <!-- Link to a section on the SAME page using id -->
  <a href="#footer">Jump to Footer</a>


  <!-- ── Images ───────────────────────────── -->
  <!-- src = path to image file, alt = description -->
  <img src="images/logo.png" alt="Coder platform logo" width="200" />

  <!-- Image from the internet (always check copyright!) -->
  <img
    src="https://via.placeholder.com/300x200"
    alt="A placeholder image 300 by 200 pixels"
    width="300"
  />


  <footer id="footer">
    <p>Bottom of the page — the id="footer" is what the jump link targets.</p>
  </footer>

</body>
</html>',
'html', 2, 10),


(5,
'Lists, Tables and Forms',

'Lists are one of the most used HTML elements. An unordered list (ul) shows bullet points, while an ordered list (ol) shows numbered items. Each item in either type is wrapped in an li tag. Lists can be nested — put a ul or ol inside an li to create a sub-list.

Tables organize data into rows and columns. The table element contains tr (table rows), which contain th (header cells) or td (data cells). th cells are bold and centered by default. Always add a caption or header row so the table makes sense without context. Tables should only be used for actual tabular data, not for page layout — that is what CSS is for.

Forms are how users send information to a website. The form element wraps all inputs. Each input has a type that controls its behavior: type="text" for words, type="email" for emails (browser validates format), type="password" hides the text. The label element connects to an input using for and id attributes — clicking the label focuses the input, which is important for accessibility.',

'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Lists, Tables and Forms</title>
</head>
<body>

  <!-- ── Unordered List (bullet points) ──── -->
  <h2>Programming Languages</h2>
  <ul>
    <li>Python</li>
    <li>JavaScript
      <ul>             <!-- nested list inside an li -->
        <li>React</li>
        <li>Node.js</li>
      </ul>
    </li>
    <li>Java</li>
    <li>C++</li>
  </ul>

  <!-- ── Ordered List (numbered) ─────────── -->
  <h2>Steps to Learn Coding</h2>
  <ol>
    <li>Pick a language</li>
    <li>Learn the basics</li>
    <li>Build a project</li>
    <li>Keep practising</li>
  </ol>


  <!-- ── Table ────────────────────────────── -->
  <h2>Student Grades</h2>
  <table border="1">                     <!-- border just for visibility -->
    <tr>
      <th>Name</th>   <!-- th = header cell (bold + centered) -->
      <th>Grade</th>
      <th>XP</th>
    </tr>
    <tr>
      <td>Ahmed</td>  <!-- td = data cell -->
      <td>A</td>
      <td>1500</td>
    </tr>
    <tr>
      <td>Sara</td>
      <td>B</td>
      <td>1200</td>
    </tr>
  </table>


  <!-- ── Form ─────────────────────────────── -->
  <h2>Sign Up</h2>

  <!-- action = where to send data, method = POST or GET -->
  <form action="/register" method="POST">

    <!-- label for="..." must match input id="..." -->
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" placeholder="Enter username" required />
    <br /><br />

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" placeholder="you@example.com" required />
    <br /><br />

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required />
    <br /><br />

    <!-- select = dropdown menu -->
    <label for="level">Level:</label>
    <select id="level" name="level">
      <option value="beginner">Beginner</option>
      <option value="intermediate">Intermediate</option>
      <option value="advanced">Advanced</option>
    </select>
    <br /><br />

    <!-- textarea = multi-line text input -->
    <label for="bio">About you:</label><br />
    <textarea id="bio" name="bio" rows="4" cols="40"></textarea>
    <br /><br />

    <button type="submit">Create Account</button>

  </form>

</body>
</html>',
'html', 3, 10),


(5,
'CSS Basics — Selectors and Properties',

'CSS (Cascading Style Sheets) is what makes web pages beautiful. HTML gives a page structure; CSS gives it color, fonts, spacing, and layout. You link a CSS file to your HTML with a link tag in the head, or you can write CSS directly inside a style tag.

A CSS rule has two parts: a selector (which element to style) and a declaration block (what to change). The selector can target elements by tag name (p, h1, div), by class (.card, .btn), or by id (#header, #footer). Class selectors are the most common in real projects because you can apply the same class to many elements.

Every HTML element is a box — this is called the CSS box model. From outside to inside: margin (space outside), border, padding (space inside), and content. Understanding the box model is one of the most important fundamentals because it controls all spacing and sizing on the page.',

'/* CSS Basics — this goes in your style.css file */

/* ── Element selector — targets ALL h1 tags ──── */
h1 {
  color: #6c63ff;          /* purple text */
  font-size: 2rem;         /* 2x the base font size */
  text-align: center;
}

/* ── Element selector — all paragraphs ─────── */
p {
  font-family: Arial, sans-serif;
  font-size: 1rem;
  line-height: 1.6;        /* space between lines */
  color: #333333;
}


/* ── Class selector — starts with a dot ──────── */
/* Apply with: <div class="card"> in HTML */
.card {
  background-color: #ffffff;
  border: 1px solid #dddddd;
  border-radius: 12px;     /* rounded corners */
  padding: 20px;           /* space INSIDE the border */
  margin: 16px;            /* space OUTSIDE the border */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);   /* soft shadow */
}

.card-title {
  font-size: 1.25rem;
  font-weight: 700;        /* bold */
  margin-bottom: 8px;
}


/* ── ID selector — starts with a # ───────────── */
/* Apply with: <div id="header"> in HTML */
/* Use IDs sparingly — classes are more reusable */
#header {
  background-color: #6c63ff;
  color: white;
  padding: 16px 32px;
}


/* ── Box model example ────────────────────────── */
.box {
  width:   300px;          /* content width */
  padding: 20px;           /* space inside border */
  border:  2px solid red;  /* border itself */
  margin:  10px auto;      /* 10px top/bottom, auto = centered */
  /* Total visual width = 300 + 20+20 (padding) + 2+2 (border) = 344px */
}


/* ── Colors and backgrounds ───────────────────── */
.hero {
  background-color: #f0f4ff;  /* solid color */
  background: linear-gradient(135deg, #6c63ff, #a855f7);  /* gradient */
  color: white;
  text-align: center;
  padding: 60px 20px;
}

/* ── Text styling ─────────────────────────────── */
.highlight {
  color:            #e44d26;
  font-weight:      bold;
  text-decoration:  underline;
  letter-spacing:   1px;   /* space between letters */
  text-transform:   uppercase;
}',
'html', 4, 10),


(5,
'CSS Layout with Flexbox',

'Before Flexbox, centering something vertically in CSS was notoriously difficult. Flexbox changed everything. It is a one-dimensional layout system — it arranges items in a row OR a column and gives you powerful alignment tools with just a few properties.

You activate Flexbox by setting display: flex on a container. Its direct children automatically become flex items. By default, items line up in a row. The most-used properties are: justify-content (aligns items along the main axis — left, right, center, space-between) and align-items (aligns items on the cross axis — top, middle, bottom). These two alone solve 90% of layout challenges.

Flexbox is also responsive. Using flex-wrap: wrap allows items to flow onto multiple lines instead of shrinking infinitely. Giving items flex: 1 makes them share the available space equally. This pattern — a flex container with wrapping flex children — is the basis of almost every card grid you see on the modern web.',

'/* ── Flexbox Layout ──────────────────────────── */

/* ── 1. Horizontal navigation bar ─────────────── */
.navbar {
  display: flex;                   /* activate flexbox */
  justify-content: space-between;  /* push logo left, links right */
  align-items: center;             /* vertically center everything */
  padding: 0 32px;
  height: 64px;
  background: #1e1e2e;
}

.nav-links {
  display: flex;
  gap: 24px;                       /* space between each link */
  list-style: none;
}


/* ── 2. Perfectly centered hero section ───────── */
.hero {
  display: flex;
  flex-direction: column;          /* stack children vertically */
  justify-content: center;         /* center vertically */
  align-items: center;             /* center horizontally */
  min-height: 80vh;                /* take up 80% of screen height */
  text-align: center;
}


/* ── 3. Card grid that wraps automatically ────── */
.cards-container {
  display: flex;
  flex-wrap: wrap;                 /* items wrap to next line if needed */
  gap: 24px;                       /* space between cards */
  padding: 32px;
}

.card {
  flex: 1;                         /* each card grows equally */
  min-width: 250px;                /* but never smaller than 250px */
  max-width: 350px;
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
}


/* ── 4. Two-column layout: sidebar + content ──── */
.page-layout {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  width: 260px;                    /* fixed width */
  flex-shrink: 0;                  /* never let it shrink */
  background: #f8f9fa;
  padding: 24px;
}

.main-content {
  flex: 1;                         /* take all remaining space */
  padding: 32px;
  overflow: auto;
}


/* ── 5. Responsive: stack vertically on mobile ── */
@media (max-width: 768px) {
  .page-layout {
    flex-direction: column;        /* sidebar goes on top on small screens */
  }

  .sidebar {
    width: 100%;                   /* full width on mobile */
  }

  .cards-container {
    flex-direction: column;        /* stack cards vertically */
  }
}',
'html', 5, 10),


-- ═══════════════════════════════════════════════════
--  SQL  (course_id = 6 , orders 1 – 5)
-- ═══════════════════════════════════════════════════

(6,
'What is SQL? Your First SELECT',

'SQL (Structured Query Language) is the language you use to talk to a database. Almost every app on the internet uses a database behind the scenes — Facebook stores posts, Amazon stores products, Netflix stores user preferences. SQL is the universal language all of them use to store, retrieve, and manage that data.

A relational database stores data in tables. A table looks like a spreadsheet: it has columns (like Name, Age, Email) and rows (each row is one record). The magic of SQL is that you can ask precise questions about millions of rows in milliseconds — far faster than scrolling through a spreadsheet.

The SELECT statement is how you read data from a table. You write SELECT to say what columns you want, FROM to say which table, and optionally WHERE to filter rows. SELECT * means "give me all columns". SQL is not case-sensitive for keywords (select and SELECT both work), but the convention is to write keywords in UPPERCASE to make them stand out.',

'-- SQL: SELECT Basics
-- Run these in phpMyAdmin or any SQL tool

-- ── Select everything from a table ─────────────
SELECT * FROM users;
-- The * means "all columns". Returns every row and every column.


-- ── Select specific columns only ────────────────
SELECT username, email FROM users;
-- Only returns the username and email columns. Faster and cleaner.


-- ── Give columns a friendlier name (alias) ──────
SELECT
    username  AS "User Name",
    email     AS "Email Address",
    xp        AS "XP Points"
FROM users;
-- AS renames the column in the output (does not change the table)


-- ── Using the Coder database as an example ──────

-- Show all courses
SELECT * FROM courses;

-- Show just course names and difficulty levels
SELECT title, level, duration FROM courses;

-- Show all lessons with their title and XP reward
SELECT title, language, xp_reward, order_num FROM lessons;


-- ── DISTINCT — remove duplicate values ──────────
SELECT DISTINCT language FROM lessons;
-- Returns each language only once: python, java, javascript, cpp, html, sql


-- ── COUNT — how many rows? ──────────────────────
SELECT COUNT(*) AS total_lessons FROM lessons;
-- Returns one number: the total count of rows in the lessons table


-- ── LIMIT — only return a few rows ─────────────
SELECT title, xp_reward FROM lessons LIMIT 5;
-- Only show the first 5 results. Useful for preview/pagination.',
'sql', 1, 10),


(6,
'Filtering with WHERE, AND, OR, LIKE',

'Selecting all rows is useful, but most of the time you only want specific rows — users from a certain country, products under a certain price, orders placed after a certain date. The WHERE clause is how you filter rows. Only rows where the condition is true are included in the result.

You can combine multiple conditions with AND (both must be true) and OR (at least one must be true). You can negate a condition with NOT. When mixing AND and OR, use parentheses to make the logic clear — just like in maths, the computer evaluates AND before OR, which can cause surprising results.

LIKE is a special operator for partial text matching. The % symbol is a wildcard that matches any sequence of characters. So LIKE ''A%'' matches anything starting with A, LIKE ''%@gmail.com'' matches any Gmail address, and LIKE ''%python%'' matches anything that contains the word python anywhere.',

'-- SQL: Filtering with WHERE
-- ───────────────────────────────────────────────

-- ── Basic WHERE ─────────────────────────────────
SELECT title, level FROM courses WHERE level = ''Beginner'';
-- Returns only courses where level is exactly Beginner


-- ── Comparison operators ─────────────────────────
-- =    equal
-- !=   not equal (also written <>)
-- >    greater than
-- <    less than
-- >=   greater than or equal to
-- <=   less than or equal to

SELECT title, xp_reward FROM lessons WHERE xp_reward >= 15;

SELECT title FROM courses WHERE level != ''Beginner'';


-- ── AND — both conditions must be true ───────────
SELECT title, level, duration
FROM courses
WHERE level = ''Beginner'' AND duration = ''6 weeks'';


-- ── OR — at least one condition must be true ─────
SELECT title, language
FROM lessons
WHERE language = ''python'' OR language = ''javascript'';


-- ── NOT — negate a condition ─────────────────────
SELECT title, level FROM courses WHERE NOT level = ''Advanced'';


-- ── Parentheses to control logic ─────────────────
-- Find lessons that are Python OR Java, but only the ones with high XP
SELECT title, language, xp_reward
FROM lessons
WHERE (language = ''python'' OR language = ''java'') AND xp_reward >= 15;


-- ── LIKE — partial text matching ─────────────────
-- % matches ANYTHING (zero or more characters)

SELECT title FROM courses WHERE title LIKE ''%&%'';
-- Returns: "HTML & CSS" (contains &)

SELECT title FROM lessons WHERE title LIKE ''Loop%'';
-- Returns all lessons whose title STARTS with "Loop"

SELECT title FROM lessons WHERE title LIKE ''%Function%'';
-- Returns all lessons whose title CONTAINS "Function"


-- ── IN — match any value from a list ─────────────
SELECT title, language
FROM lessons
WHERE language IN (''python'', ''java'', ''javascript'');
-- Much cleaner than writing OR three times


-- ── BETWEEN — range check ────────────────────────
SELECT title, xp_reward
FROM lessons
WHERE xp_reward BETWEEN 10 AND 15;
-- Includes both endpoints (10 and 15)',
'sql', 2, 10),


(6,
'Sorting, Grouping and Aggregate Functions',

'Sorting results makes data useful. The ORDER BY clause sorts your results by one or more columns. By default the sort is ascending (ASC — smallest to largest, A to Z), but you can add DESC to sort descending (largest to smallest, Z to A). You can sort by multiple columns — the second column is used as a tiebreaker when two rows have the same value for the first column.

Aggregate functions collapse many rows into a single value. COUNT() counts rows, SUM() adds numbers, AVG() calculates the average, MAX() finds the largest value, and MIN() finds the smallest. These are some of the most useful functions in SQL for reports and dashboards.

GROUP BY is what makes aggregate functions powerful. It splits the rows into groups first, then applies the aggregate to each group separately. For example: GROUP BY language with COUNT(*) tells you how many lessons exist for each language — you get one result row per language, not one result for the whole table.',

'-- SQL: Sorting, Grouping and Aggregates
-- ───────────────────────────────────────────────

-- ── ORDER BY — sort the results ──────────────────
SELECT title, xp_reward
FROM lessons
ORDER BY xp_reward DESC;   -- highest XP first (DESC = descending)

SELECT title, language, order_num
FROM lessons
ORDER BY language ASC, order_num ASC;
-- Sort by language A→Z, then by lesson number within each language


-- ── LIMIT with ORDER BY ───────────────────────────
-- Top 5 lessons by XP
SELECT title, xp_reward
FROM lessons
ORDER BY xp_reward DESC
LIMIT 5;


-- ── Aggregate Functions ──────────────────────────
-- COUNT(*) — how many rows
SELECT COUNT(*) AS total_lessons FROM lessons;

-- SUM() — add up a column
SELECT SUM(xp_reward) AS total_xp_available FROM lessons;

-- AVG() — average value
SELECT AVG(xp_reward) AS average_xp FROM lessons;

-- MAX() and MIN() — highest and lowest
SELECT
    MAX(xp_reward) AS highest_xp,
    MIN(xp_reward) AS lowest_xp
FROM lessons;


-- ── GROUP BY — aggregate per group ───────────────
-- How many lessons does each language have?
SELECT
    language,
    COUNT(*) AS lesson_count
FROM lessons
GROUP BY language
ORDER BY lesson_count DESC;


-- Average XP per language
SELECT
    language,
    ROUND(AVG(xp_reward), 2) AS avg_xp,
    SUM(xp_reward)           AS total_xp,
    COUNT(*)                 AS lessons
FROM lessons
GROUP BY language;


-- ── HAVING — filter AFTER grouping ───────────────
-- Like WHERE, but for groups (WHERE runs before GROUP BY, HAVING after)
SELECT
    language,
    COUNT(*) AS lesson_count
FROM lessons
GROUP BY language
HAVING lesson_count >= 5;   -- only show languages with 5+ lessons',
'sql', 3, 10),


(6,
'Inserting, Updating and Deleting Data',

'SQL is not just for reading — you can also add new data, change existing data, and delete data. These are called DML statements: Data Manipulation Language. The three key ones are INSERT (add a new row), UPDATE (change existing rows), and DELETE (remove rows).

INSERT INTO adds one or more new rows to a table. You list the column names in parentheses, then the values in the same order after VALUES. You should always list the column names explicitly — that way, if someone later adds a new column to the table, your INSERT still works correctly.

UPDATE and DELETE are the two most dangerous SQL statements. Both can affect thousands of rows at once. The golden rule is: ALWAYS include a WHERE clause with UPDATE and DELETE. Without WHERE, you update or delete EVERY SINGLE ROW in the table. A good habit is to write the WHERE clause first, test it with a SELECT to see what rows it matches, then turn it into UPDATE or DELETE.',

'-- SQL: INSERT, UPDATE, DELETE
-- ───────────────────────────────────────────────

-- ── INSERT — add a new row ───────────────────────

-- Basic INSERT: list columns, then values in the same order
INSERT INTO courses (title, description, language, level, duration, lessons, icon, color)
VALUES (''TypeScript'', ''JavaScript with types — build safer, larger apps.'', ''typescript'', ''Intermediate'', ''8 weeks'', 30, ''fas fa-code'', ''#3178C6'');

-- Insert multiple rows in one statement (more efficient)
INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward)
VALUES
    (1, ''Lesson 11'', ''Advanced Python content here.'', ''print("Advanced!")'', ''python'', 11, 20),
    (1, ''Lesson 12'', ''More Python content.'',           ''print("More!")'',      ''python'', 12, 20);


-- ── UPDATE — change existing rows ────────────────

-- ALWAYS check with SELECT first:
SELECT * FROM lessons WHERE language = ''python'' AND order_num = 11;

-- Then update safely:
UPDATE lessons
SET title = ''Advanced Python — Generators'',
    xp_reward = 25
WHERE language = ''python'' AND order_num = 11;

-- Update multiple columns at once
UPDATE users
SET xp       = xp + 100,
    username = ''Ahmed_Updated''
WHERE id = 1;


-- ── DELETE — remove rows ─────────────────────────

-- ALWAYS check with SELECT first:
SELECT * FROM lessons WHERE course_id = 1 AND order_num > 10;

-- Then delete safely:
DELETE FROM lessons WHERE course_id = 1 AND order_num > 10;


-- ── The danger of missing WHERE ──────────────────
-- DELETE FROM lessons;          -- DELETES EVERY LESSON! Never do this.
-- UPDATE users SET xp = 0;      -- RESETS EVERY USER''S XP! Never do this.


-- ── INSERT ... ON DUPLICATE KEY UPDATE ───────────
-- Upsert: insert if not exists, update if it does
INSERT INTO user_progress (user_id, lesson_id)
VALUES (1, 5)
ON DUPLICATE KEY UPDATE completed_at = NOW();


-- ── Check your changes with SELECT ───────────────
SELECT id, title, xp_reward FROM lessons WHERE language = ''python'' ORDER BY order_num;',
'sql', 4, 10),


(6,
'JOINs — Combining Tables',

'A relational database stores related data in separate tables to avoid repetition. For example, rather than storing the course name in every lesson row, you store the course_id and keep the course details in a separate courses table. This is called normalization. JOINs are how you put the pieces back together when you need data from multiple tables.

The INNER JOIN (or just JOIN) returns only the rows that have a match in both tables. If a lesson has a course_id that does not exist in the courses table, that lesson is excluded. This is the most common type of join and what you will use 90% of the time.

LEFT JOIN returns all rows from the left table, plus matching rows from the right table. If there is no match on the right, the right side columns come back as NULL. This is useful when you want to see everything from one table, including items that might not have related data yet — like showing all users, even those who have not completed any lessons.',

'-- SQL: JOINs — Combining Tables
-- ───────────────────────────────────────────────

-- Our tables and how they relate:
-- courses   (id, title, language, level, ...)
-- lessons   (id, course_id, title, language, xp_reward, ...)
-- users     (id, username, email, xp, ...)
-- user_progress (user_id, lesson_id, completed_at)


-- ── INNER JOIN — rows that match in BOTH tables ──
-- Show each lesson with its course title

SELECT
    c.title       AS course_name,    -- c = alias for courses table
    l.title       AS lesson_name,
    l.language,
    l.xp_reward
FROM lessons l                       -- l = alias for lessons table
INNER JOIN courses c ON l.course_id = c.id;
-- ON says: match rows where lesson.course_id equals course.id


-- ── Filter a JOIN with WHERE ──────────────────────
-- Python lessons only, with their course name
SELECT c.title AS course, l.title AS lesson, l.order_num
FROM lessons l
JOIN courses c ON l.course_id = c.id
WHERE l.language = ''python''
ORDER BY l.order_num;


-- ── Three-table JOIN ─────────────────────────────
-- Show each user''s completed lessons with course info

SELECT
    u.username,
    l.title         AS lesson,
    c.title         AS course,
    l.xp_reward,
    up.completed_at
FROM user_progress up
JOIN users   u ON up.user_id   = u.id
JOIN lessons l ON up.lesson_id = l.id
JOIN courses c ON l.course_id  = c.id
ORDER BY up.completed_at DESC;


-- ── LEFT JOIN — all from left, NULLs where no match ──
-- Show ALL courses, and how many lessons each has
-- (even a course with zero lessons would appear)

SELECT
    c.title,
    COUNT(l.id) AS lesson_count
FROM courses c
LEFT JOIN lessons l ON l.course_id = c.id
GROUP BY c.id, c.title
ORDER BY lesson_count DESC;


-- ── Practical: leaderboard query ──────────────────
-- Show top 10 users by XP with their lesson count

SELECT
    u.username,
    u.xp,
    COUNT(up.lesson_id) AS lessons_completed
FROM users u
LEFT JOIN user_progress up ON up.user_id = u.id
GROUP BY u.id, u.username, u.xp
ORDER BY u.xp DESC
LIMIT 10;',
'sql', 5, 10);

-- Update lesson counts so the courses page shows the correct number
UPDATE courses SET lessons = 5 WHERE id = 4;   -- C++
UPDATE courses SET lessons = 5 WHERE id = 5;   -- HTML & CSS
UPDATE courses SET lessons = 5 WHERE id = 6;   -- SQL
