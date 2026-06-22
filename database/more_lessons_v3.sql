-- ============================================================
-- CODER — more_lessons_v3.sql
-- Adds: C++ 6-10, HTML/CSS 6-10, SQL 6-10
--       New courses: TypeScript, React, Git & GitHub
-- Import via phpMyAdmin: coder_db → Import → choose this file → Go
-- ============================================================

USE coder_db;

-- ═══════════════════════════════════════════════════════════
--  ADD 3 NEW COURSES
-- ═══════════════════════════════════════════════════════════

INSERT IGNORE INTO courses (title, description, language, level, duration, lessons, icon, color) VALUES
('TypeScript',    'Add types to JavaScript and write safer, larger-scale applications with confidence.',   'typescript', 'Intermediate', '5 weeks',  10, 'fas fa-code',    '#3178C6'),
('React',         'Build fast, interactive UIs with the world''s most popular frontend framework.',       'react',      'Intermediate', '8 weeks',  10, 'fab fa-react',   '#61DAFB'),
('Git & GitHub',  'Master version control — track changes, collaborate with teams, and ship with confidence.', 'bash', 'Beginner',   '3 weeks',  10, 'fab fa-git-alt', '#F05032');


-- ═══════════════════════════════════════════════════════════
--  C++  — lessons 6 to 10  (course_id = 4)
-- ═══════════════════════════════════════════════════════════

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(4, 'Arrays and Vectors — Storing Many Values',
'An array is a fixed-size collection of items of the same type stored in memory one after another. You declare it by writing the type, the name, and the size in square brackets. Arrays are fast because accessing any element by its index takes the same tiny amount of time — the computer just calculates the memory address directly.

The problem with arrays is that their size is fixed when you create them. If you need a collection that can grow and shrink, C++ gives you vector from the Standard Template Library. A vector is essentially a smarter, resizable array. You can push elements onto the end, remove the last element, check the size, and loop over it — all with clean built-in methods.

Vectors are what you will use in almost every real C++ program. Arrays are still useful when you know the exact size at compile time and need maximum performance — like storing the days of the week or a fixed set of sensor readings.',
'// Arrays and Vectors in C++
// ─────────────────────────────
#include <iostream>
#include <vector>    // needed for vector
#include <string>
using namespace std;

int main() {

    // ── Fixed-size C++ array ─────────────────────
    int scores[5] = {85, 92, 78, 95, 88};

    cout << "First score: " << scores[0] << endl;   // index starts at 0
    cout << "Last score:  " << scores[4] << endl;

    // Loop over an array
    int total = 0;
    for (int i = 0; i < 5; i++) {
        total += scores[i];
    }
    cout << "Average: " << total / 5.0 << endl;


    // ── Vector — resizable, preferred in modern C++ ─
    vector<string> languages;        // empty vector of strings

    // Add elements to the end
    languages.push_back("Python");
    languages.push_back("Java");
    languages.push_back("C++");

    cout << "Size: " << languages.size() << endl;   // 3
    cout << "First: " << languages[0] << endl;      // Python

    // Add one more
    languages.push_back("JavaScript");

    // Loop with range-based for
    for (const string& lang : languages) {
        cout << lang << endl;
    }

    // Remove the last element
    languages.pop_back();
    cout << "After pop: " << languages.size() << endl;   // 3


    // ── Vector initialised with values ─────────────
    vector<int> primes = {2, 3, 5, 7, 11, 13};

    // Find the largest using a loop
    int largest = primes[0];
    for (int p : primes) {
        if (p > largest) largest = p;
    }
    cout << "Largest prime: " << largest << endl;   // 13

    return 0;
}',
'cpp', 6, 15),


(4, 'Pointers and References — Understanding Memory',
'Every variable you create lives somewhere in the computer''s memory. A pointer is a variable that stores a memory address — it "points to" where another variable lives. This sounds simple, but it is one of the most powerful (and most misunderstood) ideas in C++.

You declare a pointer with a * before the variable name. To get the address of a variable, use &. To get the value AT an address (dereference it), use * again. It is the same symbol with two different meanings depending on context — this is what confuses beginners at first.

References are a safer, simpler alternative to pointers. A reference is just an alias — another name for the same variable. The key difference: a reference must be initialised when declared and cannot be changed to refer to a different variable. References are especially useful for passing large objects to functions without copying them.',
'// Pointers and References in C++
// ──────────────────────────────────
#include <iostream>
using namespace std;

// Function using a pointer — can modify the original
void doubleIt_ptr(int* p) {
    *p = *p * 2;   // dereference p to get the value, then double it
}

// Function using a reference — cleaner syntax, same effect
void doubleIt_ref(int& n) {
    n = n * 2;     // n IS the original variable — no * needed
}

// Pass by VALUE — makes a copy, original unchanged
void doubleIt_val(int n) {
    n = n * 2;     // only the local copy changes
}

int main() {

    // ── Pointer basics ────────────────────────────
    int age = 25;
    int* ptr = &age;    // ptr stores the ADDRESS of age

    cout << "age:          " << age  << endl;   // 25    — the value
    cout << "address (&):  " << ptr  << endl;   // 0x... — the address
    cout << "via ptr (*):  " << *ptr << endl;   // 25    — the value at that address

    // Changing the value through the pointer
    *ptr = 30;
    cout << "age after *ptr=30: " << age << endl;   // 30


    // ── Reference basics ──────────────────────────
    int score = 100;
    int& ref = score;   // ref is an alias for score — same memory!

    ref = 150;
    cout << "score after ref=150: " << score << endl;   // 150


    // ── Pass by value vs pointer vs reference ─────
    int x = 10;

    doubleIt_val(x);
    cout << "After val: " << x << endl;   // 10 — unchanged

    doubleIt_ptr(&x);                      // pass the ADDRESS of x
    cout << "After ptr: " << x << endl;   // 20 — changed!

    doubleIt_ref(x);                       // pass x directly — ref handles it
    cout << "After ref: " << x << endl;   // 40 — changed!

    return 0;
}',
'cpp', 7, 15),


(4, 'Classes and Objects — OOP in C++',
'C++ was one of the first languages to bring object-oriented programming to mainstream use. A class is a blueprint that bundles related data (member variables) and behaviour (member functions, called methods) into one unit. An object is a specific instance built from that blueprint.

By default, everything inside a C++ class is private — it can only be accessed from within the class. This is called encapsulation: you hide the internal data and expose only what you want through a public interface. The public: keyword makes members accessible from outside, and private: (the default) keeps them hidden.

The constructor is a special method with the same name as the class. It runs automatically when you create an object and is where you set initial values. The destructor (same name with a ~ prefix) runs when the object is destroyed — useful for cleaning up resources like files or network connections.',
'// Classes and Objects in C++
// ──────────────────────────────────
#include <iostream>
#include <string>
using namespace std;

class BankAccount {
private:
    // Private data — can only be accessed through public methods
    string owner;
    double balance;
    int    accountNumber;

public:
    // Constructor — runs when you create a BankAccount object
    BankAccount(string name, double initialBalance, int number) {
        owner         = name;
        balance       = initialBalance;
        accountNumber = number;
        cout << "Account created for " << owner << "." << endl;
    }

    // Destructor — runs when the object goes out of scope
    ~BankAccount() {
        cout << "Account for " << owner << " closed." << endl;
    }

    // Public methods — the safe interface to private data
    void deposit(double amount) {
        if (amount <= 0) {
            cout << "Deposit amount must be positive." << endl;
            return;
        }
        balance += amount;
        cout << "Deposited $" << amount << ". New balance: $" << balance << endl;
    }

    bool withdraw(double amount) {
        if (amount > balance) {
            cout << "Insufficient funds!" << endl;
            return false;
        }
        balance -= amount;
        cout << "Withdrew $" << amount << ". New balance: $" << balance << endl;
        return true;
    }

    // Getter — read-only access to private data
    double getBalance() const { return balance; }
    string getOwner()   const { return owner; }
};


int main() {
    // Create objects from the BankAccount blueprint
    BankAccount ahmed("Ahmed", 1000.00, 1001);
    BankAccount sara("Sara",   500.00,  1002);

    ahmed.deposit(250.00);
    ahmed.withdraw(100.00);
    sara.withdraw(600.00);     // will fail — insufficient funds

    cout << "Ahmed''s balance: $" << ahmed.getBalance() << endl;

    // ahmed.balance = 9999;   // ERROR — balance is private!

    return 0;   // destructors run here automatically
}',
'cpp', 8, 15),


(4, 'Inheritance — Building on Existing Classes',
'Inheritance lets you create a new class based on an existing one. The new class (called the child or derived class) automatically gets all the public and protected members of the parent (base class), and can then add its own members or override existing behaviour. This lets you reuse code instead of copying it.

The syntax is: class Child : public Parent. The public keyword controls how the inherited members are accessed — public inheritance is by far the most common and keeps public members public in the child. The child class constructor calls the parent constructor using an initialiser list.

Virtual functions are the key to polymorphism — the ability to treat different objects through a common interface. When you declare a function virtual in the base class, you can override it in derived classes. A pointer to the base class can then call the correct version of the function depending on the actual object it points to.',
'// Inheritance in C++
// ──────────────────────────────────
#include <iostream>
#include <string>
using namespace std;

// ── Base class ────────────────────────────────
class Animal {
protected:
    string name;    // protected: accessible in derived classes
    int    age;

public:
    Animal(string n, int a) : name(n), age(a) {}

    // virtual = can be overridden by derived classes
    virtual void speak() const {
        cout << name << " makes a sound." << endl;
    }

    virtual string getType() const {
        return "Animal";
    }

    void describe() const {
        cout << getType() << " | Name: " << name << " | Age: " << age << endl;
    }
};


// ── Derived class — inherits from Animal ──────
class Dog : public Animal {
private:
    string breed;

public:
    // Call parent constructor via initialiser list
    Dog(string n, int a, string b) : Animal(n, a), breed(b) {}

    // Override speak() — replaces the base class version
    void speak() const override {
        cout << name << " says: Woof!" << endl;
    }

    string getType() const override { return "Dog"; }

    void fetch() const {
        cout << name << " fetches the ball!" << endl;
    }
};


class Cat : public Animal {
public:
    Cat(string n, int a) : Animal(n, a) {}

    void speak() const override {
        cout << name << " says: Meow!" << endl;
    }

    string getType() const override { return "Cat"; }
};


int main() {
    Dog dog("Rex",    3, "Labrador");
    Cat cat("Whiskers", 5);

    dog.describe();    // Dog | Name: Rex | Age: 3
    cat.describe();    // Cat | Name: Whiskers | Age: 5

    dog.speak();       // Rex says: Woof!
    cat.speak();       // Whiskers says: Meow!
    dog.fetch();       // Rex fetches the ball!


    // ── Polymorphism: base class pointer, derived object ──
    Animal* animals[] = { &dog, &cat };

    cout << "\nAll animals speak:" << endl;
    for (Animal* a : animals) {
        a->speak();    // calls Dog::speak() or Cat::speak() — not Animal::speak()
    }

    return 0;
}',
'cpp', 9, 15),


(4, 'File I/O — Reading and Writing Files',
'Programs that only work with data typed in at runtime are limited — their results disappear when the program ends. File I/O lets your programs save results permanently and load data from existing files. In C++, file operations are done through the fstream library, which gives you ifstream (input/read), ofstream (output/write), and fstream (both).

Working with files follows a clear pattern: open the file, read or write, close the file. Always check if the file opened successfully before proceeding — if you try to read a file that does not exist, the stream will be in a bad state and all reads will silently fail.

Reading a file line by line with getline() is the most common pattern. For writing, the << operator works exactly the same as with cout — just replace cout with your file stream. When writing with ofstream, the file is created if it does not exist, or overwritten if it does. Use ios::app to append to an existing file instead of overwriting it.',
'// File I/O in C++
// ──────────────────────────────────
#include <iostream>
#include <fstream>   // for ifstream, ofstream
#include <string>
using namespace std;

int main() {

    // ── Writing to a file ─────────────────────────
    ofstream outFile("scores.txt");   // creates or overwrites the file

    if (!outFile.is_open()) {
        cout << "Error: could not create scores.txt" << endl;
        return 1;
    }

    // Write lines — << works just like cout
    outFile << "Ahmed 95" << endl;
    outFile << "Sara  88" << endl;
    outFile << "Omar  72" << endl;

    outFile.close();   // always close when done
    cout << "File written successfully." << endl;


    // ── Reading a file line by line ───────────────
    ifstream inFile("scores.txt");   // open for reading

    if (!inFile.is_open()) {
        cout << "Error: could not open scores.txt" << endl;
        return 1;
    }

    string line;
    cout << "\nContents of scores.txt:" << endl;
    while (getline(inFile, line)) {   // reads one line at a time
        cout << "  " << line << endl;
    }
    inFile.close();


    // ── Appending to an existing file ─────────────
    ofstream appendFile("scores.txt", ios::app);   // ios::app = append mode
    appendFile << "Fatima 91" << endl;
    appendFile.close();
    cout << "\nAppended a new score." << endl;


    // ── Reading word by word ──────────────────────
    ifstream wordFile("scores.txt");
    string name;
    int    score;

    cout << "\nParsed results:" << endl;
    while (wordFile >> name >> score) {   // reads one word, then one int
        cout << "  " << name << " scored " << score << endl;
    }
    wordFile.close();

    return 0;
}',
'cpp', 10, 15),


-- ═══════════════════════════════════════════════════════════
--  HTML & CSS  — lessons 6 to 10  (course_id = 5)
-- ═══════════════════════════════════════════════════════════

(5, 'CSS Grid — Two-Dimensional Layouts',
'Flexbox works in one direction at a time — either a row or a column. CSS Grid works in two dimensions simultaneously — rows AND columns at once. It is perfect for overall page layout: a header that spans the full width, a sidebar on the left, main content on the right, and a footer below. Things that used to require complex float hacks or nested Flexbox containers are now just a few lines of CSS Grid.

You activate Grid by setting display: grid on a container. Then you define your columns with grid-template-columns and your rows with grid-template-rows. The fr unit (fraction) distributes available space proportionally — 1fr 2fr gives the second column twice as much space as the first. grid-gap (or gap) sets the space between all cells at once.

Grid items can span multiple columns or rows using grid-column: 1 / 3 (from line 1 to line 3) or the shorthand span 2 (span 2 tracks). Named template areas make complex layouts readable — you draw the layout visually in CSS with strings, and each element claims its area by name.',
'/* CSS Grid — Two-Dimensional Layouts */

/* ── 1. Basic grid with named areas ─────────── */
.page-layout {
  display: grid;

  /* Define columns: fixed sidebar, flexible content, fixed sidebar */
  grid-template-columns: 250px 1fr 250px;

  /* Define rows: auto-height header, flexible content, auto footer */
  grid-template-rows: auto 1fr auto;

  /* "Draw" the layout — each string is a row, each word is a cell */
  grid-template-areas:
    "header  header  header"
    "sidebar content aside"
    "footer  footer  footer";

  gap: 20px;         /* space between ALL cells */
  min-height: 100vh;
}

/* Each section claims its area by name */
.header  { grid-area: header;  background: #6c63ff; color: white; padding: 20px; }
.sidebar { grid-area: sidebar; background: #f8f9fa; padding: 20px; }
.content { grid-area: content; padding: 20px; }
.aside   { grid-area: aside;   background: #f8f9fa; padding: 20px; }
.footer  { grid-area: footer;  background: #1e1e2e; color: white;  padding: 20px; }


/* ── 2. Card grid — auto-fit and minmax ──────── */
/* Creates as many columns as fit, each at least 280px wide */
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
  padding: 32px;
}
/* Magic: on a 1200px screen → 4 columns. On 600px → 2. On 320px → 1. */
/* No media queries needed! */


/* ── 3. Spanning multiple cells ──────────────── */
.featured-card {
  grid-column: span 2;   /* this card takes up 2 columns */
  grid-row:    span 2;   /* and 2 rows */
}

/* Line-based placement (precise) */
.banner {
  grid-column: 1 / 4;   /* from line 1 to line 4 = all 3 columns */
  grid-row:    1 / 2;
}


/* ── 4. Centering with Grid ───────────────────── */
.center-everything {
  display: grid;
  place-items: center;   /* shorthand for align-items + justify-items */
  min-height: 100vh;
}',
'html', 6, 15),


(5, 'CSS Animations and Transitions',
'Static websites feel lifeless. Motion — when used thoughtfully — makes interfaces feel responsive and alive. CSS gives you two tools for this: transitions (smooth change from one state to another) and animations (multi-step sequences that can loop).

A transition watches a CSS property and smoothly interpolates between its old and new value when it changes. You define what property to watch, how long the transition should take, and optionally which easing function to use (ease, linear, ease-in-out, etc.). The trigger is usually a :hover state or a JavaScript class change.

Animations are more powerful — you define keyframes that describe the property values at each stage of the animation. An animation can loop indefinitely, play in reverse, pause, and much more. The animation shorthand property connects the element to its named keyframes and sets the duration, easing, delay, and repeat count.',
'/* CSS Animations and Transitions */

/* ── 1. Transitions — smooth state changes ───── */
.btn {
  background: #6c63ff;
  color: white;
  padding: 12px 24px;
  border-radius: 8px;
  border: none;
  cursor: pointer;

  /* Watch these properties and animate them over 0.3s */
  transition: background 0.3s ease,
              transform  0.2s ease,
              box-shadow 0.3s ease;
}

.btn:hover {
  background: #5855d6;               /* smoothly changes colour */
  transform:  translateY(-2px);      /* smoothly lifts up */
  box-shadow: 0 8px 20px rgba(108,99,255,0.4);   /* shadow appears */
}

.btn:active {
  transform: translateY(0);          /* snaps back down on click */
}


/* ── 2. Card hover effect ────────────────────── */
.card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.card:hover {
  transform:  translateY(-6px);
  box-shadow: 0 16px 40px rgba(0,0,0,0.15);
}


/* ── 3. @keyframes animations ────────────────── */
/* Define the animation steps — 0% is start, 100% is end */
@keyframes fadeIn {
  0%   { opacity: 0; transform: translateY(20px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes pulse {
  0%   { transform: scale(1); }
  50%  { transform: scale(1.05); }
  100% { transform: scale(1); }
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}


/* ── 4. Applying animations ──────────────────── */
.hero-title {
  animation: fadeIn 0.8s ease forwards;   /* play once, keep final state */
}

.loading-dot {
  animation: pulse 1.2s ease-in-out infinite;   /* loop forever */
}

.spinner {
  width: 40px; height: 40px;
  border: 4px solid rgba(108,99,255,0.2);
  border-top-color: #6c63ff;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}


/* ── 5. Staggered entrance animations ───────────*/
.card:nth-child(1) { animation: fadeIn 0.5s ease 0.1s both; }
.card:nth-child(2) { animation: fadeIn 0.5s ease 0.2s both; }
.card:nth-child(3) { animation: fadeIn 0.5s ease 0.3s both; }
/* Each card appears 0.1s after the previous one — elegant stagger effect */',
'html', 7, 15),


(5, 'CSS Variables — Reusable Design Tokens',
'If you have ever needed to change a brand colour and found yourself searching through hundreds of CSS lines to update the same hex value in 50 places, CSS variables solve that problem. Define a value once, give it a name, use it everywhere — change it once and everything updates.

CSS variables (officially called custom properties) are declared with a -- prefix and accessed with the var() function. They are most commonly defined on the :root selector, which makes them available to every element on the page. Unlike variables in preprocessors like Sass, CSS variables are live — they can be changed at runtime with JavaScript, which makes them perfect for theming.

The most common use case is a complete light/dark theme switch. You define two sets of colour variables, one for each theme, and toggle a class or attribute on the html element. Every component that uses var(--color-bg) automatically updates — no JavaScript touching individual elements.',
'/* CSS Variables — Reusable Design Tokens */

/* ── 1. Define variables on :root ─────────────── */
:root {
  /* Brand colours */
  --color-primary:    #6c63ff;
  --color-primary-dark: #5855d6;
  --color-accent:     #43e97b;

  /* Backgrounds */
  --color-bg:         #0d0d1a;
  --color-bg-card:    #1a1a2e;
  --color-border:     rgba(255,255,255,0.08);

  /* Text */
  --color-text:       #e8e8f0;
  --color-text-muted: #8b8ba7;

  /* Spacing scale */
  --space-xs:  4px;
  --space-sm:  8px;
  --space-md:  16px;
  --space-lg:  32px;
  --space-xl:  64px;

  /* Typography */
  --font-body:    "Inter", system-ui, sans-serif;
  --font-mono:    "Fira Code", "Consolas", monospace;
  --radius-sm:    6px;
  --radius-md:    12px;
  --radius-lg:    20px;

  /* Shadows */
  --shadow-sm:    0 2px 8px rgba(0,0,0,0.2);
  --shadow-lg:    0 16px 48px rgba(0,0,0,0.4);
}


/* ── 2. Use variables with var() ──────────────── */
body {
  background: var(--color-bg);
  color:      var(--color-text);
  font-family: var(--font-body);
}

.card {
  background:    var(--color-bg-card);
  border:        1px solid var(--color-border);
  border-radius: var(--radius-md);
  padding:       var(--space-lg);
  box-shadow:    var(--shadow-sm);
}

.btn-primary {
  background:    var(--color-primary);
  border-radius: var(--radius-sm);
  padding:       var(--space-sm) var(--space-md);
  transition:    background 0.2s;
}
.btn-primary:hover {
  background: var(--color-primary-dark);
}


/* ── 3. Light theme — override with class ──────── */
.theme-light {
  --color-bg:         #ffffff;
  --color-bg-card:    #f8f9fa;
  --color-border:     rgba(0,0,0,0.1);
  --color-text:       #1a1a2e;
  --color-text-muted: #6b6b8a;
}
/* Apply class to <html> element with JS: document.documentElement.classList.toggle("theme-light") */


/* ── 4. Component-level variable override ─────── */
.btn-danger {
  /* Override just for this component without a new class */
  --color-primary: #e74c3c;
  background: var(--color-primary);
}',
'html', 8, 15),


(5, 'CSS Pseudo-classes and Advanced Selectors',
'You already know how to target elements by tag name, class, and ID. CSS has a much richer selector system that lets you target elements based on their position, their state, or their relationship to other elements — all without adding extra classes to your HTML.

Pseudo-classes describe a state or position of an element. :hover applies when the mouse is over something. :focus applies when a form field is active. :nth-child(n) lets you target elements by their position — :nth-child(2n) selects every even element, :nth-child(3n+1) every third starting from the first. :not() is especially powerful: it excludes elements that match its argument.

Pseudo-elements let you insert styled content before or after an element using ::before and ::after. No extra HTML needed — the content exists only in CSS. This is how developers add decorative arrows, custom bullet points, quote marks, and underline effects without polluting their HTML with non-semantic elements.',
'/* CSS Pseudo-classes and Advanced Selectors */


/* ── 1. State pseudo-classes ─────────────────── */
a:link    { color: #6c63ff; }     /* unvisited link */
a:visited { color: #9b8cff; }     /* visited link */
a:hover   { color: #a78bfa; text-decoration: underline; }
a:active  { color: #ff6b6b; }     /* while being clicked */

input:focus {
  outline: 2px solid #6c63ff;     /* highlight focused input */
  border-color: #6c63ff;
}

button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}


/* ── 2. Child pseudo-classes ─────────────────── */
li:first-child { font-weight: bold; }   /* first item in any list */
li:last-child  { border-bottom: none; } /* no border on last item */

/* Every other table row — stripe pattern */
tr:nth-child(even) { background: rgba(255,255,255,0.03); }

/* First three items only */
.card:nth-child(-n+3) { border-top: 3px solid #6c63ff; }

/* All EXCEPT the first */
p:not(:first-child) { margin-top: 1rem; }


/* ── 3. ::before and ::after pseudo-elements ─── */
/* Add a decorative arrow before each nav link */
.nav-link::before {
  content: "→ ";           /* the injected text */
  color: #6c63ff;
  font-weight: bold;
}

/* Add a gradient underline effect — no extra HTML needed */
.fancy-link {
  position: relative;
  text-decoration: none;
}
.fancy-link::after {
  content: "";
  position: absolute;
  bottom: -2px; left: 0;
  width: 0; height: 2px;
  background: linear-gradient(90deg, #6c63ff, #43e97b);
  transition: width 0.3s ease;
}
.fancy-link:hover::after {
  width: 100%;              /* underline grows on hover */
}


/* ── 4. Attribute selectors ──────────────────── */
input[type="email"]   { border-color: #43e97b; }
input[type="password"]{ border-color: #ff6b6b; }
a[href^="https"]      { padding-left: 18px; }   /* links starting with https */
a[href$=".pdf"]::after { content: " 📄"; }       /* links ending in .pdf */',
'html', 9, 15),


(5, 'Building a Complete Responsive Page',
'Everything you have learned — HTML structure, CSS selectors, Flexbox, Grid, variables, animations — comes together when you build a real page. A professional web page is not just a collection of elements; it is a system where each piece has a purpose and works together to create a clear, comfortable experience for the user on any device.

Mobile-first design means you write your base CSS for small screens first, then add media queries to enhance the layout for larger screens. This is the opposite of what many beginners do (design for desktop, then try to squeeze it onto mobile). Mobile-first gives you a simpler base and a cleaner upgrade path.

The most important responsive breakpoints to know: 640px for large phones, 768px for tablets, 1024px for laptops, 1280px for desktop. You do not need to target every possible screen size — a well-built Flexbox or Grid layout with auto-fit and minmax columns handles most cases automatically without any media queries at all.',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Complete Responsive Page</title>
  <style>

    /* ── CSS Variables ───────────────────────────── */
    :root {
      --bg:      #0d0d1a;
      --card:    #1a1a2e;
      --accent:  #6c63ff;
      --text:    #e8e8f0;
      --muted:   #8b8ba7;
      --border:  rgba(255,255,255,0.08);
      --radius:  12px;
    }

    /* ── Reset & Base ────────────────────────────── */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: system-ui, sans-serif; background: var(--bg); color: var(--text); }

    /* ── Navigation ──────────────────────────────── */
    nav {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 2rem;
      height: 64px;
      border-bottom: 1px solid var(--border);
      position: sticky; top: 0;
      background: var(--bg);
      z-index: 100;
    }
    .brand { font-size: 1.4rem; font-weight: 800; color: var(--accent); }
    .nav-links { display: flex; gap: 2rem; list-style: none; }
    .nav-links a { color: var(--muted); text-decoration: none; transition: color 0.2s; }
    .nav-links a:hover { color: var(--text); }

    /* ── Hero Section ────────────────────────────── */
    .hero {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      text-align: center;
      padding: 5rem 2rem;
      gap: 1.5rem;
    }
    .hero h1 { font-size: clamp(2rem, 5vw, 4rem); font-weight: 900; }
    .hero p  { color: var(--muted); max-width: 600px; font-size: 1.1rem; line-height: 1.7; }

    /* ── Card Grid — auto-responsive ────────────── */
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 1.5rem;
      padding: 2rem;
      max-width: 1200px;
      margin: 0 auto;
    }
    .card {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      padding: 1.75rem;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 32px rgba(108,99,255,0.2);
    }
    .card h3 { color: var(--accent); margin-bottom: 0.75rem; }
    .card p  { color: var(--muted); font-size: 0.9rem; line-height: 1.6; }

    /* ── Media query — hide nav links on mobile ──── */
    @media (max-width: 768px) {
      .nav-links { display: none; }
    }

  </style>
</head>
<body>

  <nav>
    <span class="brand">Coder.</span>
    <ul class="nav-links">
      <li><a href="#">Courses</a></li>
      <li><a href="#">Roadmap</a></li>
      <li><a href="#">Compiler</a></li>
    </ul>
  </nav>

  <section class="hero">
    <h1>Learn to Code.<br />Build Your Future.</h1>
    <p>High-quality lessons in Python, JavaScript, Java, C++, HTML/CSS, SQL and more.</p>
  </section>

  <main class="grid">
    <div class="card"><h3>Python</h3><p>Start with the most beginner-friendly language. Build real programs from day one.</p></div>
    <div class="card"><h3>JavaScript</h3><p>Make web pages interactive. The language of the browser — and now the server.</p></div>
    <div class="card"><h3>HTML & CSS</h3><p>Structure and style. Every website ever built started here.</p></div>
  </main>

</body>
</html>',
'html', 10, 15),


-- ═══════════════════════════════════════════════════════════
--  SQL  — lessons 6 to 10  (course_id = 6)
-- ═══════════════════════════════════════════════════════════

(6, 'Subqueries — Queries Inside Queries',
'A subquery is a SELECT statement nested inside another SQL statement. The inner query runs first, produces a result, and the outer query uses that result as if it were a table or a value. Subqueries let you solve problems in one statement that would otherwise require two separate queries and manual copying of results.

Subqueries can appear in different places: in the WHERE clause as a filter value, in the FROM clause as a temporary table (called a derived table or inline view), or in the SELECT clause to compute a value for each row. When a subquery returns a single value, you can compare it with = or >. When it returns multiple values, use IN or EXISTS.

The EXISTS operator is especially efficient — it stops as soon as it finds one matching row and returns true. Use EXISTS instead of IN when checking membership in a large table, as it is often much faster. Subqueries make SQL remarkably expressive — almost any complex data question can be answered with the right combination of JOINs and subqueries.',
'-- Subqueries in SQL
-- ────────────────────────────────────────────────

-- ── Subquery in WHERE — single value ──────────────
-- Find all lessons with XP higher than the average

SELECT title, xp_reward
FROM lessons
WHERE xp_reward > (SELECT AVG(xp_reward) FROM lessons);
-- The inner query runs first: computes AVG → e.g. 12.5
-- The outer query uses that: WHERE xp_reward > 12.5


-- ── Subquery in WHERE — multiple values (IN) ──────
-- Find all lessons that belong to beginner-level courses

SELECT l.title, l.language
FROM lessons l
WHERE l.course_id IN (
    SELECT id FROM courses WHERE level = ''Beginner''
);


-- ── EXISTS — stop as soon as one match is found ───
-- Find users who have completed at least one lesson

SELECT username
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM user_progress up
    WHERE up.user_id = u.id   -- correlated: links outer and inner query
);


-- ── NOT EXISTS — users who have NOT completed any lesson ──
SELECT username
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM user_progress up WHERE up.user_id = u.id
);


-- ── Subquery in FROM — derived table ──────────────
-- First compute totals per user, then filter the summary

SELECT username, total_xp, lessons_done
FROM (
    SELECT
        u.username,
        COALESCE(SUM(l.xp_reward), 0) AS total_xp,
        COUNT(up.lesson_id)            AS lessons_done
    FROM users u
    LEFT JOIN user_progress up ON up.user_id = u.id
    LEFT JOIN lessons l        ON l.id = up.lesson_id
    GROUP BY u.id, u.username
) AS user_summary                        -- derived tables must have an alias
WHERE total_xp > 100
ORDER BY total_xp DESC;',
'sql', 6, 15),


(6, 'String and Date Functions',
'SQL is not just for filtering and counting — it has a rich library of functions for transforming data. String functions let you manipulate text: extract parts of it, search within it, convert its case, measure its length, and replace characters. Date functions let you calculate time differences, extract parts of a date (year, month, day), and format dates for display.

These functions are especially useful in reports. Instead of pulling raw data and formatting it in your application code, you can let the database do the work. This reduces the amount of data transferred over the network and keeps your transformation logic in one place.

One important caveat: date and string function names vary slightly between database systems. MySQL uses CONCAT(), SQLite uses ||, SQL Server uses +. The functions shown here are MySQL/MariaDB syntax — what your Coder platform runs on.',
'-- String and Date Functions (MySQL syntax)
-- ────────────────────────────────────────────────

-- ── String Functions ──────────────────────────────

-- UPPER / LOWER — change case
SELECT UPPER(username), LOWER(email) FROM users;

-- LENGTH — number of characters
SELECT username, LENGTH(username) AS name_length FROM users ORDER BY name_length DESC;

-- CONCAT — join strings together
SELECT CONCAT(username, '' ('', email, '')'') AS display FROM users;

-- SUBSTRING — extract part of a string
-- SUBSTRING(string, start_position, length)
SELECT SUBSTRING(email, 1, 5) AS first5 FROM users;   -- first 5 chars of email

-- TRIM — remove leading/trailing spaces
SELECT TRIM(''   hello world   '');   -- result: ''hello world''

-- REPLACE — swap one string for another
SELECT REPLACE(email, ''@gmail.com'', ''@coder.com'') AS new_email FROM users;

-- INSTR — position of a substring (0 if not found)
SELECT email, INSTR(email, ''@'') AS at_position FROM users;

-- LEFT / RIGHT — take characters from start or end
SELECT LEFT(email, INSTR(email, ''@'') - 1) AS username_part FROM users;


-- ── Date Functions ────────────────────────────────

-- NOW() — current date and time
-- CURDATE() — current date only
-- CURTIME() — current time only
SELECT NOW(), CURDATE(), CURTIME();

-- YEAR / MONTH / DAY — extract parts
SELECT
    completed_at,
    YEAR(completed_at)  AS year_completed,
    MONTH(completed_at) AS month_completed,
    DAY(completed_at)   AS day_completed
FROM user_progress;

-- DATEDIFF — number of days between two dates
SELECT
    username,
    DATEDIFF(NOW(), created_at) AS days_since_joined
FROM users
ORDER BY days_since_joined;

-- DATE_FORMAT — format a date for display
SELECT DATE_FORMAT(completed_at, ''%D %M %Y'') AS formatted
FROM user_progress;
-- Result: "15th June 2026"

-- TIMESTAMPDIFF — difference in specific units
SELECT TIMESTAMPDIFF(HOUR, created_at, NOW()) AS hours_ago FROM user_progress;',
'sql', 7, 15),


(6, 'Transactions — Keeping Data Safe',
'A transaction is a group of SQL statements that must ALL succeed or ALL fail together. Without transactions, a crash halfway through a multi-step operation can leave your database in an inconsistent state — money transferred out of one account but never received in the other.

Transactions follow the ACID properties: Atomic (all or nothing), Consistent (data stays valid), Isolated (concurrent transactions do not interfere), Durable (committed changes survive crashes). These four properties are what make relational databases trustworthy for financial, medical, and any other critical data.

You start a transaction with START TRANSACTION (or BEGIN), then either COMMIT to save all the changes permanently, or ROLLBACK to undo everything back to the state before the transaction started. By default, MySQL runs in auto-commit mode, where each statement is its own transaction. Explicit transactions let you group multiple statements into one atomic unit.',
'-- Transactions in MySQL
-- ────────────────────────────────────────────────

-- ── The Problem Without Transactions ─────────────
-- Imagine transferring 100 XP from user 1 to user 2.
-- Two UPDATE statements are needed. What if the server crashes between them?

-- UPDATE users SET xp = xp - 100 WHERE id = 1;   -- runs
-- <-- SERVER CRASHES HERE -->
-- UPDATE users SET xp = xp + 100 WHERE id = 2;   -- never runs!
-- Result: 100 XP vanished from the database!


-- ── The Safe Way: Use a Transaction ──────────────

START TRANSACTION;   -- begin the transaction

UPDATE users SET xp = xp - 100 WHERE id = 1;
UPDATE users SET xp = xp + 100 WHERE id = 2;

-- If both updates succeeded, make them permanent
COMMIT;

-- If anything went wrong, this undoes EVERYTHING since START TRANSACTION
-- ROLLBACK;


-- ── Transaction with error checking ───────────────
-- In a stored procedure or application code you would do this:
-- (shown as comments since we can''t use IF in plain SQL here)

-- START TRANSACTION;
--
-- UPDATE users SET xp = xp - 100 WHERE id = 1;
-- -- Check: did the user have enough XP?
-- IF (SELECT xp FROM users WHERE id = 1) < 0 THEN
--     ROLLBACK;     -- undo everything — user did not have enough XP
-- ELSE
--     UPDATE users SET xp = xp + 100 WHERE id = 2;
--     COMMIT;       -- all good, save it
-- END IF;


-- ── SAVEPOINT — partial rollback ──────────────────
-- You can set checkpoints within a transaction

START TRANSACTION;

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward)
VALUES (1, ''Test lesson'', ''test'', ''print("test")'', ''python'', 99, 5);

SAVEPOINT after_insert;   -- mark this point

UPDATE courses SET lessons = lessons + 1 WHERE id = 1;

-- Undo only back to the savepoint (keeps the INSERT)
ROLLBACK TO SAVEPOINT after_insert;

-- Now commit just the INSERT
COMMIT;

-- Clean up test data
DELETE FROM lessons WHERE order_num = 99 AND course_id = 1;
UPDATE courses SET lessons = lessons - 1 WHERE id = 1;',
'sql', 8, 15),


(6, 'Views — Saved Queries You Can Query Again',
'A view is a saved SELECT query that you can treat as if it were a table. Every time you query a view, the database runs the underlying SELECT and returns the result. You can filter, join, and aggregate from a view just like from a real table — other people using the database do not need to know or write the complex SQL themselves.

Views serve two main purposes. First, they simplify complexity: a ten-line JOIN query with aggregations becomes a simple SELECT * FROM monthly_summary. Second, they provide a security layer: you can grant a user access to a view while keeping the underlying tables hidden. A finance team can see a revenue_by_product view without having access to the raw orders and pricing tables.

Views do not store data (in MySQL, by default). They are just stored SQL. This means they always show current data — unlike exporting to a spreadsheet, a view is never stale. The database recalculates the view every time you query it.',
'-- Views in SQL
-- ────────────────────────────────────────────────

-- ── Create a simple view ──────────────────────────
CREATE VIEW beginner_courses AS
SELECT id, title, language, duration, lessons
FROM courses
WHERE level = ''Beginner'';

-- Now query it just like a table
SELECT * FROM beginner_courses;
SELECT title FROM beginner_courses WHERE language = ''python'';


-- ── Drop a view ───────────────────────────────────
DROP VIEW IF EXISTS beginner_courses;


-- ── A more useful view: leaderboard ───────────────
CREATE OR REPLACE VIEW leaderboard_view AS
SELECT
    u.id,
    u.username,
    COALESCE(SUM(l.xp_reward), 0)  AS total_xp,
    COUNT(up.lesson_id)             AS lessons_done,
    COUNT(DISTINCT l.course_id)     AS courses_started
FROM users u
LEFT JOIN user_progress up ON up.user_id  = u.id
LEFT JOIN lessons l        ON l.id        = up.lesson_id
GROUP BY u.id, u.username
ORDER BY total_xp DESC;

-- Anyone can now query the leaderboard without knowing the JOIN logic
SELECT * FROM leaderboard_view LIMIT 10;
SELECT * FROM leaderboard_view WHERE lessons_done >= 5;


-- ── A view for course progress summary ────────────
CREATE OR REPLACE VIEW course_lesson_counts AS
SELECT
    c.id,
    c.title,
    c.language,
    c.level,
    COUNT(l.id) AS actual_lesson_count
FROM courses c
LEFT JOIN lessons l ON l.course_id = c.id
GROUP BY c.id, c.title, c.language, c.level;

SELECT * FROM course_lesson_counts ORDER BY actual_lesson_count DESC;


-- ── Updatable views ───────────────────────────────
-- Simple views (no GROUP BY, no JOIN, no DISTINCT) can be updated
-- The update goes through to the underlying table

CREATE OR REPLACE VIEW active_users AS
SELECT id, username, email, xp FROM users WHERE xp > 0;

-- This updates the actual users table through the view
UPDATE active_users SET xp = xp + 10 WHERE id = 1;',
'sql', 9, 15),


(6, 'Indexes — Making Queries Fast',
'An index is a data structure that makes certain queries dramatically faster — at the cost of a little extra storage and slightly slower writes. Without an index, a query like WHERE email = ''x'' forces MySQL to check every single row in the table one by one. With an index on the email column, MySQL jumps directly to the matching row like looking up a word in a book''s index instead of reading every page.

Primary keys are automatically indexed. For other columns you query frequently — especially those in WHERE clauses, JOIN conditions, and ORDER BY clauses — you should consider adding an index. The most important columns to index are foreign keys (which you join on constantly) and unique identifiers like email or username.

But indexes are not free. Each index takes disk space and slows down INSERT, UPDATE, and DELETE operations because the index has to be updated along with the data. On a table you read much more often than you write (like a courses table), indexes are pure win. On a table with very frequent writes (like a log table), too many indexes can actually hurt performance.',
'-- Indexes in SQL
-- ────────────────────────────────────────────────

-- ── See existing indexes on a table ───────────────
SHOW INDEX FROM lessons;
SHOW INDEX FROM users;
-- Primary keys and UNIQUE constraints already have indexes automatically


-- ── Create a basic index ──────────────────────────
-- Speeds up: WHERE language = ''python''
CREATE INDEX idx_lessons_language ON lessons (language);

-- Speeds up: WHERE course_id = 1 ORDER BY order_num
CREATE INDEX idx_lessons_course_order ON lessons (course_id, order_num);
-- A multi-column (composite) index — order matters!
-- Helps queries that filter by course_id, or by course_id AND order_num
-- Does NOT help queries that filter by order_num alone


-- ── Unique index — prevents duplicates ────────────
-- This also makes lookups fast AND enforces uniqueness
CREATE UNIQUE INDEX idx_users_email ON users (email);
-- If a UNIQUE constraint already exists on this column, you might get an error


-- ── Drop an index ─────────────────────────────────
DROP INDEX idx_lessons_language ON lessons;


-- ── EXPLAIN — see how MySQL executes a query ─────
-- Run this BEFORE and AFTER adding an index to compare
EXPLAIN SELECT * FROM lessons WHERE language = ''python'';
-- Look at the "type" column:
--   "ALL"  = full table scan (slow — reads every row)
--   "ref"  = using an index (fast)
--   "const"= using a unique index (fastest)

EXPLAIN SELECT l.title FROM lessons l
JOIN courses c ON l.course_id = c.id
WHERE c.level = ''Beginner'';


-- ── When TO add an index ──────────────────────────
-- ✓ Columns in WHERE clauses you use often
-- ✓ Foreign key columns (user_id, course_id, lesson_id)
-- ✓ Columns you ORDER BY or GROUP BY frequently
-- ✓ Columns with high cardinality (many unique values)

-- ── When NOT TO add an index ──────────────────────
-- ✗ Very small tables (full scan is fine, index overhead not worth it)
-- ✗ Columns rarely used in queries
-- ✗ Tables with extremely frequent writes
-- ✗ Boolean columns (only 2 values — low cardinality, index barely helps)',
'sql', 10, 15);


-- ═══════════════════════════════════════════════════════════
--  TYPESCRIPT  (new course — uses whatever id MySQL assigns)
--  We use a variable to capture the new id safely.
-- ═══════════════════════════════════════════════════════════

SET @ts_id = (SELECT id FROM courses WHERE language = 'typescript' LIMIT 1);

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@ts_id, 'What is TypeScript? Basic Types',
'JavaScript is great, but it has a problem: a variable can hold any type at any time. A function expecting a number might receive a string. The bug only appears at runtime — sometimes in production, when real users hit it. TypeScript solves this by adding a type system on top of JavaScript. You annotate your code with types, and TypeScript checks them at compile time — before the code ever runs.

TypeScript is a superset of JavaScript, which means every valid JavaScript file is also a valid TypeScript file. You add types gradually. TypeScript compiles down to regular JavaScript that runs in any browser or Node.js environment — the types disappear at runtime, so there is zero performance cost.

The basic types are: string, number, boolean, null, undefined, and any (which opts out of type checking — use sparingly). You can also define arrays (number[]), tuples ([string, number]), and union types (string | number) that accept multiple types.',
'// TypeScript — Basic Types
// ─────────────────────────────
// TypeScript adds type annotations after a colon

// ── Primitive types ────────────────────────────
let username: string  = "Ahmed";
let age:      number  = 20;
let isActive: boolean = true;

// username = 42;   // ERROR: Type ''number'' is not assignable to ''string''


// ── Arrays ─────────────────────────────────────
let scores:    number[]  = [85, 92, 78];
let languages: string[]  = ["Python", "JavaScript", "Java"];

scores.push(95);
// scores.push("hello");  // ERROR: Argument of type ''string'' is not assignable


// ── Tuple — fixed-length array with known types ─
let person: [string, number] = ["Ahmed", 20];
// person[0] is always string, person[1] is always number


// ── Union types — accept multiple types ─────────
let id: string | number;
id = "user_123";   // OK
id = 456;          // OK
// id = true;      // ERROR


// ── Type inference — TypeScript figures it out ──
let city = "Dubai";    // TypeScript infers: string
// city = 100;         // ERROR — already inferred as string


// ── any — escape hatch (avoid when possible) ────
let data: any = "hello";
data = 42;       // no error — any accepts everything
data = true;     // no error — but you lose all type safety


// ── Type aliases — name your own types ──────────
type UserID = string | number;
type Point  = { x: number; y: number };

let userId: UserID = "u_001";
let center: Point  = { x: 0, y: 0 };

console.log(username, age, isActive);
console.log(scores, languages);
console.log(userId, center);',
'typescript', 1, 15),


(@ts_id, 'Functions and Type Annotations',
'Functions are where TypeScript''s type system shines brightest. In plain JavaScript, a function can receive any argument and return any value — there is no documentation in the code about what it expects or produces. TypeScript lets you annotate every parameter and the return type, turning the function signature into a contract that both the caller and the implementation must follow.

If a function returns nothing, its return type is void. If a function can never return (it always throws or runs forever), its return type is never. TypeScript will warn you if your function says it returns a number but has a code path that returns undefined.

Optional parameters have a ? after their name. They may or may not be provided by the caller. Default parameters work exactly like JavaScript, but TypeScript still infers their type from the default value. Rest parameters (...args) collect extra arguments into a typed array.',
'// TypeScript — Function Type Annotations
// ─────────────────────────────────────────

// ── Basic annotated function ────────────────────
// Parameters: name is string, age is number
// Return type after the closing parenthesis: string
function greet(name: string, age: number): string {
    return `Hello, ${name}! You are ${age} years old.`;
}

console.log(greet("Ahmed", 20));
// greet("Ahmed", "twenty");   // ERROR: ''string'' is not assignable to ''number''


// ── void return type — function returns nothing ──
function logMessage(message: string): void {
    console.log(`[LOG] ${message}`);
    // no return statement needed
}


// ── Optional parameter with ? ────────────────────
function buildURL(base: string, path?: string): string {
    return path ? `${base}/${path}` : base;
}

console.log(buildURL("https://coder.app"));           // https://coder.app
console.log(buildURL("https://coder.app", "courses")); // https://coder.app/courses


// ── Default parameter ────────────────────────────
function createUser(name: string, role: string = "student"): string {
    return `${name} joined as ${role}`;
}

console.log(createUser("Ahmed"));          // Ahmed joined as student
console.log(createUser("Sara", "admin"));  // Sara joined as admin


// ── Arrow function with types ────────────────────
const multiply = (a: number, b: number): number => a * b;
console.log(multiply(6, 7));   // 42


// ── Function type as a variable type ────────────
type MathOp = (a: number, b: number) => number;

const add:      MathOp = (a, b) => a + b;
const subtract: MathOp = (a, b) => a - b;

function calculate(x: number, y: number, operation: MathOp): number {
    return operation(x, y);
}

console.log(calculate(10, 3, add));       // 13
console.log(calculate(10, 3, subtract));  // 7',
'typescript', 2, 15),


(@ts_id, 'Interfaces — Describing Object Shapes',
'In JavaScript, objects can have any shape — any keys, any values. TypeScript lets you define exactly what shape an object must have using an interface. An interface is like a contract: any object claiming to implement it must have all the required properties with the correct types.

Interfaces are purely a TypeScript concept — they completely disappear after compilation. They exist only to help you during development by catching mistakes early. If you try to pass an object missing a required field, TypeScript catches it immediately with a red underline, before you ever run the code.

Interfaces can extend other interfaces, inheriting all their fields and adding new ones. This is similar to class inheritance but for object shapes. You can also mark properties as optional with ? or readonly to prevent accidental modification after creation.',
'// TypeScript — Interfaces
// ─────────────────────────────

// ── Define an interface ─────────────────────────
interface User {
    id:        number;
    username:  string;
    email:     string;
    xp:        number;
    role?:     string;   // ? = optional — may or may not be present
}

// ── Using the interface ─────────────────────────
const ahmed: User = {
    id:       1,
    username: "ahmed",
    email:    "ahmed@email.com",
    xp:       1500,
    role:     "admin"    // optional, but valid
};

const sara: User = {
    id:       2,
    username: "sara",
    email:    "sara@email.com",
    xp:       800
    // role is omitted — that is fine since it is optional
};

// Forgot ''xp''? TypeScript catches it:
// const bad: User = { id: 3, username: "x", email: "x@x.com" };
// ERROR: Property ''xp'' is missing in type ''...'' but required in type ''User''


// ── Function that accepts an interface ──────────
function displayUser(user: User): string {
    return `${user.username} — Level ${Math.floor(user.xp / 100) + 1}`;
}

console.log(displayUser(ahmed));   // ahmed — Level 16
console.log(displayUser(sara));    // sara — Level 9


// ── Interface extending another interface ────────
interface Admin extends User {
    permissions: string[];
    canDeleteUsers: boolean;
}

const superAdmin: Admin = {
    id:             0,
    username:       "superadmin",
    email:          "admin@coder.app",
    xp:             9999,
    permissions:    ["read", "write", "delete"],
    canDeleteUsers: true
};


// ── readonly — prevent modification after creation ──
interface Point {
    readonly x: number;
    readonly y: number;
}

const origin: Point = { x: 0, y: 0 };
// origin.x = 10;   // ERROR: Cannot assign to ''x'' because it is a read-only property


// ── Interface for a function ─────────────────────
interface Formatter {
    (value: string): string;
}

const toUpper:   Formatter = (s) => s.toUpperCase();
const addPrefix: Formatter = (s) => ">> " + s;

console.log(toUpper("hello"));    // HELLO
console.log(addPrefix("world"));  // >> world',
'typescript', 3, 15),


(@ts_id, 'Classes in TypeScript',
'TypeScript extends JavaScript classes with access modifiers (public, private, protected), parameter properties, and abstract classes. These features make large object-oriented codebases much safer and easier to understand.

The public keyword makes a member accessible from anywhere — it is the default. private restricts access to within the class only. protected allows access within the class and its subclasses. By prefixing constructor parameters with these keywords, TypeScript automatically creates and assigns the corresponding properties — a shortcut that removes a lot of boilerplate.

TypeScript classes can implement interfaces, which forces them to provide specific methods. This is powerful for defining a common API that multiple classes must follow — you can then write code that works with the interface type rather than any specific class.',
'// Classes in TypeScript
// ─────────────────────────────

// ── Access modifiers ────────────────────────────
class Student {
    // public = accessible from anywhere (default)
    // private = only accessible inside this class
    // readonly = can be set once, never changed
    readonly id:      number;
    public  username: string;
    private password: string;
    protected xp:     number;

    // Shorthand: prefixing constructor params creates + assigns the properties
    constructor(id: number, username: string, password: string) {
        this.id       = id;
        this.username = username;
        this.password = password;
        this.xp       = 0;
    }

    completeLesson(xpReward: number): void {
        this.xp += xpReward;
        console.log(`${this.username} earned ${xpReward} XP!`);
    }

    getXP(): number { return this.xp; }

    // Private method — internal use only
    private hashPassword(pw: string): string {
        return "*".repeat(pw.length);   // simplified "hashing"
    }
}

const ahmed = new Student(1, "ahmed", "secret123");
ahmed.completeLesson(15);
console.log(ahmed.username);   // ahmed — public, accessible
console.log(ahmed.getXP());    // 15
// console.log(ahmed.password);// ERROR — private


// ── Implementing an interface ────────────────────
interface Describable {
    describe(): string;
}

class Course implements Describable {
    constructor(
        public title: string,
        public language: string,
        private lessons: number
    ) {}

    describe(): string {
        return `${this.title} — ${this.lessons} lessons`;
    }
}

const py = new Course("Python", "python", 10);
console.log(py.describe());   // Python — 10 lessons


// ── Abstract class — cannot be instantiated directly ──
abstract class Shape {
    abstract area(): number;   // must be implemented by subclasses

    describe(): string {
        return `Shape with area ${this.area().toFixed(2)}`;
    }
}

class Circle extends Shape {
    constructor(private radius: number) { super(); }
    area(): number { return Math.PI * this.radius ** 2; }
}

class Rectangle extends Shape {
    constructor(private w: number, private h: number) { super(); }
    area(): number { return this.w * this.h; }
}

const shapes: Shape[] = [new Circle(5), new Rectangle(4, 6)];
shapes.forEach(s => console.log(s.describe()));',
'typescript', 4, 15),


(@ts_id, 'Generics — Reusable Type-Safe Code',
'Generics are one of the most powerful features in TypeScript. They let you write code that works with multiple types while still being type-safe. Instead of using any (which loses all type information), generics use a placeholder type parameter — usually written as T — that gets filled in when the function or class is actually used.

Think of generics like a template. A generic function getFirst<T>(arr: T[]): T says "I accept an array of any type T, and I return one item of that same type T." When you call getFirst(["a", "b"]), TypeScript infers T is string and knows the return value is a string. When you call getFirst([1, 2, 3]), T is number. One function, many types, full type safety.

Generic constraints let you require that the type parameter has certain properties. Using extends, you can say "T must have at least these fields." This lets you write generic code that safely accesses specific properties without losing the flexibility of generics.',
'// TypeScript — Generics
// ─────────────────────────────

// ── Generic function ────────────────────────────
// T is a placeholder — it becomes the actual type when called
function getFirst<T>(arr: T[]): T | undefined {
    return arr.length > 0 ? arr[0] : undefined;
}

const firstNum  = getFirst([1, 2, 3]);          // TypeScript knows: number
const firstStr  = getFirst(["a", "b", "c"]);    // TypeScript knows: string
console.log(firstNum, firstStr);   // 1  "a"


// ── Generic function with multiple type params ───
function pair<T, U>(first: T, second: U): [T, U] {
    return [first, second];
}

const result = pair("Ahmed", 20);   // [string, number]
console.log(result);   // ["Ahmed", 20]


// ── Generic class ───────────────────────────────
class Stack<T> {
    private items: T[] = [];

    push(item: T): void   { this.items.push(item); }
    pop():  T | undefined { return this.items.pop(); }
    peek(): T | undefined { return this.items[this.items.length - 1]; }
    size(): number        { return this.items.length; }
}

const numStack = new Stack<number>();
numStack.push(1);
numStack.push(2);
numStack.push(3);
console.log(numStack.pop());   // 3
console.log(numStack.peek());  // 2
// numStack.push("hello");     // ERROR — Stack<number> only accepts numbers

const strStack = new Stack<string>();
strStack.push("hello");
strStack.push("world");


// ── Generic constraints — T must have .length ───
function printLength<T extends { length: number }>(item: T): void {
    console.log(`Length: ${item.length}`);
}

printLength("hello");          // Length: 5
printLength([1, 2, 3, 4]);    // Length: 4
// printLength(42);            // ERROR — number has no .length


// ── Practical: typed API response wrapper ────────
interface ApiResponse<T> {
    data:    T;
    status:  number;
    message: string;
}

interface Course {
    id: number;
    title: string;
    language: string;
}

const response: ApiResponse<Course[]> = {
    data:    [{ id: 1, title: "Python", language: "python" }],
    status:  200,
    message: "OK"
};

console.log(response.data[0].title);   // Python',
'typescript', 5, 15);


-- ═══════════════════════════════════════════════════════════
--  REACT  (new course)
-- ═══════════════════════════════════════════════════════════

SET @react_id = (SELECT id FROM courses WHERE language = 'react' LIMIT 1);

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@react_id, 'What is React? Your First Component',
'React is a JavaScript library for building user interfaces. Created by Facebook in 2013, it is now the most widely used frontend framework in the world. React''s key insight is simple but powerful: instead of manually updating the DOM whenever data changes, you describe what the UI should look like for a given state, and React figures out the most efficient way to update the screen.

The fundamental building block of React is the component. A component is a JavaScript function that returns JSX — a syntax that looks like HTML inside JavaScript. Each component is a reusable piece of UI. A button, a form, a navigation bar, a user profile card — each of these is a component. A React application is a tree of components nested inside each other.

JSX is not actually HTML. It is syntactic sugar that React transforms into regular JavaScript function calls. The key differences: class becomes className (class is a reserved word in JS), and all tags must be closed (even self-closing ones like <input />). Every component must return a single root element — wrap multiple elements in a <div> or an empty tag (<> ... </>).',
'// React — Your First Component
// ─────────────────────────────────────────────
// Note: React needs a build environment (Vite, Create React App).
// This code is for learning — it shows the real React syntax.

import React from "react";


// ── The simplest possible component ─────────────
// A component is just a function that returns JSX
function HelloWorld() {
    return <h1>Hello, World!</h1>;
}


// ── A component with props (inputs) ─────────────
function Greeting({ name, role }) {
    return (
        <div>
            <h2>Welcome, {name}!</h2>
            <p>You are logged in as: {role}</p>
        </div>
    );
}


// ── A reusable Card component ────────────────────
function CourseCard({ title, language, lessons, color }) {
    return (
        <div style={{
            background: "#1a1a2e",
            border: "1px solid rgba(255,255,255,0.08)",
            borderRadius: "12px",
            padding: "24px",
            borderTop: `4px solid ${color}`
        }}>
            <h3 style={{ color: color }}>{title}</h3>
            <p style={{ color: "#8b8ba7" }}>{language}</p>
            <span>{lessons} lessons</span>
        </div>
    );
}


// ── Rendering expressions with {} ────────────────
function UserStats({ username, xp }) {
    const level = Math.floor(xp / 100) + 1;

    return (
        <div>
            <h3>{username}</h3>
            <p>Level {level} — {xp} XP</p>
            <p>
                {xp >= 1000
                    ? "Pro learner!"           // if xp >= 1000
                    : "Keep going!"}           // else
            </p>
        </div>
    );
}


// ── The App component — root of everything ───────
function App() {
    return (
        <>                         {/* empty tag = "fragment" — no extra div */}
            <HelloWorld />
            <Greeting name="Ahmed" role="Student" />

            <CourseCard
                title="Python"
                language="python"
                lessons={10}
                color="#3776AB"
            />

            <UserStats username="ahmed" xp={1500} />
        </>
    );
}

export default App;',
'javascript', 1, 15),


(@react_id, 'State with useState — Making Components Interactive',
'So far, our React components are static — they always show the same output for the same props. State is what makes components interactive. State is data that belongs to a component and can change over time. When state changes, React automatically re-renders the component to show the updated UI.

The useState hook is how you add state to a function component. It takes the initial value as an argument and returns an array with two items: the current state value and a setter function. Calling the setter function with a new value tells React to re-render the component with that new value.

The golden rule: never modify state directly. Never do count = count + 1. Always use the setter function. This is how React knows to re-render. When the new state depends on the old state, use the function form of the setter: setState(prev => prev + 1).',
'// React — useState Hook
// ─────────────────────────────────────────────
import React, { useState } from "react";


// ── Counter — the classic useState example ───────
function Counter() {
    // useState(0) → initial value is 0
    // count = current value, setCount = function to update it
    const [count, setCount] = useState(0);

    return (
        <div>
            <h2>Count: {count}</h2>

            {/* Clicking the button calls setCount with the new value */}
            <button onClick={() => setCount(count + 1)}>+1</button>
            <button onClick={() => setCount(count - 1)}>-1</button>
            <button onClick={() => setCount(0)}>Reset</button>
        </div>
    );
}


// ── Text input with state ────────────────────────
function NameInput() {
    const [name, setName] = useState("");

    return (
        <div>
            {/* Update state on every keystroke */}
            <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Type your name..."
            />
            {/* Conditionally render — only show if name is not empty */}
            {name && <p>Hello, {name}!</p>}
        </div>
    );
}


// ── Toggle — boolean state ───────────────────────
function DarkModeToggle() {
    const [isDark, setIsDark] = useState(true);

    return (
        <div style={{ background: isDark ? "#0d0d1a" : "#ffffff",
                      color:      isDark ? "#e8e8f0" : "#1a1a2e",
                      padding: "20px" }}>
            <p>Current mode: {isDark ? "Dark" : "Light"}</p>
            <button onClick={() => setIsDark(prev => !prev)}>
                {/* prev => !prev is safer than isDark => !isDark */}
                Toggle Mode
            </button>
        </div>
    );
}


// ── Multiple state values ────────────────────────
function LoginForm() {
    const [email,    setEmail]    = useState("");
    const [password, setPassword] = useState("");
    const [error,    setError]    = useState("");

    function handleSubmit(e) {
        e.preventDefault();
        if (!email || !password) {
            setError("All fields are required.");
            return;
        }
        setError("");
        console.log("Logging in:", email);
    }

    return (
        <form onSubmit={handleSubmit}>
            <input value={email}    onChange={e => setEmail(e.target.value)}    placeholder="Email" />
            <input value={password} onChange={e => setPassword(e.target.value)} placeholder="Password" type="password" />
            {error && <p style={{color: "red"}}>{error}</p>}
            <button type="submit">Log In</button>
        </form>
    );
}',
'javascript', 2, 15),


(@react_id, 'useEffect — Data Fetching and Side Effects',
'A side effect is anything that reaches outside the component: fetching data from an API, updating the page title, setting a timer, or subscribing to an event. React''s useEffect hook is where you put this code. It runs after the component renders, keeping side effects out of the render function itself.

useEffect takes two arguments: the function to run, and a dependency array. The dependency array controls when the effect runs. An empty array [] means "run once after the first render" — perfect for fetching initial data. An array with variables means "re-run whenever those variables change." No array at all means "re-run after every single render" — usually not what you want.

Cleanup is the third important concept. If your effect sets up a subscription, interval, or event listener, you need to clean it up when the component unmounts. Return a cleanup function from useEffect — React will call it before running the effect again or when the component is removed from the page.',
'// React — useEffect Hook
// ─────────────────────────────────────────────
import React, { useState, useEffect } from "react";


// ── useEffect basics ─────────────────────────────
function PageTitleUpdater({ title }) {
    useEffect(() => {
        document.title = title + " — Coder";   // side effect: updates browser tab
    }, [title]);                                // re-run whenever title changes

    return <h1>{title}</h1>;
}


// ── Fetch data on mount ([] = run once) ──────────
function CourseList() {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error,   setError]   = useState(null);

    useEffect(() => {
        // This runs AFTER the first render
        async function fetchCourses() {
            try {
                const res  = await fetch("/api/courses");
                const data = await res.json();
                setCourses(data);
            } catch (err) {
                setError("Failed to load courses.");
            } finally {
                setLoading(false);
            }
        }

        fetchCourses();   // call the async function
    }, []);               // [] = only run once, on mount

    if (loading) return <p>Loading...</p>;
    if (error)   return <p style={{color:"red"}}>{error}</p>;

    return (
        <ul>
            {courses.map(course => (
                <li key={course.id}>{course.title}</li>
                // key is required when rendering lists — helps React track items
            ))}
        </ul>
    );
}


// ── Re-fetch when a dependency changes ───────────
function LessonList({ courseId }) {
    const [lessons, setLessons] = useState([]);

    useEffect(() => {
        if (!courseId) return;

        fetch(`/api/lessons/${courseId}`)
            .then(r => r.json())
            .then(data => setLessons(data))
            .catch(console.error);

    }, [courseId]);   // re-fetch whenever courseId changes

    return (
        <ul>
            {lessons.map(l => <li key={l.id}>{l.title}</li>)}
        </ul>
    );
}


// ── Cleanup — clear interval when component unmounts ──
function Timer() {
    const [seconds, setSeconds] = useState(0);

    useEffect(() => {
        const interval = setInterval(() => {
            setSeconds(prev => prev + 1);
        }, 1000);

        // Return a cleanup function — React calls this on unmount
        return () => clearInterval(interval);
    }, []);   // set up once, clean up on unmount

    return <p>Elapsed: {seconds}s</p>;
}',
'javascript', 3, 15),


(@react_id, 'Lists, Events, and Conditional Rendering',
'Three patterns appear in almost every React application: rendering a list of items, handling user events, and conditionally showing or hiding parts of the UI. Once you understand these three, you can build the majority of real-world interfaces.

Rendering lists: use the .map() method to transform an array of data into an array of JSX elements. Every element in the list must have a unique key prop — React uses this to efficiently update only the items that changed, rather than re-rendering the entire list.

Events in React use camelCase names (onClick, onChange, onSubmit) instead of lowercase HTML attribute names. You pass a function reference, not a string — onClick={handleClick}, not onclick="handleClick()". React wraps all native DOM events in a SyntheticEvent, which works the same across all browsers.

Conditional rendering uses regular JavaScript: the && operator (show if true), the ternary operator (show this or that), or an early return inside the component.',
'// React — Lists, Events, Conditional Rendering
// ─────────────────────────────────────────────
import React, { useState } from "react";


// ── Rendering a list ─────────────────────────────
const courses = [
    { id: 1, title: "Python",     language: "python",     xp: 150 },
    { id: 2, title: "JavaScript", language: "javascript", xp: 200 },
    { id: 3, title: "Java",       language: "java",       xp: 180 },
];

function CourseList() {
    return (
        <ul>
            {courses.map(course => (
                // key must be unique — use id, never the array index
                <li key={course.id}>
                    {course.title} — {course.xp} XP
                </li>
            ))}
        </ul>
    );
}


// ── Event handling ───────────────────────────────
function LikeButton() {
    const [likes, setLikes] = useState(0);

    // Event handler — receives the event object (optional to use)
    function handleClick(event) {
        setLikes(prev => prev + 1);
        console.log("Clicked at:", event.clientX, event.clientY);
    }

    return (
        <button onClick={handleClick}>
            ❤️ {likes} {likes === 1 ? "like" : "likes"}
        </button>
    );
}


// ── Conditional rendering ────────────────────────
function UserProfile({ user }) {
    // Early return — nothing to show if no user
    if (!user) {
        return <p>Please log in to view your profile.</p>;
    }

    return (
        <div>
            <h2>{user.username}</h2>

            {/* && — only shows if xp > 1000 */}
            {user.xp > 1000 && <span>🏆 Pro Learner</span>}

            {/* Ternary — show different UI based on xp */}
            <p>{user.xp >= 500 ? "Advanced" : "Beginner"} level</p>

            {/* Computed class name based on state */}
            <div className={user.xp > 500 ? "badge-gold" : "badge-silver"}>
                {user.xp} XP
            </div>
        </div>
    );
}


// ── Putting it all together — filterable list ────
function FilterableCourseList() {
    const [filter, setFilter] = useState("all");

    const filtered = filter === "all"
        ? courses
        : courses.filter(c => c.language === filter);

    return (
        <div>
            <div>
                <button onClick={() => setFilter("all")}>All</button>
                <button onClick={() => setFilter("python")}>Python</button>
                <button onClick={() => setFilter("javascript")}>JavaScript</button>
            </div>

            {filtered.length === 0
                ? <p>No courses match this filter.</p>
                : filtered.map(c => (
                    <div key={c.id}>
                        <strong>{c.title}</strong> — {c.xp} XP
                    </div>
                ))
            }
        </div>
    );
}',
'javascript', 4, 15),


(@react_id, 'Building a Real Mini-App',
'The best way to understand React is to see how the individual pieces — components, props, state, effects, and events — work together in a real application. In this lesson we build a complete mini task manager: add tasks, mark them done, filter by status, and delete them. This covers everything you have learned in one cohesive example.

The key pattern here is "lifting state up". When multiple components need to share data — the task list, the filter, the input — we store that state in the closest common parent component and pass it down as props. The parent owns the data; children display it or trigger changes through callback functions passed as props.

This single-direction data flow (parent → child through props, child → parent through callbacks) is the core mental model of React. Data flows down. Events bubble up. Once you understand this, building complex UIs becomes predictable and manageable.',
'// React — Mini Task Manager App
// ─────────────────────────────────────────────
import React, { useState } from "react";


// ── Individual task component ─────────────────────
function Task({ task, onToggle, onDelete }) {
    return (
        <div style={{
            display: "flex",
            alignItems: "center",
            gap: "12px",
            padding: "12px",
            background: "#1a1a2e",
            borderRadius: "8px",
            marginBottom: "8px",
            textDecoration: task.done ? "line-through" : "none",
            opacity: task.done ? 0.6 : 1
        }}>
            <input
                type="checkbox"
                checked={task.done}
                onChange={() => onToggle(task.id)}   // call parent''s handler
            />
            <span style={{ flex: 1 }}>{task.text}</span>
            <button
                onClick={() => onDelete(task.id)}
                style={{ color: "#ff6b6b", background: "none", border: "none", cursor: "pointer" }}
            >
                Delete
            </button>
        </div>
    );
}


// ── Add task form ─────────────────────────────────
function AddTaskForm({ onAdd }) {
    const [text, setText] = useState("");

    function handleSubmit(e) {
        e.preventDefault();
        if (!text.trim()) return;
        onAdd(text.trim());   // call parent''s handler with the text
        setText("");           // clear the input
    }

    return (
        <form onSubmit={handleSubmit} style={{ display: "flex", gap: "8px", marginBottom: "16px" }}>
            <input
                value={text}
                onChange={e => setText(e.target.value)}
                placeholder="Add a new task..."
                style={{ flex: 1, padding: "10px", borderRadius: "6px", border: "1px solid #444", background: "#1a1a2e", color: "white" }}
            />
            <button type="submit" style={{ padding: "10px 20px", background: "#6c63ff", color: "white", border: "none", borderRadius: "6px", cursor: "pointer" }}>
                Add
            </button>
        </form>
    );
}


// ── Main App — owns all state ─────────────────────
let nextId = 1;

function TaskApp() {
    const [tasks,  setTasks]  = useState([
        { id: nextId++, text: "Learn React basics", done: true  },
        { id: nextId++, text: "Build a component",  done: false },
        { id: nextId++, text: "Understand useState", done: false },
    ]);
    const [filter, setFilter] = useState("all");  // "all" | "active" | "done"

    function addTask(text)  { setTasks(prev => [...prev, { id: nextId++, text, done: false }]); }
    function toggleTask(id) { setTasks(prev => prev.map(t => t.id === id ? {...t, done: !t.done} : t)); }
    function deleteTask(id) { setTasks(prev => prev.filter(t => t.id !== id)); }

    const filtered = tasks.filter(t =>
        filter === "all"    ? true :
        filter === "active" ? !t.done :
        t.done
    );

    const doneCount = tasks.filter(t => t.done).length;

    return (
        <div style={{ maxWidth: "500px", margin: "40px auto", padding: "24px", background: "#0d0d1a", color: "white", borderRadius: "16px" }}>
            <h1>Task Manager</h1>
            <p style={{ color: "#8b8ba7" }}>{doneCount} of {tasks.length} tasks done</p>

            <AddTaskForm onAdd={addTask} />

            <div style={{ display: "flex", gap: "8px", marginBottom: "16px" }}>
                {["all","active","done"].map(f => (
                    <button key={f} onClick={() => setFilter(f)}
                        style={{ padding: "6px 14px", borderRadius: "6px", border: "none", cursor: "pointer",
                                 background: filter === f ? "#6c63ff" : "#1a1a2e", color: "white" }}>
                        {f.charAt(0).toUpperCase() + f.slice(1)}
                    </button>
                ))}
            </div>

            {filtered.length === 0
                ? <p style={{ color: "#8b8ba7", textAlign: "center" }}>No tasks here.</p>
                : filtered.map(task => (
                    <Task key={task.id} task={task} onToggle={toggleTask} onDelete={deleteTask} />
                ))
            }
        </div>
    );
}

export default TaskApp;',
'javascript', 5, 15);


-- ═══════════════════════════════════════════════════════════
--  GIT & GITHUB  (new course)
-- ═══════════════════════════════════════════════════════════

SET @git_id = (SELECT id FROM courses WHERE language = 'bash' LIMIT 1);

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@git_id, 'What is Git? Your First Repository',
'Git is a version control system — software that tracks every change you make to your files over time. Without Git, you save a file and the previous version is gone forever. With Git, every version is saved. You can see what changed, when it changed, who changed it, and go back to any previous state at any time.

Think of Git like a detailed history book for your project. Each chapter (called a commit) records a snapshot of your project at one moment in time, along with a message describing what changed. You can always flip back to any chapter.

Git is local — it runs entirely on your computer, with no internet connection needed. GitHub (and similar sites like GitLab, Bitbucket) is a cloud service that hosts Git repositories online, making it easy to back up your work and collaborate with others. Git and GitHub are often confused, but they are different things: Git is the tool, GitHub is the hosting service.',
'# Git — Setting up and creating your first repository
# ─────────────────────────────────────────────────────

# ── One-time setup (do this once per computer) ────
git config --global user.name  "Ahmed Almarouf"
git config --global user.email "ahmed@email.com"
git config --global init.defaultBranch main


# ── Create a new repository ───────────────────────
mkdir my-project          # create a folder
cd my-project             # navigate into it
git init                  # turn this folder into a Git repository
# Output: Initialized empty Git repository in .git/

# Git creates a hidden .git/ folder — this IS the repository
# Never delete or edit it manually


# ── Check the status of your repository ──────────
git status
# Output: On branch main, No commits yet, nothing to commit


# ── Create your first file ────────────────────────
echo "# My Project" > README.md    # create a file with some content

git status
# Output:
# Untracked files:
#   README.md
# (nothing added to commit but untracked files present)


# ── Stage the file (prepare it for commit) ───────
git add README.md       # stage one specific file
# OR
git add .              # stage ALL changed files


# ── Make your first commit ────────────────────────
git commit -m "Initial commit: add README"
# -m followed by the commit message in quotes


# ── View the history ──────────────────────────────
git log                # full history with dates and hashes
git log --oneline      # compact: one line per commit


# ── The three areas of Git ────────────────────────
# 1. Working directory  — your actual files on disk
# 2. Staging area       — files you have "git add"ed, ready to commit
# 3. Repository (.git/) — committed snapshots, the permanent history',
'bash', 1, 15),


(@git_id, 'Commits — Saving Your Work Properly',
'A commit is a snapshot of your project at a specific moment. Good commits are the foundation of a useful Git history. A well-maintained history lets you understand exactly what changed and why — months or years later, when you have forgotten the details, or when a new team member needs to understand the codebase.

The golden rule of commits: commit often, commit early. Each commit should represent one logical change — one bug fix, one feature, one refactor. A commit that changes ten unrelated things is hard to understand, hard to reverse, and impossible to explain in one sentence.

Writing good commit messages is a skill. The first line should be a short (50 chars or less) summary in the imperative mood: "Add login form", not "Added login form" or "This commit adds a login form". If you need to explain WHY, add a blank line after the summary and write a longer description.',
'# Git — Making Meaningful Commits
# ─────────────────────────────────────────────────

# ── See what changed since the last commit ────────
git status              # which files are changed/new/deleted
git diff                # exact line-by-line changes (unstaged)
git diff --staged       # changes that are staged but not yet committed


# ── Stage files selectively ───────────────────────
git add index.html      # stage one file
git add css/            # stage an entire folder
git add *.js            # stage all .js files
git add -p              # interactive: choose which chunks to stage


# ── Commit with a good message ────────────────────
git commit -m "Add user registration form with validation"

# Multi-line message (opens your default editor):
git commit
# Type your message, save, and close the editor


# ── Undo the LAST commit (keeps changes in files) ─
git reset --soft HEAD~1     # undo commit, keep changes staged
git reset HEAD~1            # undo commit, keep changes unstaged


# ── Discard all uncommitted changes (CAREFUL!) ────
git checkout -- filename.txt    # discard changes to one file
git restore .                   # discard ALL uncommitted changes


# ── View history ──────────────────────────────────
git log --oneline
# Output:
# a3f9c2e Add user registration form with validation
# 8d1e4b1 Add navigation bar
# 3c7a2f0 Initial commit: set up project structure

git log --oneline --graph --all   # visual branch graph

# See what changed in a specific commit:
git show a3f9c2e                  # replace with the actual hash


# ── .gitignore — tell Git to ignore files ─────────
# Create a file called .gitignore in your project root:
# node_modules/
# .env
# *.log
# dist/
# build/

# Once in .gitignore, Git will never track those files.
# IMPORTANT: Add .env to .gitignore BEFORE committing — never commit secrets!',
'bash', 2, 15),


(@git_id, 'Branches — Working in Parallel',
'A branch is an independent line of development. The default branch is called main (or master in older projects). When you create a new branch, you get a complete copy of the project at that point. You can make as many commits as you want on your branch without affecting main. When you are done, you merge your branch back into main.

Branches are what make team collaboration possible. Ten developers can each work on their own feature branch simultaneously, without stepping on each other''s work. Branches are also used for bug fixes, experiments, and releases — anything you want to develop in isolation.

Creating and switching branches in Git is almost instant — Git does not copy files, it just changes a pointer. This makes branching very cheap. The common workflow: create a branch for your feature, work on it, push it to GitHub, open a pull request, get it reviewed, merge it. This is called a feature branch workflow and it is used by virtually every professional software team.',
'# Git — Branches
# ─────────────────────────────────────────────────

# ── See all branches ──────────────────────────────
git branch              # list local branches (* = current branch)
git branch -a           # list all branches including remote


# ── Create and switch to a new branch ─────────────
git branch feature/login         # create branch (stay on current)
git checkout feature/login       # switch to it
# OR — one command that does both:
git checkout -b feature/login

# Modern syntax (Git 2.23+):
git switch -c feature/login      # create and switch


# ── Work on your feature ──────────────────────────
# Make changes, stage, commit — all on the feature branch
git add login.html
git commit -m "Add login page HTML structure"
git add css/login.css
git commit -m "Style the login form"


# ── Switch back to main ───────────────────────────
git switch main       # or: git checkout main
# Your login files are not here — they are on the feature branch


# ── Merge the feature branch into main ────────────
git merge feature/login
# Git combines the commits from feature/login into main

# If there are no conflicts: "Fast-forward" merge — done!
# If there are conflicts: Git marks them in the files — you resolve manually


# ── Delete the branch after merging ───────────────
git branch -d feature/login    # safe delete (only if merged)
git branch -D feature/login    # force delete (even if not merged)


# ── Resolve a merge conflict ──────────────────────
# Git marks conflicts like this in the file:
#
# <<<<<<< HEAD
# const title = "Login";        ← your version (main)
# =======
# const title = "Sign In";      ← incoming version (feature branch)
# >>>>>>> feature/login
#
# Edit the file to keep what you want, then:
git add filename.js
git commit -m "Resolve merge conflict in login title"',
'bash', 3, 15),


(@git_id, 'GitHub — Sharing and Backing Up Your Work',
'Git runs on your local machine. GitHub is a website that hosts Git repositories in the cloud. Pushing your repository to GitHub gives you a backup, lets you share your code, and enables collaboration with other developers. It is also where you build your public portfolio — future employers will look at your GitHub profile.

A remote is a reference to a Git repository hosted elsewhere. The default remote is typically called origin. When you clone a repository from GitHub, Git automatically sets origin to point to that URL. When you push, you send your local commits to the remote. When you pull, you download any new commits from the remote.

GitHub is much more than a hosting service. It has pull requests (code review), issues (bug tracking), GitHub Actions (automated testing and deployment), and GitHub Pages (free website hosting). Most open-source software in the world is hosted on GitHub.',
'# Git and GitHub — Remotes, Push, Pull
# ─────────────────────────────────────────────────

# ── Connect your local repo to GitHub ─────────────
# First, create a new repo on github.com (do not initialise with README)
# Then, in your local project folder:

git remote add origin https://github.com/yourusername/your-repo.git
# "origin" is the conventional name for your primary remote

git remote -v           # verify the remote was added
# origin  https://github.com/yourusername/your-repo.git (fetch)
# origin  https://github.com/yourusername/your-repo.git (push)


# ── Push your local commits to GitHub ─────────────
git push -u origin main
# -u sets "origin main" as the default — next time just "git push"

git push                # push after the first time


# ── Clone an existing repository from GitHub ──────
git clone https://github.com/username/repository.git
# Downloads the entire repo, history and all, into a new folder
cd repository


# ── Fetch and pull — get updates from remote ──────
git fetch               # download changes but do NOT merge them
git status              # tells you if you are behind the remote

git pull                # fetch + merge in one step
# This is what you run every morning before starting work


# ── The daily workflow ────────────────────────────
# 1. Pull to get latest changes
git pull

# 2. Create a branch for your work
git switch -c feature/my-feature

# 3. Make changes, commit often
git add .
git commit -m "Descriptive message about what you did"

# 4. Push your branch to GitHub
git push -u origin feature/my-feature

# 5. Open a Pull Request on github.com
# (colleagues review your code before it goes into main)

# 6. After merge, clean up
git switch main
git pull
git branch -d feature/my-feature',
'bash', 4, 15),


(@git_id, 'Pull Requests, GitHub Flow, and Best Practices',
'A pull request (PR) is a proposal to merge your branch into another branch (usually main). You open a PR on GitHub, your teammates review the code, leave comments, request changes, and finally approve it. Only then does it get merged. This review process is one of the most important parts of professional software development — it catches bugs, shares knowledge, and keeps code quality high.

GitHub Flow is the simplest and most widely used workflow. The rule: the main branch is always deployable. You never commit directly to main. All work happens on feature branches. PRs are the only way code enters main. This keeps main stable and production-ready at all times.

Good Git habits make the difference between a helpful history and a useless one. Commit often (not once a day — after each logical change). Write meaningful commit messages. Keep branches short-lived (merge within days, not weeks). Never force-push to shared branches. Never commit sensitive data like passwords, API keys, or .env files.',
'# Git — Best Practices and GitHub Flow
# ─────────────────────────────────────────────────

# ── Complete GitHub Flow ──────────────────────────

# STEP 1: Always start from an up-to-date main
git switch main
git pull

# STEP 2: Create a descriptively named branch
git switch -c fix/login-validation-error
# Good branch names: feature/user-profile, fix/null-pointer, docs/readme-update
# Bad branch names: test, my-branch, stuff, asdf


# STEP 3: Make focused commits
git add public/js/validation.js
git commit -m "Fix: email validation now handles subdomains correctly"

git add tests/validation.test.js
git commit -m "Add tests for email validation edge cases"


# STEP 4: Push to GitHub and open a PR
git push -u origin fix/login-validation-error
# Then go to github.com — GitHub will show a banner to open a PR


# STEP 5: After PR is approved and merged, clean up
git switch main
git pull
git branch -d fix/login-validation-error


# ── Useful everyday commands ──────────────────────

# See a visual graph of all branches
git log --oneline --graph --all --decorate

# Stash uncommitted changes temporarily (save for later)
git stash
git stash pop                     # restore stashed changes

# Find which commit introduced a bug (bisect)
git bisect start
git bisect bad                    # current commit has the bug
git bisect good v1.0              # v1.0 was fine
# Git checks out commits one by one — you test each and say good/bad


# ── Things to NEVER do ────────────────────────────
# NEVER: git push --force on a shared branch (rewrites history others have)
# NEVER: git commit .env or passwords (use .gitignore)
# NEVER: git add . without checking git status first
# NEVER: commit directly to main — always use a branch


# ── .gitignore for a Node.js project ─────────────
# Create .gitignore in your project root with:
# node_modules/
# .env
# .env.local
# dist/
# *.log
# .DS_Store   (Mac)
# Thumbs.db   (Windows)',
'bash', 5, 15);


-- ═══════════════════════════════════════════════════════════
--  UPDATE LESSON COUNTS
-- ═══════════════════════════════════════════════════════════

UPDATE courses SET lessons = 10 WHERE id = 4;   -- C++
UPDATE courses SET lessons = 10 WHERE id = 5;   -- HTML & CSS
UPDATE courses SET lessons = 10 WHERE id = 6;   -- SQL
UPDATE courses SET lessons =  5 WHERE language = 'typescript';
UPDATE courses SET lessons =  5 WHERE language = 'react';
UPDATE courses SET lessons =  5 WHERE language = 'bash';
