-- ============================================================
-- CODER — more_lessons_v4a.sql
-- Python lessons 11-20  |  JavaScript lessons 11-20
-- Import AFTER v2 and v3
-- ============================================================

USE coder_db;

-- ═══════════════════════════════════════════════════════════
--  PYTHON — lessons 11 to 20  (course_id = 1)
-- ═══════════════════════════════════════════════════════════

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(1, 'List Comprehensions — Python''s Superpower',
'A list comprehension is a compact way to build a new list by transforming or filtering an existing one — all in a single readable line. Instead of writing a for loop, creating an empty list, and appending to it, you write exactly what you want in one expression.

The syntax is: [expression for item in iterable if condition]. The if part is optional — leave it out if you want every item. The expression is what you want each item in the new list to be. This is not just shorter — it is actually faster than a regular loop because Python optimises list comprehensions internally.

You can also write nested list comprehensions for working with 2D data like matrices, but keep them simple — if a comprehension is hard to read, use a regular loop instead. Readability is always more important than cleverness.',
'# List Comprehensions in Python
# ─────────────────────────────────

# ── The problem they solve ────────────────────────
# Old way: 4 lines to double every number
doubled_old = []
for n in [1, 2, 3, 4, 5]:
    doubled_old.append(n * 2)

# New way: 1 line
doubled = [n * 2 for n in [1, 2, 3, 4, 5]]
print(doubled)   # [2, 4, 6, 8, 10]


# ── With a filter condition ───────────────────────
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

evens  = [n for n in numbers if n % 2 == 0]
odds   = [n for n in numbers if n % 2 != 0]
big    = [n for n in numbers if n > 5]

print(evens)   # [2, 4, 6, 8, 10]
print(odds)    # [1, 3, 5, 7, 9]
print(big)     # [6, 7, 8, 9, 10]


# ── Transform and filter at once ──────────────────
words = ["hello", "world", "python", "is", "great"]

# Uppercase words longer than 3 characters
long_upper = [w.upper() for w in words if len(w) > 3]
print(long_upper)   # [''HELLO'', ''WORLD'', ''PYTHON'', ''GREAT'']


# ── Practical examples ────────────────────────────
# Square roots of perfect squares under 100
import math
squares = [i for i in range(1, 101) if math.sqrt(i) == int(math.sqrt(i))]
print(squares)   # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

# Extract email domains
emails = ["ahmed@gmail.com", "sara@yahoo.com", "omar@gmail.com"]
domains = [e.split("@")[1] for e in emails]
print(domains)   # [''gmail.com'', ''yahoo.com'', ''gmail.com'']

# Flatten a 2D list
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [num for row in matrix for num in row]
print(flat)   # [1, 2, 3, 4, 5, 6, 7, 8, 9]


# ── Dictionary and set comprehensions too ─────────
scores = {"Ahmed": 92, "Sara": 85, "Omar": 78, "Fatima": 95}

# Only students who passed (>= 80)
passed = {name: score for name, score in scores.items() if score >= 80}
print(passed)   # {''Ahmed'': 92, ''Sara'': 85, ''Fatima'': 95}

# Unique first letters
names = ["Ahmed", "Ali", "Sara", "Sana", "Omar"]
first_letters = {name[0] for name in names}   # set comprehension
print(first_letters)   # {''A'', ''S'', ''O''}',
'python', 11, 20),


(1, 'Dictionaries — The Most Useful Data Structure',
'A dictionary stores data as key-value pairs. Every key maps to a value — like a real dictionary where a word (key) maps to a definition (value). Keys must be unique and immutable (strings and numbers work great). Values can be anything: strings, numbers, lists, even other dictionaries.

Dictionaries are used everywhere in Python: JSON data from APIs comes in as a dictionary. Function keyword arguments are stored as a dictionary. Object attributes in classes are stored in a dictionary. Understanding dictionaries deeply makes you a much more effective Python programmer.

The most important methods to know: .get() for safe access (returns None instead of crashing on missing keys), .items() to loop over both key and value, .update() to merge another dictionary in, and .setdefault() to set a value only if the key does not already exist.',
'# Dictionaries — Deep Dive
# ─────────────────────────────────

# ── Creating dictionaries ─────────────────────────
student = {
    "name":   "Ahmed",
    "age":    20,
    "grades": [85, 92, 78, 95],
    "active": True
}

# ── Access — use .get() to avoid KeyError ─────────
print(student["name"])                # Ahmed — direct access
print(student.get("name"))           # Ahmed — safe access
print(student.get("gpa", "N/A"))     # N/A   — default if missing
# print(student["gpa"])              # KeyError! — crashes

# ── Modify ────────────────────────────────────────
student["age"] = 21                  # update existing
student["email"] = "a@email.com"     # add new key
del student["active"]                # delete a key

# ── Check if key exists ───────────────────────────
if "email" in student:
    print("Has email:", student["email"])


# ── Looping over a dictionary ─────────────────────
print("\nAll student data:")
for key, value in student.items():   # .items() gives (key, value) tuples
    print(f"  {key}: {value}")

print("\nKeys:  ", list(student.keys()))
print("Values:", list(student.values()))


# ── Practical: count word frequency ──────────────
text = "the cat sat on the mat the cat"
freq = {}
for word in text.split():
    freq[word] = freq.get(word, 0) + 1   # increment or start at 0
print(freq)
# {''the'': 3, ''cat'': 2, ''sat'': 1, ''on'': 1, ''mat'': 1}

# Cleaner with setdefault:
freq2 = {}
for word in text.split():
    freq2.setdefault(word, 0)
    freq2[word] += 1


# ── Nested dictionaries — real-world JSON shape ───
users = {
    1: {"username": "ahmed", "xp": 1500, "courses": ["python", "sql"]},
    2: {"username": "sara",  "xp": 800,  "courses": ["javascript"]},
}

print(users[1]["username"])           # ahmed
print(users[1]["courses"][0])         # python

# Add a new user
users[3] = {"username": "omar", "xp": 200, "courses": []}

# Loop and display
for uid, data in users.items():
    print(f"User {uid}: {data[''username'']} — {data[''xp'']} XP")',
'python', 12, 20),


(1, 'Exception Handling — Writing Crash-Proof Code',
'An exception is an error that happens while your program is running. Without handling them, a single bad input crashes your entire program. Exception handling lets you anticipate what can go wrong, deal with it gracefully, and keep the program running.

The try/except block is the main tool. Code inside try runs normally. If an exception occurs, Python jumps to the matching except block instead of crashing. You can catch specific exceptions by name — ValueError (wrong type of value), FileNotFoundError, ZeroDivisionError, KeyError — or catch all exceptions with a bare except, though that is usually a bad idea since it hides bugs.

The else block runs only if NO exception occurred — useful for code that should only run when the try succeeded. The finally block ALWAYS runs, no matter what — perfect for cleanup like closing files or database connections.',
'# Exception Handling in Python
# ─────────────────────────────────

# ── Basic try/except ──────────────────────────────
try:
    number = int(input("Enter a number: "))
    result = 100 / number
    print("Result:", result)
except ValueError:
    print("Error: Please enter a valid number, not text.")
except ZeroDivisionError:
    print("Error: Cannot divide by zero!")


# ── Catch multiple exception types together ───────
try:
    data = [1, 2, 3]
    print(data[10])              # IndexError
except (IndexError, KeyError) as e:
    print(f"Access error: {e}")


# ── else and finally ──────────────────────────────
try:
    result = int("42")
except ValueError:
    print("Conversion failed")
else:
    # Only runs if NO exception occurred
    print("Conversion succeeded:", result)   # prints this
finally:
    # ALWAYS runs — use for cleanup
    print("Done (always printed)")


# ── Raising your own exceptions ───────────────────
def set_age(age):
    if not isinstance(age, int):
        raise TypeError("Age must be an integer")
    if age < 0 or age > 150:
        raise ValueError(f"Age {age} is not a valid human age")
    return age

try:
    set_age(-5)
except ValueError as e:
    print("Caught:", e)   # Caught: Age -5 is not a valid human age


# ── Creating custom exceptions ────────────────────
class InsufficientFundsError(Exception):
    def __init__(self, amount, balance):
        self.amount  = amount
        self.balance = balance
        super().__init__(f"Cannot withdraw ${amount}. Balance is only ${balance}.")

class BankAccount:
    def __init__(self, balance):
        self.balance = balance

    def withdraw(self, amount):
        if amount > self.balance:
            raise InsufficientFundsError(amount, self.balance)
        self.balance -= amount
        return self.balance

account = BankAccount(100)
try:
    account.withdraw(150)
except InsufficientFundsError as e:
    print(e)   # Cannot withdraw $150. Balance is only $100.',
'python', 13, 20),


(1, 'File Handling — Reading and Writing Files',
'Your programs can read data from files and write results back — this is how real applications work. Python''s built-in open() function gives you a file object to read from or write to. The most important thing: always close the file when you are done. The with statement does this automatically, even if an exception occurs — always use with when working with files.

Reading modes: ''r'' reads text (the default), ''rb'' reads binary data. Writing modes: ''w'' writes (overwrites any existing content), ''a'' appends to the end of an existing file, ''x'' creates a new file and fails if it already exists. ''r+'' opens for both reading and writing.

For structured data, Python''s csv module handles comma-separated files automatically, and json.dump/json.load handles JSON — the format used by virtually every web API.',
'# File Handling in Python
# ─────────────────────────────────
import json
import csv
import os

# ── Writing a text file ───────────────────────────
# ''with'' automatically closes the file — always use it
with open("students.txt", "w") as f:
    f.write("Ahmed,92\n")
    f.write("Sara,85\n")
    f.write("Omar,78\n")

print("File written.")


# ── Reading the entire file at once ───────────────
with open("students.txt", "r") as f:
    content = f.read()
print(content)

# ── Reading line by line (memory-efficient) ───────
with open("students.txt", "r") as f:
    for line in f:
        name, score = line.strip().split(",")
        print(f"{name} scored {score}")


# ── Appending to a file ───────────────────────────
with open("students.txt", "a") as f:
    f.write("Fatima,95\n")


# ── Safe reading — handle missing file ───────────
try:
    with open("missing.txt", "r") as f:
        data = f.read()
except FileNotFoundError:
    print("File not found — creating it.")
    with open("missing.txt", "w") as f:
        f.write("created\n")


# ── JSON — the data format of the internet ────────
# Writing Python data as JSON
student_data = {
    "name": "Ahmed",
    "scores": [85, 92, 78],
    "passed": True
}

with open("student.json", "w") as f:
    json.dump(student_data, f, indent=2)   # indent makes it readable

# Reading JSON back into Python
with open("student.json", "r") as f:
    loaded = json.load(f)
print(loaded["name"])     # Ahmed
print(loaded["scores"])   # [85, 92, 78]


# ── CSV — spreadsheet data ────────────────────────
rows = [
    ["Name", "Score", "Grade"],
    ["Ahmed", 92, "A"],
    ["Sara",  85, "B"],
    ["Omar",  78, "C"],
]

with open("grades.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(rows)

with open("grades.csv", "r") as f:
    reader = csv.DictReader(f)   # reads each row as a dict
    for row in reader:
        print(f"{row[''Name'']}: {row[''Grade'']}")

# Cleanup
for fname in ["students.txt", "student.json", "grades.csv", "missing.txt"]:
    if os.path.exists(fname):
        os.remove(fname)',
'python', 14, 20),


(1, 'Modules and Packages — Organising Real Projects',
'A module is simply a Python file. Any .py file is a module. You import it with import. Python comes with a huge standard library of built-in modules — math, random, datetime, os, sys, re — and the Python Package Index (PyPI) has hundreds of thousands of third-party packages you can install with pip.

When you write import math, Python searches for math.py (or a math package) in your current directory first, then in the standard library, then in installed packages. The as keyword gives a module a shorter alias — import numpy as np is universal convention.

For your own projects with multiple files, packages let you organise related modules into folders. A folder becomes a package when it contains an __init__.py file (which can be empty). This is how all large Python projects — Django, Flask, NumPy — are structured.',
'# Modules and Packages
# ─────────────────────────────────

# ── Built-in standard library modules ────────────
import math
import random
import datetime
import os
import sys

# math — mathematical functions
print(math.sqrt(144))        # 12.0
print(math.pi)               # 3.14159...
print(math.ceil(4.2))        # 5
print(math.floor(4.9))       # 4
print(math.pow(2, 10))       # 1024.0

# random — random number generation
print(random.randint(1, 100))       # random int between 1 and 100
print(random.choice(["A","B","C"])) # random item from list
items = [1, 2, 3, 4, 5]
random.shuffle(items)               # shuffle in place
print(items)

# datetime — dates and times
now = datetime.datetime.now()
print(now.strftime("%Y-%m-%d %H:%M"))   # "2026-06-16 14:30"

today    = datetime.date.today()
birthday = datetime.date(2006, 6, 16)
age_days = (today - birthday).days
print(f"Age in days: {age_days}")

# os — operating system interactions
print(os.getcwd())           # current working directory
print(os.path.exists("file.txt"))   # True/False
files = os.listdir(".")      # list files in current directory


# ── Import specific names to avoid prefix ─────────
from math import sqrt, pi, factorial
print(sqrt(81))       # 9.0  — no math. prefix needed
print(factorial(10))  # 3628800


# ── Aliases — standard conventions ───────────────
import datetime as dt
import os.path as osp

print(dt.datetime.now().year)
print(osp.join("folder", "file.txt"))   # folder/file.txt  (OS-aware)


# ── Installing third-party packages with pip ─────
# Run in terminal (NOT in Python):
# pip install requests
# pip install pandas
# pip install flask

# Then use them:
# import requests
# response = requests.get("https://api.github.com")
# print(response.json())


# ── Creating your own module ──────────────────────
# Save this as utils.py:
#
#   def greet(name):
#       return f"Hello, {name}!"
#
#   PI = 3.14159
#
# Then in another file:
#   import utils
#   print(utils.greet("Ahmed"))
#   print(utils.PI)


# ── The if __name__ == "__main__" guard ───────────
# Code under this only runs when YOU run this file directly
# It does NOT run when another file imports this module
def add(a, b):
    return a + b

if __name__ == "__main__":
    # This block runs only when executing this file directly
    print("Running directly:", add(3, 4))
    print("Python version:", sys.version)',
'python', 15, 20),


(1, 'Decorators — Functions That Wrap Functions',
'A decorator is a function that takes another function as input and returns an enhanced version of it. The @ syntax is just shorthand for calling the decorator and replacing the original function with the result. Decorators let you add behaviour to functions without modifying their code — perfect for logging, timing, authentication checks, and caching.

To understand decorators, you first need to know that in Python, functions are objects. You can store them in variables, pass them as arguments, and return them from other functions. A decorator is simply a function that accepts a function and returns a (usually modified) function.

The functools.wraps decorator is something you should always use inside your own decorators — it preserves the original function''s name and docstring so debugging tools can still identify it correctly.',
'# Decorators in Python
# ─────────────────────────────────
import time
import functools


# ── Step 1: Functions are objects ────────────────
def greet(name):
    return f"Hello, {name}!"

say_hello = greet             # store function in a variable
print(say_hello("Ahmed"))     # Hello, Ahmed!


# ── Step 2: A function that accepts a function ───
def loud(func):
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}...")
        result = func(*args, **kwargs)
        print(f"Done.")
        return result
    return wrapper

def add(a, b):
    return a + b

loud_add = loud(add)
print(loud_add(3, 4))


# ── Step 3: The @ syntax does the same thing ─────
@loud                          # equivalent to: greet = loud(greet)
def greet(name):
    return f"Hello, {name}!"

greet("Ahmed")   # prints "Calling greet...", "Hello, Ahmed!", "Done."


# ── Real decorator: measure execution time ────────
def timer(func):
    @functools.wraps(func)     # preserves the original function''s name
    def wrapper(*args, **kwargs):
        start  = time.time()
        result = func(*args, **kwargs)
        end    = time.time()
        print(f"{func.__name__} took {(end - start)*1000:.2f}ms")
        return result
    return wrapper

@timer
def slow_sum(n):
    return sum(range(n))

result = slow_sum(1_000_000)
print("Result:", result)


# ── Real decorator: require login ─────────────────
def require_login(func):
    @functools.wraps(func)
    def wrapper(user, *args, **kwargs):
        if not user.get("logged_in"):
            print("Access denied. Please log in.")
            return None
        return func(user, *args, **kwargs)
    return wrapper

@require_login
def view_dashboard(user):
    print(f"Welcome to dashboard, {user[''name'']}!")

user_logged_in  = {"name": "Ahmed", "logged_in": True}
user_logged_out = {"name": "Guest", "logged_in": False}

view_dashboard(user_logged_in)   # Welcome to dashboard, Ahmed!
view_dashboard(user_logged_out)  # Access denied.


# ── Decorator with arguments ───────────────────────
def repeat(n):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for _ in range(n):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def say(message):
    print(message)

say("Hello!")   # prints "Hello!" three times',
'python', 16, 20),


(1, 'Generators — Memory-Efficient Sequences',
'A generator is a function that produces a sequence of values one at a time, on demand, instead of building the entire list in memory at once. When a generator reaches a yield statement, it pauses, returns the value, and resumes from that exact point next time. This makes generators perfect for large datasets — you can process a file with a billion lines without loading it all into RAM.

The key difference: a list stores all its values in memory at once. A generator stores only the current state and produces the next value when asked. For small datasets, this does not matter. For large ones (log files, database results, infinite sequences), generators are essential.

Generator expressions look exactly like list comprehensions but use parentheses instead of square brackets: (x*2 for x in range(1000000)) creates a generator that produces values one by one — not a list of one million items.',
'# Generators in Python
# ─────────────────────────────────
import sys

# ── The memory difference ─────────────────────────
big_list = [x * 2 for x in range(1_000_000)]    # list: stores 1M items
big_gen  = (x * 2 for x in range(1_000_000))    # generator: stores nothing

print(sys.getsizeof(big_list))   # ~8,448,728 bytes (8 MB)
print(sys.getsizeof(big_gen))    # ~104 bytes!


# ── Generator function with yield ─────────────────
def countdown(n):
    while n > 0:
        yield n         # pause here, return n, resume next call
        n -= 1
    # function ends → generator is exhausted

for num in countdown(5):
    print(num)   # 5, 4, 3, 2, 1


# ── next() — get one value at a time ─────────────
gen = countdown(3)
print(next(gen))   # 3
print(next(gen))   # 2
print(next(gen))   # 1
# next(gen)        # StopIteration — generator is exhausted


# ── Infinite sequence — impossible with a list ────
def integers_from(n):
    while True:         # runs forever — but only produces when asked
        yield n
        n += 1

counter = integers_from(1)
print(next(counter))   # 1
print(next(counter))   # 2
print(next(counter))   # 3
# Takes exactly 0 extra memory no matter how many you request


# ── Practical: read a huge file line by line ──────
def read_large_file(filepath):
    with open(filepath, "r") as f:
        for line in f:
            yield line.strip()   # yields one line at a time

# This works even if the file is 10 GB:
# for line in read_large_file("huge_log.txt"):
#     process(line)


# ── Generator pipeline — chain them together ──────
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

def take(n, gen):
    for _, value in zip(range(n), gen):
        yield value

# First 10 Fibonacci numbers
print(list(take(10, fibonacci())))
# [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]',
'python', 17, 20),


(1, 'Regular Expressions — Pattern Matching',
'A regular expression (regex) is a pattern that describes a set of strings. Instead of checking if a string equals exactly "hello", you can check if it matches a pattern like "any word followed by three digits." This is how form validation, search tools, log parsers, and data extractors work.

Python''s re module handles regular expressions. The most common functions: re.match() checks from the start of the string, re.search() finds a match anywhere, re.findall() returns all matches as a list, re.sub() replaces matches, re.split() splits on a pattern.

The pattern syntax can look intimidating at first but you only need a handful of symbols: . matches any character, \d matches a digit, \w matches a word character, \s matches whitespace, + means one or more, * means zero or more, ? means zero or one, ^ anchors to the start, $ to the end, [] defines a character set.',
'# Regular Expressions in Python
# ─────────────────────────────────
import re

text = "Ahmed was born on 1994-03-15 and his phone is +971-50-123-4567"


# ── re.search — find anywhere in the string ───────
match = re.search(r"\d{4}-\d{2}-\d{2}", text)   # match a date YYYY-MM-DD
if match:
    print("Found date:", match.group())   # 1994-03-15


# ── re.findall — return all matches as a list ─────
numbers = re.findall(r"\d+", text)
print("All numbers:", numbers)   # [''1994'', ''03'', ''15'', ''971'', ''50'', ''123'', ''4567'']


# ── Common patterns ───────────────────────────────
email_pattern   = r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
phone_pattern   = r"\+?[\d\-]{10,}"
url_pattern     = r"https?://[^\s]+"
digits_only     = r"^\d+$"        # ^ start, $ end
word_pattern    = r"\b\w{5,}\b"   # words of 5+ characters

emails = "Contact ahmed@gmail.com or sara@yahoo.com for info"
found_emails = re.findall(email_pattern, emails)
print(found_emails)   # [''ahmed@gmail.com'', ''sara@yahoo.com'']


# ── re.sub — search and replace ───────────────────
# Censor phone numbers
censored = re.sub(r"\d", "*", "+971-50-123-4567")
print(censored)   # +***-**-***-****

# Normalise whitespace
messy = "Hello     world   how   are  you"
clean = re.sub(r"\s+", " ", messy)
print(clean)   # "Hello world how are you"


# ── re.split — split on a pattern ─────────────────
csv_line = "Ahmed,  92 ,  Dubai,  Python"
parts = re.split(r"\s*,\s*", csv_line)   # split on comma with optional spaces
print(parts)   # [''Ahmed'', ''92'', ''Dubai'', ''Python'']


# ── Groups — extract parts of a match ────────────
log = "2026-06-16 14:30:22 ERROR Database connection failed"
pattern = r"(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2}) (\w+) (.+)"

match = re.match(pattern, log)
if match:
    date, time, level, message = match.groups()
    print(f"Date: {date}")      # 2026-06-16
    print(f"Level: {level}")    # ERROR
    print(f"Message: {message}")',
'python', 18, 20),


(1, 'Working with APIs — Fetching Real Data',
'An API (Application Programming Interface) is a way for programs to communicate. Web APIs let your Python script request data from the internet — weather, exchange rates, news, GitHub repositories — and receive it as JSON. The requests library is the standard tool for this: simple, powerful, and almost universally used.

The HTTP GET method asks a server for data. The server responds with a status code (200 = OK, 404 = Not Found, 401 = Unauthorized, 500 = Server Error) and usually a JSON body. requests.get() returns a response object with .status_code, .json(), and .text attributes.

Always handle network errors — the internet is unreliable. Use a try/except block, check the status code before trusting the data, and set a timeout so your program does not hang forever waiting for a response that will never come.',
'# Working with APIs in Python
# ─────────────────────────────────
# Install first:  pip install requests
import requests
import json


# ── Basic GET request ─────────────────────────────
# Public API — no key needed
url = "https://api.github.com/users/torvalds"   # Linus Torvalds'' GitHub

try:
    response = requests.get(url, timeout=10)    # timeout=10 seconds

    if response.status_code == 200:
        data = response.json()                  # parse JSON → Python dict
        print("Name:", data["name"])
        print("Bio:", data["bio"])
        print("Public repos:", data["public_repos"])
        print("Followers:", data["followers"])
    else:
        print(f"Request failed: {response.status_code}")

except requests.exceptions.ConnectionError:
    print("No internet connection")
except requests.exceptions.Timeout:
    print("Request timed out")
except requests.exceptions.RequestException as e:
    print(f"Request error: {e}")


# ── API with query parameters ─────────────────────
# Search GitHub repositories
search_url = "https://api.github.com/search/repositories"
params = {
    "q": "python flask",          # search query
    "sort": "stars",              # sort by stars
    "order": "desc",              # descending
    "per_page": 5                 # limit results
}

response = requests.get(search_url, params=params, timeout=10)
if response.status_code == 200:
    results = response.json()
    print(f"\nTop 5 Flask repos ({results[''total_count'']} total):")
    for repo in results["items"]:
        print(f"  {repo[''full_name'']} — {repo[''stargazers_count''']:,} stars")


# ── POST request — sending data ───────────────────
# Example: creating a resource (JSONPlaceholder is a free test API)
post_url  = "https://jsonplaceholder.typicode.com/posts"
new_post  = {
    "title":  "Learning Python APIs",
    "body":   "This is my first API post from Python!",
    "userId": 1
}

response = requests.post(
    post_url,
    json=new_post,                          # automatically sets Content-Type: application/json
    timeout=10
)
print("\nCreated post, status:", response.status_code)   # 201 Created
created = response.json()
print("New post ID:", created["id"])


# ── Authentication with headers ───────────────────
# Many APIs require a token in the Authorization header
# NEVER hardcode secrets — load from environment variables
import os

token = os.getenv("GITHUB_TOKEN", "")       # load from env, empty if not set
headers = {"Authorization": f"Bearer {token}"} if token else {}

# response = requests.get("https://api.github.com/user", headers=headers, timeout=10)',
'python', 19, 20),


(1, 'Build a Real Project — Student Grade Analyser',
'Everything you have learned — variables, functions, OOP, file handling, exception handling, list comprehensions, dictionaries, and modules — comes together when you build a real project. This lesson builds a complete grade analysis tool that reads student data, computes statistics, finds the top performer, and saves a report to a file.

When building real projects, start by breaking the problem into small functions. Each function should do one thing. Then compose those functions in a main() function. This is called separation of concerns — each piece of code has a single, clear responsibility.

Professional Python projects also follow this pattern: data loading, data processing, data output, wrapped in a main() entry point that only runs when the script is executed directly.',
'# Student Grade Analyser — Full Project
# ─────────────────────────────────────────
import json
import statistics
import os


# ── Data loading ──────────────────────────────────
def load_students(filepath):
    """Load student data from a JSON file."""
    try:
        with open(filepath, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        return []
    except json.JSONDecodeError as e:
        print(f"Error reading file: {e}")
        return []


# ── Data analysis ─────────────────────────────────
def calculate_stats(students):
    """Compute class-wide statistics."""
    all_averages = [
        sum(s["grades"]) / len(s["grades"])
        for s in students
        if s["grades"]
    ]
    return {
        "count":    len(students),
        "mean":     round(statistics.mean(all_averages), 2),
        "median":   round(statistics.median(all_averages), 2),
        "highest":  round(max(all_averages), 2),
        "lowest":   round(min(all_averages), 2),
        "stdev":    round(statistics.stdev(all_averages), 2) if len(all_averages) > 1 else 0,
    }


def get_grade_letter(avg):
    if avg >= 90: return "A"
    if avg >= 80: return "B"
    if avg >= 70: return "C"
    if avg >= 60: return "D"
    return "F"


def analyse_students(students):
    """Add computed fields to each student."""
    results = []
    for s in students:
        avg    = sum(s["grades"]) / len(s["grades"]) if s["grades"] else 0
        letter = get_grade_letter(avg)
        results.append({**s, "average": round(avg, 2), "letter": letter})
    return sorted(results, key=lambda x: x["average"], reverse=True)


# ── Report generation ─────────────────────────────
def save_report(students, stats, filepath):
    """Write a formatted text report."""
    lines = [
        "=" * 45,
        "      STUDENT GRADE REPORT",
        "=" * 45,
        f"Total students:  {stats[''count'']}",
        f"Class average:   {stats[''mean'']}",
        f"Median:          {stats[''median'']}",
        f"Highest average: {stats[''highest'']}",
        f"Lowest average:  {stats[''lowest'']}",
        "=" * 45,
        "",
        f"{'Rank':<5} {'Name':<20} {'Avg':>6} {'Grade':>6}",
        "-" * 45,
    ]
    for rank, s in enumerate(students, 1):
        lines.append(f"{rank:<5} {s[''name'']:<20} {s[''average'']:>6.1f} {s[''letter'']:>6}")
    lines += ["", f"Top performer: {students[0][''name'']} ({students[0][''average'']})" if students else ""]

    with open(filepath, "w") as f:
        f.write("\n".join(lines))
    print(f"Report saved to {filepath}")


# ── Main entry point ──────────────────────────────
def main():
    # Create sample data
    sample_data = [
        {"name": "Ahmed",   "grades": [92, 88, 95, 91, 87]},
        {"name": "Sara",    "grades": [78, 82, 79, 85, 80]},
        {"name": "Omar",    "grades": [65, 70, 68, 72, 69]},
        {"name": "Fatima",  "grades": [95, 98, 92, 96, 94]},
        {"name": "Khalid",  "grades": [55, 60, 58, 62, 57]},
    ]

    # Save sample data
    with open("students.json", "w") as f:
        json.dump(sample_data, f, indent=2)

    # Run analysis
    students   = load_students("students.json")
    analysed   = analyse_students(students)
    stats      = calculate_stats(students)
    save_report(analysed, stats, "report.txt")

    # Print to console
    print(f"\nClass of {stats[''count'']} students | Average: {stats[''mean'']}")
    print(f"Top student: {analysed[0][''name'']} with {analysed[0][''average'']} ({analysed[0][''letter'']})")

    # Cleanup
    for f in ["students.json", "report.txt"]:
        if os.path.exists(f): os.remove(f)


if __name__ == "__main__":
    main()',
'python', 20, 20),


-- ═══════════════════════════════════════════════════════════
--  JAVASCRIPT — lessons 11 to 20  (course_id = 3)
-- ═══════════════════════════════════════════════════════════

(3, 'Destructuring — Extract Values Elegantly',
'Destructuring lets you unpack values from arrays or properties from objects into individual variables in a single line. Before destructuring, extracting multiple values from an object or array required separate assignments. With destructuring, you declare all your variables and extract all values in one clean statement.

Array destructuring extracts values by position. Object destructuring extracts by name — the order does not matter, only the key names. You can set default values for variables that might not exist, rename variables during destructuring with a colon, and skip items with an empty comma slot.

Destructuring is everywhere in modern JavaScript: function parameters (especially React props), import statements, API responses, and swap operations. Once you start using it, the old way feels unnecessarily verbose.',
'// Destructuring in JavaScript
// ─────────────────────────────────

// ── Array destructuring ───────────────────────────
const coords = [10, 20, 30];

const [x, y, z] = coords;   // extract by position
console.log(x, y, z);       // 10 20 30

// Skip items with empty slot
const [first, , third] = [1, 2, 3];
console.log(first, third);   // 1 3

// Swap two variables — classic trick
let a = 1, b = 2;
[a, b] = [b, a];
console.log(a, b);   // 2 1


// ── Object destructuring ───────────────────────────
const user = {
    username: "ahmed",
    email:    "ahmed@email.com",
    xp:       1500,
    role:     "admin"
};

const { username, xp } = user;           // extract by name
console.log(username, xp);               // ahmed 1500

// Rename during destructuring
const { username: name, xp: points } = user;
console.log(name, points);               // ahmed 1500

// Default values
const { username: u, level = 1 } = user;   // level not in user → uses default
console.log(u, level);                      // ahmed 1


// ── Destructuring function parameters ────────────
function displayUser({ username, xp, role = "student" }) {
    console.log(`${username} — ${xp} XP (${role})`);
}
displayUser(user);   // ahmed — 1500 XP (admin)
displayUser({ username: "sara", xp: 200 });   // sara — 200 XP (student)


// ── Nested destructuring ──────────────────────────
const response = {
    status: 200,
    data: {
        user:    { id: 1, name: "Ahmed" },
        lessons: [101, 102, 103],
    }
};

const { data: { user: { name: userName }, lessons: [firstLesson] } } = response;
console.log(userName, firstLesson);   // Ahmed 101


// ── Rest in destructuring ──────────────────────────
const [head, ...tail] = [1, 2, 3, 4, 5];
console.log(head);   // 1
console.log(tail);   // [2, 3, 4, 5]

const { username: uname, ...rest } = user;
console.log(uname);   // ahmed
console.log(rest);    // { email, xp, role }',
'javascript', 11, 20),


(3, 'Spread, Rest, and Modern Array Methods',
'The spread operator (...) expands an iterable (array, string, object) into individual elements. The rest operator uses the same syntax but does the opposite — it collects multiple elements into one array or object. Same three dots, opposite meaning depending on context.

Spread is used to: copy arrays without reference sharing, merge arrays and objects, pass an array as individual function arguments. Rest is used to: collect remaining function arguments into an array, collect remaining object properties into a new object.

Modern array methods — map, filter, reduce, find, some, every, flat, flatMap — are the core tools for working with data in JavaScript. Together with spread/rest and destructuring, they replace most for loops with clear, declarative code that reads almost like English.',
'// Spread, Rest, and Array Methods
// ─────────────────────────────────

// ── Spread: copy an array without sharing reference ──
const original = [1, 2, 3];
const copy      = [...original];   // real copy — not the same array
copy.push(4);
console.log(original);   // [1, 2, 3] — unchanged
console.log(copy);       // [1, 2, 3, 4]

// Merge arrays
const a = [1, 2];
const b = [3, 4];
const merged = [...a, ...b, 5];   // [1, 2, 3, 4, 5]

// Spread with functions
const nums = [5, 2, 8, 1, 9];
console.log(Math.max(...nums));   // 9 — spread passes each element as an arg


// ── Spread: copy/merge objects ─────────────────────
const defaults = { theme: "dark", lang: "en", notifications: true };
const userPrefs = { lang: "ar", fontSize: 16 };

// Merge — later keys overwrite earlier ones
const settings = { ...defaults, ...userPrefs };
console.log(settings);
// { theme: "dark", lang: "ar", notifications: true, fontSize: 16 }


// ── Rest: collect remaining arguments ─────────────
function sum(...numbers) {      // rest: collects ALL args into an array
    return numbers.reduce((total, n) => total + n, 0);
}
console.log(sum(1, 2, 3, 4, 5));   // 15


// ── Array methods — the data transformation toolkit ─
const students = [
    { name: "Ahmed",  grade: 92, passed: true  },
    { name: "Sara",   grade: 85, passed: true  },
    { name: "Omar",   grade: 58, passed: false },
    { name: "Fatima", grade: 97, passed: true  },
    { name: "Khalid", grade: 45, passed: false },
];

// .map — transform every element
const names = students.map(s => s.name);
console.log(names);   // ["Ahmed", "Sara", "Omar", "Fatima", "Khalid"]

// .filter — keep elements that pass the test
const passed = students.filter(s => s.passed);
console.log(passed.length);   // 3

// .find — first element that matches
const top = students.find(s => s.grade > 95);
console.log(top.name);   // Fatima

// .some / .every
console.log(students.some(s => s.grade > 95));    // true — at least one
console.log(students.every(s => s.passed));        // false — not all passed

// .reduce — collapse to a single value
const totalGrades = students.reduce((sum, s) => sum + s.grade, 0);
const classAvg    = totalGrades / students.length;
console.log("Average:", classAvg.toFixed(1));   // 75.4

// Chain methods — get names of passing students, sorted
const honorRoll = students
    .filter(s => s.grade >= 85)
    .map(s => s.name)
    .sort();
console.log(honorRoll);   // ["Ahmed", "Fatima", "Sara"]',
'javascript', 12, 20),


(3, 'Closures and Scope — How JavaScript Remembers',
'A closure is a function that remembers the variables from the scope where it was created, even after that scope has finished executing. This is not a trick or a bug — it is a fundamental feature of JavaScript that powers private state, event handlers, callbacks, and much of the modern JS ecosystem.

To understand closures, you need to understand scope. Variables declared with let and const have block scope — they only exist within the {} block where they are declared. Variables declared with var have function scope. A function always has access to variables in its own scope AND all enclosing scopes — this is called the scope chain.

A closure is formed when a function reaches out to a variable from an outer scope. The inner function "closes over" that variable, keeping it alive in memory as long as the inner function exists.',
'// Closures and Scope in JavaScript
// ─────────────────────────────────

// ── Scope basics ──────────────────────────────────
let globalVar = "I am global";

function outer() {
    let outerVar = "I am in outer";

    function inner() {
        let innerVar = "I am in inner";
        console.log(globalVar);   // ✓ can access global
        console.log(outerVar);    // ✓ can access outer
        console.log(innerVar);    // ✓ can access own scope
    }
    inner();
    // console.log(innerVar);     // ✗ ERROR — innerVar is not accessible here
}
outer();


// ── Closures: function remembers its birthplace ───
function makeCounter() {
    let count = 0;             // this variable lives on as long as the closure does

    return {
        increment: () => { count++; },
        decrement: () => { count--; },
        getValue:  () => count,
    };
}

const counter = makeCounter();
counter.increment();
counter.increment();
counter.increment();
counter.decrement();
console.log(counter.getValue());   // 2
// count is private — you can''t access it directly


// ── Closures for private state ────────────────────
function createBankAccount(initialBalance) {
    let balance = initialBalance;   // private — not accessible from outside

    return {
        deposit(amount) {
            balance += amount;
            console.log(`Deposited $${amount}. Balance: $${balance}`);
        },
        withdraw(amount) {
            if (amount > balance) return console.log("Insufficient funds");
            balance -= amount;
            console.log(`Withdrew $${amount}. Balance: $${balance}`);
        },
        getBalance() { return balance; }
    };
}

const account = createBankAccount(1000);
account.deposit(500);         // Balance: $1500
account.withdraw(200);        // Balance: $1300
console.log(account.balance); // undefined — truly private!


// ── Classic closure gotcha with var ───────────────
// This is why you should use let, not var, in loops:

// BROKEN with var:
for (var i = 0; i < 3; i++) {
    setTimeout(() => console.log("var:", i), 100);   // prints 3, 3, 3 — all share one i
}

// FIXED with let:
for (let j = 0; j < 3; j++) {
    setTimeout(() => console.log("let:", j), 200);   // prints 0, 1, 2 — each has its own j
}',
'javascript', 13, 20),


(3, 'Promises and Async/Await — Handling Asynchronous Code',
'JavaScript runs in a single thread. When it makes a network request or reads a file, it cannot just stop and wait — that would freeze the entire page. Instead, it registers a callback to be called when the operation finishes and moves on to other work. This is asynchronous programming.

Promises are objects that represent a future value. A Promise is in one of three states: pending (operation in progress), fulfilled (completed successfully), or rejected (failed). You attach handlers with .then() (for success) and .catch() (for failure). Promises can be chained — each .then() returns a new Promise.

Async/await is built on top of Promises but makes the code look synchronous. The async keyword marks a function as asynchronous. Inside it, await pauses execution until the Promise resolves. This eliminates "callback hell" and makes asynchronous code as readable as regular code.',
'// Promises and Async/Await
// ─────────────────────────────────

// ── What a Promise looks like ─────────────────────
const myPromise = new Promise((resolve, reject) => {
    const success = true;      // imagine this is an API call result
    if (success) {
        resolve({ user: "Ahmed", xp: 1500 });   // fulfilled with data
    } else {
        reject(new Error("Failed to load user"));  // rejected with error
    }
});

// .then handles success, .catch handles failure
myPromise
    .then(data => {
        console.log("Got user:", data.user);   // Got user: Ahmed
        return data.xp;                         // pass to next .then
    })
    .then(xp => console.log("XP:", xp))       // XP: 1500
    .catch(err => console.error("Error:", err.message));


// ── Simulate an API fetch with a delay ────────────
function fetchUser(id) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {                         // simulate network delay
            const users = { 1: "Ahmed", 2: "Sara" };
            const name  = users[id];
            if (name) resolve({ id, name });
            else      reject(new Error(`User ${id} not found`));
        }, 500);
    });
}

fetchUser(1).then(u => console.log("Found:", u.name));   // Ahmed
fetchUser(9).catch(e => console.log("Error:", e.message));


// ── Async/Await — cleaner syntax for Promises ─────
async function loadUserData(userId) {
    try {
        const user    = await fetchUser(userId);       // pauses here
        console.log(`Loading data for ${user.name}`);

        // await multiple sequential operations
        const courses = await Promise.resolve(["Python", "JS"]);   // mock
        return { user, courses };

    } catch (err) {
        console.error("Load failed:", err.message);
        return null;
    }
}

loadUserData(1).then(data => {
    if (data) console.log(`${data.user.name} has ${data.courses.length} courses`);
});


// ── Run multiple requests in parallel ─────────────
async function loadAll() {
    // Sequential — slow (waits for each one)
    // const u1 = await fetchUser(1);
    // const u2 = await fetchUser(2);

    // Parallel — fast (both start at the same time)
    const [u1, u2] = await Promise.all([fetchUser(1), fetchUser(2)]);
    console.log(u1.name, u2.name);   // Ahmed Sara
}

loadAll();


// ── Real fetch() with async/await ─────────────────
async function getGithubUser(username) {
    try {
        const response = await fetch(`https://api.github.com/users/${username}`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const data = await response.json();
        console.log(`${data.name} has ${data.public_repos} repos`);
    } catch (err) {
        console.error("GitHub request failed:", err.message);
    }
}
// getGithubUser("torvalds");',
'javascript', 14, 20),


(3, 'The DOM — Building Interactive Pages',
'The DOM (Document Object Model) is a tree of objects that represents your HTML page in memory. JavaScript can read, modify, add, and remove any element, attribute, or text node in this tree — and the browser immediately reflects those changes visually. This is how all interactive websites work.

querySelector and querySelectorAll let you find elements using the same CSS selectors you already know. querySelector finds the first match, querySelectorAll returns a NodeList of all matches. These replaced the older getElementById and getElementsByClassName which you may still see in older code.

Events are the heartbeat of interactive UIs. addEventListener attaches a function (the handler) to an element that fires when a specific event occurs — click, keydown, input, submit, scroll, and many more. The event object passed to the handler contains details about what happened: which key was pressed, where the mouse was, which element triggered it.',
'// The DOM — Making Pages Interactive
// ─────────────────────────────────────
// Imagine this HTML exists on the page:
// <div id="app">
//   <h1 id="title">Welcome</h1>
//   <ul id="list"></ul>
//   <input id="search" placeholder="Search..." />
//   <button id="add-btn">Add Item</button>
// </div>

// ── Finding elements ───────────────────────────────
const title   = document.querySelector("#title");        // by ID
const list    = document.querySelector("#list");
const input   = document.querySelector("#search");
const btn     = document.querySelector("#add-btn");
const allLis  = document.querySelectorAll("li");         // returns NodeList

// ── Reading and changing content ───────────────────
console.log(title.textContent);          // "Welcome"
title.textContent = "Coder Learning Platform";   // changes the visible text

// ── Changing styles and classes ────────────────────
title.style.color    = "#6c63ff";
title.style.fontSize = "2rem";

title.classList.add("highlighted");
title.classList.remove("highlighted");
title.classList.toggle("active");     // add if absent, remove if present
console.log(title.classList.contains("active"));   // true or false

// ── Creating and adding new elements ──────────────
function addItem(text) {
    const li   = document.createElement("li");
    li.textContent = text;
    li.classList.add("list-item");

    // Add a delete button inside the li
    const del = document.createElement("button");
    del.textContent = "✕";
    del.addEventListener("click", () => li.remove());   // closure: remembers li
    li.appendChild(del);

    list.appendChild(li);
}

addItem("Learn variables");
addItem("Build a project");

// ── Handling events ───────────────────────────────
btn.addEventListener("click", () => {
    const text = input.value.trim();
    if (text) {
        addItem(text);
        input.value = "";    // clear the input
        input.focus();       // put cursor back in the box
    }
});

// Submit on Enter key
input.addEventListener("keydown", (event) => {
    if (event.key === "Enter") btn.click();   // programmatically trigger click
});

// ── Live search filter ─────────────────────────────
input.addEventListener("input", (event) => {
    const query = event.target.value.toLowerCase();
    document.querySelectorAll("li").forEach(li => {
        const visible = li.textContent.toLowerCase().includes(query);
        li.style.display = visible ? "" : "none";
    });
});

// ── Event delegation — one listener for many items ─
// Instead of adding a listener to every li, add ONE to the parent
list.addEventListener("click", (event) => {
    if (event.target.tagName === "LI") {
        event.target.classList.toggle("done");
    }
});',
'javascript', 15, 20),


(3, 'Local Storage and Browser APIs',
'The browser gives JavaScript access to powerful APIs beyond just the DOM. Local Storage persists data across page refreshes and browser restarts — it is how websites remember your preferences, dark mode setting, or a half-filled shopping cart without requiring a server. The data lives in the user''s browser until explicitly cleared.

Local Storage has a simple key-value API: setItem, getItem, removeItem, clear. The catch: it only stores strings. To store objects or arrays, convert to JSON with JSON.stringify() before saving and JSON.parse() after reading.

Other important browser APIs: sessionStorage (like localStorage but cleared when the tab closes), the Fetch API (make HTTP requests), the Clipboard API, the Geolocation API, and the Web Storage Events API for syncing changes across tabs.',
'// Browser APIs — localStorage and more
// ─────────────────────────────────────────

// ── localStorage — persist data across sessions ───
// Only stores strings — use JSON for objects
const settings = {
    theme:    "dark",
    fontSize: 16,
    language: "en",
};

// Save
localStorage.setItem("settings", JSON.stringify(settings));
localStorage.setItem("username", "Ahmed");

// Read
const saved    = JSON.parse(localStorage.getItem("settings"));
const username = localStorage.getItem("username");

console.log(saved.theme);   // "dark"
console.log(username);      // "Ahmed"

// Update one field without losing the rest
const current = JSON.parse(localStorage.getItem("settings")) || {};
localStorage.setItem("settings", JSON.stringify({ ...current, fontSize: 18 }));

// Delete one key / clear everything
localStorage.removeItem("username");
// localStorage.clear();   // removes everything


// ── Build a theme toggle that persists ────────────
function initTheme() {
    const theme = localStorage.getItem("theme") || "dark";
    document.documentElement.setAttribute("data-theme", theme);
}

function toggleTheme() {
    const current = localStorage.getItem("theme") || "dark";
    const next    = current === "dark" ? "light" : "dark";
    localStorage.setItem("theme", next);
    document.documentElement.setAttribute("data-theme", next);
}

initTheme();  // call on page load


// ── Build a simple note-taking app ────────────────
const NoteApp = {
    key: "notes",

    getAll() {
        return JSON.parse(localStorage.getItem(this.key)) || [];
    },

    add(text) {
        const notes = this.getAll();
        notes.push({ id: Date.now(), text, created: new Date().toISOString() });
        localStorage.setItem(this.key, JSON.stringify(notes));
    },

    delete(id) {
        const notes = this.getAll().filter(n => n.id !== id);
        localStorage.setItem(this.key, JSON.stringify(notes));
    },

    clear() {
        localStorage.removeItem(this.key);
    }
};

NoteApp.add("Study JavaScript closures");
NoteApp.add("Build the grade analyser");
console.log(NoteApp.getAll().length);   // 2
NoteApp.delete(NoteApp.getAll()[0].id);
console.log(NoteApp.getAll().length);   // 1


// ── Clipboard API — copy to clipboard ─────────────
async function copyToClipboard(text) {
    try {
        await navigator.clipboard.writeText(text);
        console.log("Copied!");
    } catch (err) {
        console.error("Copy failed:", err);
    }
}

// ── Fetch API — HTTP requests from the browser ────
async function loadData(url) {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return response.json();
}

loadData("/api/courses")
    .then(courses => console.log(`Loaded ${courses.length} courses`))
    .catch(err => console.error(err.message));',
'javascript', 16, 20),


(3, 'Error Handling and Defensive Programming',
'Errors are inevitable — users input unexpected data, servers go offline, files are missing, APIs change. The difference between professional code and amateur code is how gracefully it handles these failures. Good error handling means your application tells users what went wrong in plain language and recovers wherever possible, instead of crashing silently or showing a confusing stack trace.

JavaScript has two types of errors: synchronous errors (caught with try/catch) and Promise rejections (caught with .catch() or try/catch inside async functions). Unhandled Promise rejections are one of the most common bugs in modern JavaScript — always add error handling to every async operation.

Custom error classes let you create specific error types for your application domain, making error handling more precise. Instead of catching all errors the same way, you can check the type and respond appropriately.',
'// Error Handling in JavaScript
// ─────────────────────────────────

// ── Synchronous try/catch/finally ─────────────────
function parseJSON(text) {
    try {
        return JSON.parse(text);
    } catch (err) {
        console.error("Invalid JSON:", err.message);
        return null;
    } finally {
        console.log("parseJSON called");   // always runs
    }
}

console.log(parseJSON(''{"name":"Ahmed"}'')); // { name: ''Ahmed'' }
console.log(parseJSON("not json"));          // null (with error message)


// ── Throwing your own errors ───────────────────────
function divide(a, b) {
    if (typeof a !== "number" || typeof b !== "number") {
        throw new TypeError("Both arguments must be numbers");
    }
    if (b === 0) {
        throw new RangeError("Cannot divide by zero");
    }
    return a / b;
}

try {
    console.log(divide(10, 2));    // 5
    console.log(divide(10, 0));    // throws RangeError
} catch (err) {
    if (err instanceof RangeError) {
        console.log("Math error:", err.message);
    } else if (err instanceof TypeError) {
        console.log("Type error:", err.message);
    } else {
        throw err;    // re-throw unexpected errors
    }
}


// ── Custom error classes ───────────────────────────
class ApiError extends Error {
    constructor(message, statusCode) {
        super(message);
        this.name       = "ApiError";
        this.statusCode = statusCode;
    }
}

class ValidationError extends Error {
    constructor(field, message) {
        super(message);
        this.name  = "ValidationError";
        this.field = field;
    }
}

async function fetchUser(id) {
    const res = await fetch(`/api/users/${id}`);
    if (res.status === 404) throw new ApiError("User not found", 404);
    if (!res.ok)            throw new ApiError("Server error", res.status);
    return res.json();
}

async function loadProfile(userId) {
    try {
        const user = await fetchUser(userId);
        return user;
    } catch (err) {
        if (err instanceof ApiError && err.statusCode === 404) {
            return null;   // handle gracefully — user simply does not exist
        }
        throw err;         // re-throw unexpected errors
    }
}


// ── Global error boundary ─────────────────────────
window.addEventListener("unhandledrejection", (event) => {
    console.error("Unhandled Promise rejection:", event.reason);
    event.preventDefault();   // prevent the browser''s default error message
});',
'javascript', 17, 20),


(3, 'ES Modules — Organising Large Projects',
'As JavaScript projects grow, putting all code in one file becomes unmanageable. Modules let you split code into files — each file has its own scope (no global variable pollution), explicitly exports what it wants to share, and explicitly imports what it needs from others.

The export keyword marks what a module makes available. Named exports use the exact name — import { name } from ''./file''. Default exports are the main thing a module exports — import anything from ''./file'' (any name works). A module can have many named exports but only one default export.

ES modules work in browsers natively (with type="module" on the script tag) and in Node.js (with .mjs files or "type": "module" in package.json). They are also the format used by every modern bundler — Vite, Webpack, Rollup.',
'// ES Modules — Organising Code Across Files
// ─────────────────────────────────────────────
// This shows several files that work together.

// ══════════════════════════════════════════════
// FILE: utils/math.js
// ══════════════════════════════════════════════

// Named exports — export multiple things
export function add(a, b) { return a + b; }
export function subtract(a, b) { return a - b; }
export function multiply(a, b) { return a * b; }

export const PI = 3.14159;

// Export all at once (alternative syntax)
// export { add, subtract, multiply, PI };


// ══════════════════════════════════════════════
// FILE: utils/api.js
// ══════════════════════════════════════════════

const BASE_URL = "/api";   // private — not exported

export async function get(endpoint) {
    const res = await fetch(BASE_URL + endpoint);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

export async function post(endpoint, body) {
    const res = await fetch(BASE_URL + endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body:    JSON.stringify(body),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

// Default export — the main thing this module provides
const api = { get, post };
export default api;


// ══════════════════════════════════════════════
// FILE: main.js  (the entry point)
// ══════════════════════════════════════════════

// Named imports — must use the exact exported name
import { add, multiply, PI } from "./utils/math.js";

// Default import — any name works
import api from "./utils/api.js";

// Import everything as a namespace object
import * as MathUtils from "./utils/math.js";

console.log(add(3, 4));           // 7
console.log(multiply(5, PI));     // 15.708
console.log(MathUtils.subtract(10, 3));   // 7

// Use the API module
async function init() {
    const courses = await api.get("/courses");
    console.log(`${courses.length} courses loaded`);
}
init();


// ══════════════════════════════════════════════
// FILE: index.html  — use type="module"
// ══════════════════════════════════════════════
// <script type="module" src="./main.js"></script>
// Now main.js can use import/export
// Each module file has its own scope — no global leaks',
'javascript', 18, 20),


(3, 'Object-Oriented JavaScript — Classes and Prototypes',
'JavaScript''s object system is prototype-based — every object has a hidden link to another object called its prototype. When you access a property, JavaScript first looks on the object itself, then walks up the prototype chain until it finds the property or reaches null. This is different from classical OOP languages like Java, but the ES6 class syntax hides this complexity and gives you familiar class-based syntax.

Classes in JavaScript are syntactic sugar over prototypes. The constructor method sets instance properties. Methods defined in the class body are placed on the prototype — they are shared by all instances, not copied onto each one, which saves memory. Static methods belong to the class itself, not to instances.

Private fields (using the # prefix) are a newer feature that truly enforces encapsulation — unlike the old convention of prefixing private properties with an underscore, which was just a suggestion.',
'// OOP in JavaScript — Classes
// ─────────────────────────────────

class User {
    // Private field — truly inaccessible from outside
    #password;
    #loginCount = 0;

    static userCount = 0;   // shared by all instances

    constructor(username, email, password) {
        this.username   = username;
        this.email      = email;
        this.#password  = password;   // stored privately
        this.xp         = 0;
        this.createdAt  = new Date();
        User.userCount++;
    }

    // Instance method
    completeLesson(xpReward) {
        this.xp += xpReward;
        return this;   // return this enables method chaining
    }

    login(password) {
        this.#loginCount++;
        return this.#password === password;
    }

    getLevel() {
        return Math.floor(this.xp / 100) + 1;
    }

    toString() {
        return `${this.username} — Level ${this.getLevel()} (${this.xp} XP)`;
    }

    // Static method — called on the class, not an instance
    static create(username, email, password) {
        return new User(username, email, password);
    }
}


// ── Inheritance ───────────────────────────────────
class AdminUser extends User {
    #permissions;

    constructor(username, email, password, permissions = []) {
        super(username, email, password);   // call parent constructor
        this.#permissions = permissions;
    }

    canDo(action) {
        return this.#permissions.includes(action);
    }

    // Override parent method
    toString() {
        return `[ADMIN] ${super.toString()}`;   // super.toString() calls parent''s version
    }
}


// ── Usage ─────────────────────────────────────────
const ahmed = new User("ahmed", "ahmed@email.com", "secret");
ahmed.completeLesson(15).completeLesson(20).completeLesson(10);   // chaining
console.log(ahmed.toString());     // ahmed — Level 1 (45 XP)
console.log(ahmed.login("secret")); // true

const admin = new AdminUser("sara", "sara@email.com", "pass", ["delete", "ban"]);
admin.completeLesson(200);
console.log(admin.toString());           // [ADMIN] sara — Level 3 (200 XP)
console.log(admin.canDo("delete"));      // true
console.log(admin.canDo("hack"));        // false

console.log(User.userCount);             // 2 — static field on the class
// console.log(ahmed.#password);         // SyntaxError — private!',
'javascript', 19, 20),


(3, 'Build a Real Project — Interactive Quiz App',
'This lesson builds a complete quiz application that demonstrates everything from this course: DOM manipulation, events, closures, classes, local storage, modules, and async patterns. Build it step by step — reading through it will cement the concepts better than reading explanations alone.

The architecture: a Quiz class manages state (questions, current index, score). Event handlers update the DOM when the user answers. Results are saved to localStorage so the user can see their history. The code is organised into clear functions with a single responsibility each.',
'// Interactive Quiz App — Full Project
// ─────────────────────────────────────────

// ── Quiz data ─────────────────────────────────────
const questions = [
    {
        question: "What does === check in JavaScript?",
        options:  ["Value only", "Type only", "Value and type", "Neither"],
        answer:   2,
        explanation: "=== is strict equality — it checks both value AND type."
    },
    {
        question: "Which method adds an item to the END of an array?",
        options:  ["shift()", "unshift()", "push()", "pop()"],
        answer:   2,
        explanation: "push() adds to the end. pop() removes from the end."
    },
    {
        question: "What does async/await replace?",
        options:  ["Variables", "Loops", ".then()/.catch() chains", "Classes"],
        answer:   2,
        explanation: "async/await is syntactic sugar over Promise .then/.catch chains."
    },
    {
        question: "Where does localStorage data survive?",
        options:  ["Only the current tab", "Page refreshes", "Browser reinstalls", "Never"],
        answer:   1,
        explanation: "localStorage survives page refreshes but not clearing browser data."
    },
    {
        question: "What is a closure?",
        options:  [
            "A way to close the browser",
            "A function that remembers its outer scope",
            "A loop that never ends",
            "An HTML closing tag"
        ],
        answer:   1,
        explanation: "A closure is a function that retains access to variables from where it was created."
    },
];

// ── Quiz class — manages all state ────────────────
class Quiz {
    #questions;
    #index   = 0;
    #score   = 0;
    #answers = [];

    constructor(questions) {
        this.#questions = [...questions];  // copy so we can shuffle
        this.#shuffle();
    }

    #shuffle() {
        for (let i = this.#questions.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [this.#questions[i], this.#questions[j]] = [this.#questions[j], this.#questions[i]];
        }
    }

    get current()     { return this.#questions[this.#index]; }
    get index()       { return this.#index; }
    get total()       { return this.#questions.length; }
    get score()       { return this.#score; }
    get isFinished()  { return this.#index >= this.#questions.length; }
    get percentage()  { return Math.round((this.#score / this.total) * 100); }

    answer(optionIndex) {
        const correct = optionIndex === this.current.answer;
        if (correct) this.#score++;
        this.#answers.push({ question: this.current.question, correct, chosen: optionIndex });
        this.#index++;
        return correct;
    }

    saveResult() {
        const history = JSON.parse(localStorage.getItem("quiz_history") || "[]");
        history.unshift({ date: new Date().toLocaleString(), score: this.#score, total: this.total });
        if (history.length > 10) history.pop();   // keep last 10
        localStorage.setItem("quiz_history", JSON.stringify(history));
    }
}

// ── UI rendering functions ─────────────────────────
const quiz = new Quiz(questions);

function render() {
    const app = document.getElementById("quiz-app");
    if (!app) return;

    if (quiz.isFinished) {
        quiz.saveResult();
        app.innerHTML = `
            <h2>Quiz Complete!</h2>
            <p style="font-size:2rem; font-weight:700;">${quiz.score}/${quiz.total}</p>
            <p>${quiz.percentage}% — ${quiz.percentage >= 80 ? "Excellent!" : quiz.percentage >= 60 ? "Good job!" : "Keep practising!"}</p>
            <button onclick="location.reload()">Try Again</button>`;
        return;
    }

    const q = quiz.current;
    app.innerHTML = `
        <p>Question ${quiz.index + 1} of ${quiz.total}</p>
        <h3>${q.question}</h3>
        <div class="options">
            ${q.options.map((opt, i) => `
                <button class="option" data-index="${i}">${opt}</button>
            `).join("")}
        </div>`;

    app.querySelectorAll(".option").forEach(btn => {
        btn.addEventListener("click", () => {
            const chosen  = parseInt(btn.dataset.index);
            const correct = quiz.answer(chosen);
            btn.style.background = correct ? "#43e97b" : "#ff6b6b";
            app.querySelectorAll(".option").forEach(b => b.disabled = true);
            setTimeout(render, 1000);   // move to next question after 1s
        });
    });
}

document.addEventListener("DOMContentLoaded", render);',
'javascript', 20, 20);


-- ── Update lesson counts ─────────────────────────────────────
UPDATE courses SET lessons = 20 WHERE id = 1;   -- Python
UPDATE courses SET lessons = 20 WHERE id = 3;   -- JavaScript
