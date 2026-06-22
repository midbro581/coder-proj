-- ============================================================
-- CODER — more_lessons.sql
-- Real, high-quality lessons for Python, JavaScript, and Java.
-- Import this AFTER schema.sql has already been imported.
-- In phpMyAdmin: select coder_db → Import tab → choose this file → Go
-- ============================================================

USE coder_db;

INSERT IGNORE INTO lessons
  (course_id, title, content, code_example, language, order_num, xp_reward)
VALUES

-- ═══════════════════════════════════════════════════
--  PYTHON  (course_id = 1 , orders 6 – 10)
-- ═══════════════════════════════════════════════════

(1,
'Making Decisions — if, elif, else',

'Every useful program needs to make choices. The if statement lets your code do something only when a condition is true — like a bouncer at a door who only lets you in if you are 18 or older.

You can test multiple possibilities one after another using elif (short for "else if"). Python checks each condition from top to bottom and runs only the FIRST block that matches, then skips everything else. If nothing matches, the else block runs as your fallback.

Comparison operators are how you build conditions: == checks equality (one equal sign assigns, two equal signs compare), != means "not equal", > and < compare size, and >= or <= include the boundary. Combine conditions with and (both must be true) or or (at least one must be true).',

'# Making Decisions — if / elif / else
# ─────────────────────────────────────

score = 85   # <-- try changing this to 95, 72, or 50 and run again!

if score >= 90:
    print("Grade: A — Outstanding!")

elif score >= 80:   # elif = else if — only checked when the line above was False
    print("Grade: B — Great work!")

elif score >= 70:
    print("Grade: C — You passed!")

elif score >= 60:
    print("Grade: D — Just made it!")

else:               # Runs when NOTHING above matched
    print("Grade: F — Keep going, you will get it!")


# ─────────────────────────────────────
# Combining conditions

age = 20
has_id = True

if age >= 18 and has_id:       # BOTH must be True
    print("Welcome in!")

temperature = 5
is_raining  = True

if temperature < 10 or is_raining:  # AT LEAST ONE must be True
    print("Take a jacket today.")


# ─────────────────────────────────────
# Common mistake: = vs ==
name = "Ahmed"       # ONE  equal sign  →  ASSIGNS a value
if name == "Ahmed":  # TWO equal signs  →  COMPARES values
    print("Hello, Ahmed!")',

'python', 6, 15),


(1,
'Loops — Repeating Code Without Copy-Paste',

'Imagine you want to print "Hello" 100 times. You could write 100 print lines — or you could use a loop. Loops are one of the most powerful ideas in programming: they let you repeat a block of code as many times as you need with just a few lines.

The for loop is used when you know what you are looping over — a list of items, a range of numbers, or the characters in a string. Python reads it like English: "for each item in this collection, do this."

The while loop keeps running as long as a condition stays true. It is useful when you do not know in advance how many times you need to repeat — for example, keep asking for a password until the user gets it right. Always make sure the condition eventually becomes False, or the loop will run forever.',

'# for loops — looping over a known sequence
# ─────────────────────────────────────────────

# Loop through a range of numbers (0 up to but NOT including 5)
for i in range(5):
    print(f"Step {i}")   # prints: Step 0, Step 1, Step 2, Step 3, Step 4

# range(start, stop) — start is included, stop is NOT
for i in range(1, 6):
    print(f"Counting: {i}")   # 1, 2, 3, 4, 5

# Loop over a list
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(f"I like {fruit}")

# Loop over characters in a string
for letter in "Python":
    print(letter)   # P y t h o n  (one per line)


# ─────────────────────────────────────────────
# while loops — keep going until a condition is False

countdown = 5

while countdown > 0:
    print(f"Launching in {countdown}...")
    countdown -= 1       # This line DECREASES countdown each time — important!

print("Blast off!")


# ─────────────────────────────────────────────
# break — stop the loop early
# continue — skip the rest of THIS step and go to the next

for number in range(10):
    if number == 3:
        continue    # skip 3, keep going
    if number == 7:
        break       # stop completely when we reach 7
    print(number)  # prints: 0 1 2 4 5 6',

'python', 7, 15),


(1,
'Functions — Write Once, Use Anywhere',

'A function is a named block of code that you can run (call) whenever you need it. Think of it like a recipe: you write the instructions once, give it a name, and then any time you want to cook that dish, you just call its name instead of rewriting all the steps.

Functions can accept inputs called parameters and can return an output using the return keyword. This makes them reusable — you write the logic once and call it with different values each time. Good functions do ONE thing and do it well.

Python also supports default parameter values. If you do not pass a value for a parameter that has a default, the default is used automatically. This makes your functions flexible — callers can choose to provide a value or use the sensible default.',

'# Defining and calling functions
# ─────────────────────────────────

# def keyword defines a function
# greet is the name, name is the parameter (input)
def greet(name):
    message = f"Hello, {name}! Welcome to Coder."
    return message    # return sends a value BACK to wherever the function was called

# Calling the function — provide the argument (actual value)
result = greet("Ahmed")
print(result)        # Hello, Ahmed! Welcome to Coder.

print(greet("Sara")) # Hello, Sara! Welcome to Coder.


# ─────────────────────────────────
# Functions with multiple parameters

def add(a, b):
    return a + b

print(add(3, 7))     # 10
print(add(100, 50))  # 150


# ─────────────────────────────────
# Default parameter values — used when caller does not provide one

def power(base, exponent=2):   # exponent defaults to 2 if not given
    return base ** exponent

print(power(5))      # 25  (5 squared — exponent used the default 2)
print(power(5, 3))   # 125 (5 cubed — caller provided 3)


# ─────────────────────────────────
# Real-world example: temperature converter

def celsius_to_fahrenheit(c):
    return (c * 9/5) + 32

print(celsius_to_fahrenheit(0))    # 32.0
print(celsius_to_fahrenheit(100))  # 212.0
print(celsius_to_fahrenheit(37))   # 98.6 (normal body temperature!)',

'python', 8, 15),


(1,
'Dictionaries — Storing Data with Labels',

'A list stores items in order by position (index 0, 1, 2…). A dictionary is different: it stores items as key-value pairs. Instead of remembering "the name is at position 0", you say "give me the name" — and Python finds it by its label, or key.

Think of a dictionary like a real dictionary: you look up a word (the key) and get its definition (the value). Keys must be unique, and they are almost always strings or numbers. Values can be anything — strings, numbers, lists, even other dictionaries.

Dictionaries are everywhere in real programming. A user profile, a product record, an API response from the internet — all of these are naturally represented as dictionaries. Mastering them is one of the most important things you can do as a Python developer.',

'# Dictionaries — key: value pairs
# ─────────────────────────────────

# Creating a dictionary with {}
student = {
    "name":   "Ahmed",      # key: "name",  value: "Ahmed"
    "age":    20,           # key: "age",   value: 20
    "grade":  "A",
    "passed": True
}

# Reading values by key
print(student["name"])    # Ahmed
print(student["age"])     # 20

# A safe way to read (returns None instead of crashing if key is missing)
print(student.get("email"))         # None
print(student.get("email", "N/A"))  # N/A  (your own default)


# ─────────────────────────────────
# Adding and updating entries

student["email"] = "ahmed@gmail.com"   # Add a new key
student["age"]   = 21                  # Update an existing key
print(student)


# ─────────────────────────────────
# Removing entries

del student["passed"]     # removes the "passed" key


# ─────────────────────────────────
# Looping over a dictionary

menu = {
    "coffee": 3.50,
    "tea":    2.00,
    "juice":  4.00
}

for item, price in menu.items():   # .items() gives both key AND value
    print(f"{item:10} — ${price:.2f}")

# Useful dictionary methods:
print(list(menu.keys()))    # ["coffee", "tea", "juice"]
print(list(menu.values()))  # [3.50, 2.00, 4.00]
print(len(menu))            # 3',

'python', 9, 15),


(1,
'Handling Errors — try, except, finally',

'When something goes wrong in Python, it raises an exception — an error that stops your program. If you open a file that does not exist, divide by zero, or enter text where a number is expected, Python raises an exception and your code crashes.

The try/except block lets you handle errors gracefully. Code inside try runs normally. If something goes wrong, Python jumps to the except block instead of crashing. Your program keeps running, and you can show the user a helpful message or try a different approach.

This is the difference between a professional application and a fragile script. Real software always expects that things can go wrong and handles it gracefully. Adding error handling takes five minutes but makes your code a hundred times more reliable.',

'# Handling Errors — try / except / finally
# ─────────────────────────────────────────

# Without error handling — this would CRASH:
# result = 10 / 0    →  ZeroDivisionError!

# With error handling — safe:
try:
    result = 10 / 0
except ZeroDivisionError:
    print("You cannot divide by zero!")  # This runs instead of crashing


# ─────────────────────────────────
# Real example: safe number input

def get_number(prompt):
    try:
        return int(input(prompt))       # int() fails if user types "abc"
    except ValueError:
        print("That is not a valid number. Using 0.")
        return 0

age = get_number("Enter your age: ")
print(f"You are {age} years old.")


# ─────────────────────────────────
# Catching multiple exception types

filename = "data.txt"

try:
    with open(filename, "r") as f:     # Try to open a file
        content = f.read()
        number  = int(content)         # Try to convert content to int

except FileNotFoundError:
    print(f"File '{filename}' does not exist.")

except ValueError:
    print("File exists but does not contain a number.")

except Exception as e:
    print(f"Something unexpected went wrong: {e}")   # Catches ANYTHING else

finally:
    # finally ALWAYS runs — whether an error happened or not
    # Use it for cleanup: closing files, database connections, etc.
    print("Done handling the file operation.")',

'python', 10, 15),


-- ═══════════════════════════════════════════════════
--  JAVASCRIPT  (course_id = 3 , orders 6 – 10)
-- ═══════════════════════════════════════════════════

(3,
'Making Decisions — if, else, Comparison Operators',

'JavaScript programs constantly need to make decisions: Is the user logged in? Is the price above budget? Did the form pass validation? All of these are conditions — things that are either true or false.

The if statement runs a block of code only when a condition is true. The else block is optional and runs when the condition is false. You can chain multiple conditions with else if. JavaScript checks them top to bottom and runs only the first one that matches.

Operators you will use every day: === checks both value AND type (always prefer this over ==), !== checks if values are different, > and < compare numbers, >= and <= include the boundary. The logical operators && (and) and || (or) let you combine multiple conditions into one.',

'// Making Decisions in JavaScript
// ─────────────────────────────────

const score = 85;  // Change this and see what happens!

if (score >= 90) {
    console.log("Grade: A — Excellent!");

} else if (score >= 80) {   // else if — checked only when above was false
    console.log("Grade: B — Well done!");

} else if (score >= 70) {
    console.log("Grade: C — Passed!");

} else {                    // Runs when ALL conditions above were false
    console.log("Grade: F — Keep practising!");
}


// ─────────────────────────────────
// === vs == — always use ===

console.log(5 == "5");    // true  — just compares value (loose)
console.log(5 === "5");   // false — compares value AND type (strict)
// Rule: use === and !== everywhere. Never use == or !=


// ─────────────────────────────────
// Combining conditions

const age    = 20;
const hasID  = true;

if (age >= 18 && hasID) {       // && means AND — both must be true
    console.log("Welcome in!");
}

const isWeekend = true;
const isHoliday = false;

if (isWeekend || isHoliday) {   // || means OR — at least one must be true
    console.log("No work today!");
}


// ─────────────────────────────────
// The ternary operator — compact if/else in one line
// condition ? "value if true" : "value if false"

const hour    = 14;
const message = hour < 12 ? "Good morning!" : "Good afternoon!";
console.log(message);  // Good afternoon!',

'javascript', 6, 15),


(3,
'Loops — for, while, and forEach',

'A loop lets you repeat a block of code many times without writing it multiple times. This is one of the most fundamental ideas in programming — almost everything a computer does involves repetition.

The classic for loop is best when you know how many times you want to repeat. The while loop is better when you keep going until something changes. The modern for...of loop is the cleanest way to go through every item in an array. And arrays have a built-in forEach method that is even more readable than for loops when you want to do something to each element.

Learning when to use which loop comes with practice. Start with for when you need the index (position number) and for...of or forEach when you just need the value.',

'// for loop — classic, use when you need the index
// ─────────────────────────────────────────────────

for (let i = 0; i < 5; i++) {
    // i starts at 0, runs while i < 5, increases by 1 each time
    console.log(`Step ${i}`);   // Step 0, Step 1, Step 2, Step 3, Step 4
}

// Loop backwards
for (let i = 5; i >= 1; i--) {
    console.log(`Countdown: ${i}`);
}


// ─────────────────────────────────
// for...of — cleanest way to loop over an array

const languages = ["Python", "JavaScript", "Java", "C++"];

for (const lang of languages) {
    console.log(`Language: ${lang}`);
}


// ─────────────────────────────────
// forEach — a method built into every array

languages.forEach((lang, index) => {
    // lang   = the current item
    // index  = its position (0, 1, 2...)
    console.log(`${index + 1}. ${lang}`);
});


// ─────────────────────────────────
// while loop — runs as long as condition is true

let password = "";
let attempts = 0;

while (password !== "secret123") {
    attempts++;
    password = "secret123";   // In real code, this would be user input
}
console.log(`Logged in after ${attempts} attempt(s).`);


// ─────────────────────────────────
// break and continue — control loop flow

for (let i = 0; i < 10; i++) {
    if (i === 3) continue;  // skip 3 and go to next iteration
    if (i === 7) break;     // stop the loop completely at 7
    console.log(i);         // prints: 0 1 2 4 5 6
}',

'javascript', 7, 15),


(3,
'Objects — Grouping Data That Belongs Together',

'A JavaScript object lets you store multiple related pieces of information under one name. Instead of having separate variables for a person''s name, age, and email, you put them all into one object — and access them using dot notation.

Objects consist of properties (data) and methods (functions). A method is just a function stored inside an object. The special keyword this refers to the object itself inside a method, letting the function access the object''s own data.

Objects are everywhere in JavaScript. The document object controls the web page. The window object represents the browser. API responses are objects. Even arrays are a special type of object. Understanding objects is the key to understanding the entire JavaScript ecosystem.',

'// Creating an object with properties and methods
// ─────────────────────────────────────────────────

const student = {
    name:    "Ahmed",        // property: a piece of data
    age:     20,
    course:  "JavaScript",
    grade:   "A",

    // A method: a function that lives inside the object
    introduce() {
        // "this" refers to the object itself
        return `Hi, I am ${this.name} and I study ${this.course}.`;
    },

    isPassingAge(minAge) {
        return this.age >= minAge;
    }
};

// Reading properties — use a dot
console.log(student.name);       // Ahmed
console.log(student.course);     // JavaScript

// Calling a method
console.log(student.introduce()); // Hi, I am Ahmed and I study JavaScript.


// ─────────────────────────────────
// Adding, changing, and deleting properties

student.email   = "ahmed@email.com";  // Add a new property
student.age     = 21;                 // Update an existing property
delete student.grade;                 // Remove a property


// ─────────────────────────────────
// Looping over an object''s properties

const prices = { coffee: 3.5, tea: 2.0, juice: 4.0 };

for (const [item, price] of Object.entries(prices)) {
    // Object.entries() gives you [key, value] pairs
    console.log(`${item}: $${price.toFixed(2)}`);
}


// ─────────────────────────────────
// Destructuring — pulling properties into variables

const { name, age, course } = student;   // short for: const name = student.name; etc.
console.log(name, age, course);          // Ahmed 21 JavaScript',

'javascript', 8, 15),


(3,
'Array Methods — map, filter, find, reduce',

'Arrays come with powerful built-in methods that make working with lists of data clean and readable. Instead of writing a for loop to build a new array, you call map(). Instead of writing a loop to find items that match a condition, you call filter(). These methods make your code shorter, clearer, and easier to understand at a glance.

All four key methods accept a callback — a function you pass as an argument that tells the method what to do with each element. This is a core pattern in modern JavaScript called functional programming, and you will use these methods constantly in real projects.

map() transforms every item and returns a new array. filter() returns only items that pass a test. find() returns the first item that passes a test. reduce() collapses the whole array into a single value. None of them change the original array.',

'// The four most important array methods
// ─────────────────────────────────────────

const prices = [10, 25, 5, 80, 15, 60];
const names  = ["ahmed", "sara", "omar", "fatima"];


// ─────────────────────────────────
// map() — transform every item, returns a NEW array

const doubled = prices.map(price => price * 2);
console.log(doubled);   // [20, 50, 10, 160, 30, 120]

const capitalized = names.map(name => name.toUpperCase());
console.log(capitalized);   // ["AHMED", "SARA", "OMAR", "FATIMA"]


// ─────────────────────────────────
// filter() — keep only items that pass the test

const expensive = prices.filter(price => price > 20);
console.log(expensive);   // [25, 80, 60]

const shortNames = names.filter(name => name.length <= 4);
console.log(shortNames);  // ["sara", "omar"]


// ─────────────────────────────────
// find() — returns the FIRST item that passes the test (not an array)

const firstExpensive = prices.find(price => price > 20);
console.log(firstExpensive);   // 25  (the first one over 20)


// ─────────────────────────────────
// reduce() — collapse the whole array into one value

const total = prices.reduce((sum, price) => sum + price, 0);
// Starting value is 0, then adds each price to sum
console.log(total);   // 195

const longest = names.reduce((a, b) => b.length > a.length ? b : a);
console.log(longest); // "fatima"


// ─────────────────────────────────
// Chaining — use them together!

const result = prices
    .filter(p => p > 10)         // keep prices above 10: [25, 80, 15, 60]
    .map(p => p * 0.9)           // apply 10% discount:   [22.5, 72, 13.5, 54]
    .reduce((sum, p) => sum + p, 0);  // total:           162

console.log(`Total after discount: $${result}`);',

'javascript', 9, 15),


(3,
'fetch() — Getting Data from the Internet',

'Modern web apps are alive — they load news feeds, weather, stock prices, social media posts, all from the internet without refreshing the page. This is done with fetch(), a built-in JavaScript function that sends a request to a server and gets data back.

fetch() is asynchronous — it does not make JavaScript wait. Instead, it returns a Promise, which is a placeholder for a value that will arrive in the future. The async/await syntax makes Promises look and read like normal code, avoiding the confusing "callback pyramid" that older code suffered from.

The data you get back from most APIs is in JSON format — basically a JavaScript object written as text. You call response.json() to convert it into a real JavaScript object your code can work with.',

'// fetch() — Getting data from the internet
// ─────────────────────────────────────────

// We use async/await to write async code that LOOKS like normal code
async function getJoke() {
    try {
        // Step 1: Send the request — the "await" pauses here until it arrives
        const response = await fetch("https://official-joke-api.appspot.com/random_joke");

        // Step 2: Check if the request worked
        if (!response.ok) {
            throw new Error(`Server error: ${response.status}`);
        }

        // Step 3: Convert the raw text into a JavaScript object
        const joke = await response.json();

        // Step 4: Use the data
        console.log(joke.setup);    // e.g. "Why do programmers prefer dark mode?"
        console.log(joke.punchline); // e.g. "Because light attracts bugs!"

        return joke;

    } catch (error) {
        // Always handle errors — internet can be unreliable!
        console.error("Could not load joke:", error.message);
    }
}

// Call the async function
getJoke();


// ─────────────────────────────────
// POST request — sending data to a server

async function createUser(name, email) {
    const response = await fetch("https://api.example.com/users", {
        method:  "POST",                         // GET is default, POST sends data
        headers: { "Content-Type": "application/json" },
        body:    JSON.stringify({ name, email }) // convert object to JSON text
    });

    const newUser = await response.json();
    console.log("Created:", newUser);
}

// ─────────────────────────────────
// Quick tip: fetch on a web page

// When your fetch runs in a browser, you can update the page with the result:
async function showWeather() {
    const res  = await fetch("/api/weather");
    const data = await res.json();
    document.getElementById("temp").textContent = `${data.temp}°C`;
}',

'javascript', 10, 15),


-- ═══════════════════════════════════════════════════
--  JAVA  (course_id = 2 , orders 6 – 10)
-- ═══════════════════════════════════════════════════

(2,
'Making Decisions — if, else, switch',

'Java programs make decisions using the same fundamental idea as most languages: check a condition, and run different code depending on whether it is true or false. What makes Java slightly different is its strict typing — conditions must result in a boolean (true or false), not just any value.

The if / else if / else structure works exactly like you would expect: check conditions in order, run the first matching block, skip the rest. When you have many possible values for a single variable, the switch statement is often cleaner — it maps each possible value to a case block.

Java 14+ introduced the switch expression, which is even cleaner than the classic switch. But the classic version still appears in most textbooks and jobs, so learning both matters.',

'// Making Decisions — if / else if / else
// ─────────────────────────────────────────

public class Main {
    public static void main(String[] args) {

        int score = 85;  // Try changing this!

        if (score >= 90) {
            System.out.println("Grade: A — Outstanding!");

        } else if (score >= 80) {   // else if — only checked when above was false
            System.out.println("Grade: B — Great work!");

        } else if (score >= 70) {
            System.out.println("Grade: C — You passed!");

        } else {                    // Runs when ALL conditions above were false
            System.out.println("Grade: F — Keep trying!");
        }


        // ─────────────────────────────────
        // switch — clean when testing ONE variable against many fixed values

        String day = "Monday";

        switch (day) {
            case "Saturday":
            case "Sunday":
                System.out.println("Weekend — rest!");
                break;  // IMPORTANT: break stops it from falling to next case

            case "Monday":
                System.out.println("Back to work.");
                break;

            default:           // Runs when no case matched — like else
                System.out.println("Just another weekday.");
        }


        // ─────────────────────────────────
        // Combining conditions: && (and) || (or) ! (not)

        boolean hasTicket = true;
        int age = 17;

        if (age >= 18 && hasTicket) {
            System.out.println("You can enter!");
        } else {
            System.out.println("Sorry, you cannot enter.");
        }
    }
}',

'java', 6, 15),


(2,
'Loops — for, while, and for-each',

'Loops are fundamental to programming. Without them, you would have to write the same line hundreds of times to process a list of names or perform a calculation repeatedly. Java gives you three main types of loops, each suited to a different situation.

The for loop is best when you know in advance how many times you want to repeat. The while loop keeps running as long as a condition is true — useful when you do not know the count upfront. The enhanced for loop (also called for-each) is the cleanest way to visit every element in an array or list without needing an index variable.

A common beginner mistake is writing an infinite loop — one whose condition never becomes false. Always make sure your loop has a clear path to ending, usually by changing a variable inside the loop.',

'// Loops in Java — for, while, and for-each
// ─────────────────────────────────────────

public class Main {
    public static void main(String[] args) {

        // for loop — best when you know the count
        // Structure: for (start; condition; step)
        for (int i = 1; i <= 5; i++) {
            System.out.println("Step " + i);   // Step 1, 2, 3, 4, 5
        }


        // ─────────────────────────────────
        // while loop — runs as long as condition is true

        int countdown = 5;
        while (countdown > 0) {
            System.out.println("Launching in " + countdown + "...");
            countdown--;    // Without this line, the loop would run forever!
        }
        System.out.println("Blast off!");


        // ─────────────────────────────────
        // Enhanced for loop (for-each) — loops over arrays or lists

        String[] languages = {"Python", "Java", "JavaScript", "C++"};

        for (String lang : languages) {      // "for each lang in languages"
            System.out.println("Language: " + lang);
        }


        // ─────────────────────────────────
        // Nested loops — a loop inside a loop

        for (int row = 1; row <= 3; row++) {
            for (int col = 1; col <= 3; col++) {
                System.out.print("* ");   // print without newline
            }
            System.out.println();         // move to next line after each row
        }
        // Output:
        // * * *
        // * * *
        // * * *


        // ─────────────────────────────────
        // break and continue

        for (int i = 0; i < 10; i++) {
            if (i == 3) continue;  // skip 3
            if (i == 7) break;     // stop at 7
            System.out.print(i + " ");   // 0 1 2 4 5 6
        }
    }
}',

'java', 7, 15),


(2,
'Methods — Reusable Blocks of Code',

'In Java, a method (what Python calls a function) is a named block of code that performs a specific task. You write it once and call it by name whenever you need it. This is one of the most important principles in programming: Do Not Repeat Yourself (DRY).

A method declaration has four parts: the access modifier (public or private), the return type (what type of value it gives back, or void if it gives nothing back), the method name, and the parameters in parentheses (the inputs it accepts). When a method is declared static, you can call it directly on the class without creating an object first — that is why main is static.

Good methods are small, focused, and clearly named. If a method does more than one thing, consider splitting it into two. A method called calculateTax should calculate tax and nothing else.',

'// Methods in Java
// ─────────────────────────────────────────

public class Main {

    // A method that takes two numbers and returns their sum
    // "static" means we can call it without creating an object
    // "int" is the return type — this method gives back an int
    static int add(int a, int b) {
        return a + b;      // return sends the result back to the caller
    }


    // A method with no return value — "void" means "returns nothing"
    static void printSeparator(int length) {
        for (int i = 0; i < length; i++) {
            System.out.print("-");
        }
        System.out.println();
    }


    // A method that returns a String
    static String getGrade(int score) {
        if (score >= 90) return "A";
        if (score >= 80) return "B";
        if (score >= 70) return "C";
        return "F";
    }


    // Method overloading — same name, different parameters
    static double multiply(double a, double b) {
        return a * b;
    }

    static int multiply(int a, int b, int c) {   // Three ints — different!
        return a * b * c;
    }


    public static void main(String[] args) {

        // Calling the methods
        int sum = add(10, 25);
        System.out.println("Sum: " + sum);       // Sum: 35

        printSeparator(20);                       // --------------------

        String grade = getGrade(85);
        System.out.println("Grade: " + grade);   // Grade: B

        System.out.println(multiply(3.5, 2.0));  // 7.0
        System.out.println(multiply(2, 3, 4));   // 24

    }
}',

'java', 8, 15),


(2,
'Classes and Objects — The Heart of Java',

'Java is an object-oriented language — almost everything in it revolves around classes and objects. A class is a blueprint that describes what something is and what it can do. An object is a specific thing built from that blueprint.

Think of a class as the blueprint for a house, and an object as an actual built house. The blueprint describes the rooms, the doors, the windows. Each house built from that blueprint is its own independent object — changing one house does not affect any other.

A class has fields (its data — like a person''s name and age) and methods (its actions — like introduce() or birthday()). The constructor is a special method that runs when you create a new object, setting up its initial state. You create a new object with the new keyword.',

'// Classes and Objects
// ─────────────────────────────────────────

// The CLASS is the blueprint
class Student {

    // Fields — the data each Student object holds
    String name;
    int    age;
    String course;
    double gpa;


    // Constructor — runs when you do "new Student(...)"
    // Sets the initial state of the object
    Student(String name, int age, String course) {
        this.name   = name;    // "this.name" = the object''s field
        this.age    = age;     // "name"      = the parameter passed in
        this.course = course;
        this.gpa    = 0.0;
    }


    // Methods — what a Student can DO
    void introduce() {
        System.out.println("Hi! I am " + name + ", studying " + course + ".");
    }

    String getGrade() {
        if (gpa >= 3.7) return "A";
        if (gpa >= 3.0) return "B";
        if (gpa >= 2.0) return "C";
        return "F";
    }

    void setGPA(double newGPA) {
        if (newGPA >= 0 && newGPA <= 4.0) {
            this.gpa = newGPA;
        } else {
            System.out.println("GPA must be between 0 and 4.");
        }
    }
}


public class Main {
    public static void main(String[] args) {

        // Creating objects from the blueprint using "new"
        Student ahmed = new Student("Ahmed", 20, "Computer Science");
        Student sara  = new Student("Sara",  22, "Data Science");

        // Each object is independent — changing ahmed does NOT affect sara
        ahmed.setGPA(3.8);
        sara.setGPA(3.5);

        ahmed.introduce();                         // Hi! I am Ahmed, studying Computer Science.
        System.out.println("Grade: " + ahmed.getGrade());  // Grade: A

        sara.introduce();                          // Hi! I am Sara, studying Data Science.
        System.out.println("GPA: " + sara.gpa);   // GPA: 3.5
    }
}',

'java', 9, 15),


(2,
'ArrayList — Dynamic Lists in Java',

'Java arrays have a fixed size — once you create an array of 5 elements, it stays 5 elements forever. ArrayList solves this by giving you a resizable list that grows and shrinks automatically. You can add items, remove them, search for them, and sort them with built-in methods.

ArrayList is part of the Java Collections Framework. To use it, you import it from java.util. You specify the type of items it holds in angle brackets — for example ArrayList<String> holds strings, and ArrayList<Integer> holds integers.

ArrayList is one of the most commonly used data structures in Java programs. If you find yourself working with a list of items where the count can change, ArrayList is almost always the right choice.',

'// ArrayList — a dynamic, resizable list
// ─────────────────────────────────────────

import java.util.ArrayList;
import java.util.Collections;

public class Main {
    public static void main(String[] args) {

        // Create an ArrayList that holds Strings
        ArrayList<String> languages = new ArrayList<>();

        // Adding items
        languages.add("Python");
        languages.add("Java");
        languages.add("JavaScript");
        languages.add("C++");
        System.out.println(languages);   // [Python, Java, JavaScript, C++]


        // ─────────────────────────────────
        // Reading items
        System.out.println(languages.get(0));    // Python  (index starts at 0)
        System.out.println(languages.size());    // 4


        // ─────────────────────────────────
        // Checking and searching
        System.out.println(languages.contains("Java"));    // true
        System.out.println(languages.indexOf("C++"));      // 3


        // ─────────────────────────────────
        // Removing items
        languages.remove("C++");           // remove by value
        languages.remove(0);               // remove by index (removes "Python")
        System.out.println(languages);     // [Java, JavaScript]


        // ─────────────────────────────────
        // Looping over an ArrayList

        ArrayList<Integer> scores = new ArrayList<>();
        scores.add(85);
        scores.add(92);
        scores.add(78);
        scores.add(95);

        int total = 0;
        for (int score : scores) {         // enhanced for loop works on ArrayList too
            total += score;
        }
        double average = (double) total / scores.size();
        System.out.println("Average: " + average);   // Average: 87.5


        // ─────────────────────────────────
        // Sorting
        Collections.sort(scores);
        System.out.println("Sorted: " + scores);    // Sorted: [78, 85, 92, 95]
    }
}',

'java', 10, 15);


-- ─────────────────────────────────────────────────────
-- Update the lesson COUNT on the courses table so the
-- "42 lessons" shown on the courses page is accurate.
-- ─────────────────────────────────────────────────────

UPDATE courses SET lessons = 10 WHERE id = 1;  -- Python
UPDATE courses SET lessons = 10 WHERE id = 2;  -- Java
UPDATE courses SET lessons = 10 WHERE id = 3;  -- JavaScript
