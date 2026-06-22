-- =============================================================
-- CODER — foundations_course.sql
-- A new "Programming Foundations" course that teaches HOW code
-- actually runs — not just syntax. Twelve deep lessons designed
-- to be read before any language-specific track.
--
-- Import via phpMyAdmin: coder_db → Import → choose this file → Go
-- Safe to re-run (uses INSERT IGNORE / cleans its own lessons).
-- =============================================================

USE coder_db;

-- ── 1. Insert the course (only if it doesn't already exist) ──
INSERT IGNORE INTO courses
  (title, description, language, level, duration, lessons, icon, color)
VALUES
  ('Programming Foundations',
   'Before you learn any language, learn what code actually is. This course teaches how a computer reads your program, what memory looks like, why functions work, how errors happen — and why every language you ever learn afterwards will suddenly make sense.',
   'python',
   'Beginner',
   '4 weeks',
   12,
   'fas fa-microchip',
   '#10b981');

-- Resolve the course id we just inserted (or that already existed)
SET @fc_id := (SELECT id FROM courses WHERE title = 'Programming Foundations' LIMIT 1);

-- Wipe any prior lessons for this course so this script can be re-run safely
DELETE FROM lessons WHERE course_id = @fc_id;

-- ── 2. Insert the twelve foundation lessons ─────────────────

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@fc_id,
 'What is Code, Really?',
 'Code is just text. That is the first and most important thing to understand. When you write a program, you are writing plain characters in a text file — nothing magical. What makes it "code" is that another program (a compiler or an interpreter) knows how to read those characters and turn them into instructions a computer can actually run.\r\n\r\nEvery programming language you will ever see — Python, JavaScript, C++, Java — is just a set of rules for how those characters should look so that another program can understand them. The computer itself does not understand "print" or "if" or "while". It only understands tiny numeric instructions like "add these two numbers" or "move this byte". The job of the language is to bridge the gap between the way humans think and what the machine can actually do.\r\n\r\nWhen you read someone else''s code, you are reading their thinking. When you write code, you are explaining a process to two audiences at once: the computer (which is very strict) and the next human who will read it (which might be you in six months).',
 '# Open any code file in a plain text editor — Notepad, TextEdit, anything.
# You will see ONLY text. There is nothing hidden.
#
# The line below is just 22 characters. The Python interpreter
# reads those characters, understands what they mean, and runs them.

print("I am just text!")

# Try changing the message. The file is text. You are editing text.
# When you press Run, another program reads this text and acts on it.',
 'python', 1, 10),

(@fc_id,
 'How a Computer Actually Runs a Program',
 'A computer has three things you need to know about: a CPU (the processor), RAM (memory), and storage (your disk or SSD). Storage holds files when the computer is off. RAM is a working space that exists only when the computer is on. The CPU is the part that actually does work — it reads instructions and performs them, one at a time, billions of times per second.\r\n\r\nWhen you run a program, this happens: the operating system loads the program''s instructions from storage into RAM. The CPU then reads those instructions from RAM one by one. Each instruction is a tiny step — "add 5 to this number", "compare these two values", "jump to a different instruction if they''re equal". Your "print Hello" line is not one instruction to the CPU — it is dozens of tiny ones, all happening in a fraction of a millisecond.\r\n\r\nUnderstanding this fixes a lot of confusion later. Why is your program slow? Because the CPU has too many instructions to run, or it is waiting on something slower (like the disk or the network). Why does it crash? Because it told the CPU to do something invalid, like read memory it does not own. Everything in programming eventually comes back to: instructions, memory, and the CPU running them.',
 '# This Python program is short. But under the hood, the CPU runs
# THOUSANDS of instructions to make it happen — load values into
# registers, compare them, jump to the right code, format the string,
# write bytes to the screen output buffer, and so on.

x = 5
y = 7
result = x + y
print(f"{x} + {y} = {result}")

# When you read this:
#   - "x = 5"        → CPU stores the number 5 in a chunk of RAM
#   - "y = 7"        → CPU stores 7 in another chunk
#   - "x + y"        → CPU loads both into registers, runs an ADD instruction
#   - "print(...)"   → CPU sends those bytes to the operating system
#                       which forwards them to your screen
#
# All in roughly one millionth of a second.',
 'python', 2, 15),

(@fc_id,
 'Compilers vs Interpreters',
 'There are two main ways a language gets turned into something the CPU can run, and the difference explains a huge amount about how each language behaves.\r\n\r\nA COMPILER reads your entire program once, ahead of time, and translates it into machine code — the actual numeric instructions the CPU understands. The result is a separate file (an "executable") that you can run directly. Languages like C, C++, Rust, and Go work this way. Compiled programs are usually faster, because all the translation work is done before they ever run. But you have to compile again every time you change the code.\r\n\r\nAn INTERPRETER reads your program line by line AS it runs. It looks at one line, figures out what it means, runs it, then moves to the next. Python and JavaScript work this way. This is slower per-line than running pre-compiled machine code, but it means you can change a line and immediately re-run without rebuilding. It is also why Python errors often only appear when the bad line actually runs — the interpreter hasn''t looked at the rest of the file yet.\r\n\r\nA third hybrid is the JIT compiler ("Just-In-Time"). Java and modern JavaScript use this — they compile pieces of code into machine code on the fly while the program runs. It is a clever middle ground.',
 '# Python is INTERPRETED. The Python interpreter reads this file
# top to bottom, line by line, and runs each one as it sees it.

print("Line 1 runs first")
print("Line 2 runs second")
print("Line 3 runs third")

# This line below has a bug — but Python does not even SEE it
# until it gets here, because the interpreter only looks at one
# line at a time:
x = 10
print(x)
# undefined_variable  ← if this line ran, you would get a NameError
#                       — but ONLY when the interpreter reached it.

# In a COMPILED language like C, the compiler would scan the
# whole file first and refuse to build if any line was invalid.
# That is why compiled languages "catch bugs earlier" — they
# read everything before running anything.',
 'python', 3, 15),

(@fc_id,
 'Binary — Everything is Numbers',
 'A computer''s most basic unit is a BIT — a single 0 or 1. That is it. A bit is either off (0) or on (1), because at the hardware level, it is just a voltage being low or high. Eight bits together form a BYTE, which can represent 256 different values (from 00000000 to 11111111, or 0 to 255 in normal counting).\r\n\r\nEverything inside a computer is bits. Numbers are stored as binary. Letters are stored as numbers that map to characters (the letter "A" is the number 65 in a system called ASCII). Images are huge grids of numbers describing the colour of each pixel. Audio is numbers describing the height of a sound wave thousands of times per second. Even your code, when saved as a file, is a sequence of numbers — one for each character.\r\n\r\nThis is why "out of memory" errors exist (every byte is real physical hardware), why integers have limits in some languages (a 32-bit number can only hold values up to about 4.2 billion), and why decimal numbers sometimes look slightly wrong (0.1 + 0.2 = 0.30000000000000004 in many languages, because 0.1 can not be perfectly represented in binary).',
 '# Every value in your program is bits underneath. Python lets you peek.

# A number — Python stores it in binary, but shows it in decimal.
n = 42
print(f"{n} in binary is {bin(n)}")     # 0b101010
print(f"{n} in hex is {hex(n)}")        # 0x2a

# A letter is really just a number (its character code)
print(ord("A"))                          # 65
print(ord("a"))                          # 97
print(chr(65))                           # A

# A whole string is a sequence of those numbers
for ch in "Hi!":
    print(f"  {ch} → {ord(ch)}")

# The famous floating-point quirk — binary cannot exactly store 0.1
print(0.1 + 0.2)                         # 0.30000000000000004',
 'python', 4, 15),

(@fc_id,
 'Memory — What Variables Actually Are',
 'A variable is not a magic name that "holds" a value. A variable is a LABEL that points to a location in memory where a value is stored. When you write "x = 5", you are telling the language: find a free chunk of RAM, write the number 5 into it, and remember that "x" refers to that chunk.\r\n\r\nThis distinction matters when you start assigning variables to each other. In simple cases (numbers, strings, booleans) most languages copy the value, so "y = x" gives y its own copy. But for bigger things like lists, dictionaries, and objects, many languages copy the POINTER (the address of the chunk) rather than the chunk itself. So two variables can end up referring to the SAME memory — and changing one changes the other.\r\n\r\nThis is the single most common source of "wait, why did that change?" bugs in early programming. It is not magic; it is just that the variable was never the data — only a label pointing at it.',
 '# Numbers are simple — each variable gets its own value.
a = 5
b = a       # b is a separate copy
b = 99
print(a, b) # 5 99   ← a is untouched

# Lists work differently — both names point to the SAME list in memory.
shopping = ["milk", "eggs"]
copy_ref = shopping        # NOT a copy! Both labels, same memory.
copy_ref.append("bread")
print(shopping)            # ["milk", "eggs", "bread"]   ← surprise!
print(copy_ref)            # ["milk", "eggs", "bread"]

# To get an ACTUAL copy you have to ask for one explicitly.
real_copy = shopping.copy()
real_copy.append("cheese")
print(shopping)            # ["milk", "eggs", "bread"]   ← unchanged
print(real_copy)           # ["milk", "eggs", "bread", "cheese"]

# Rule of thumb: simple values are copied; collections are shared.
# Knowing this prevents 50% of beginner bugs.',
 'python', 5, 20),

(@fc_id,
 'Functions and the Call Stack',
 'A function is a reusable block of code with a name. You call it, optionally give it some inputs (arguments), and it can give you back a result (a return value). That much you probably know. But what is actually happening underneath?\r\n\r\nWhen you call a function, the program creates a small workspace in memory called a STACK FRAME. The frame holds the function''s local variables and remembers where to return to once the function finishes. When the function returns, the frame is destroyed and execution continues from where it left off.\r\n\r\nThe word "stack" is literal — when one function calls another, a new frame is added on top. When that function returns, its frame is removed and you are back in the previous one. If a function calls itself too many times without ever returning (infinite recursion), the stack grows until it runs out of space — that is what a "stack overflow" actually is.\r\n\r\nThis model is the same in every language. Once you see it, the flow of any program — even very complex ones — becomes a story of frames being pushed onto and popped off the stack.',
 '# Each function call creates a new "frame" with its own local variables.
# When a function returns, its frame is destroyed.

def square(n):
    # n lives in this frame only. When square() returns, n is gone.
    result = n * n
    return result

def sum_of_squares(a, b):
    # This frame has its own a, b, and total — separate from any caller.
    total = square(a) + square(b)   # two calls → two short-lived frames
    return total

print(sum_of_squares(3, 4))         # 25

# When you call sum_of_squares(3, 4):
#   1. A frame is pushed for sum_of_squares (a=3, b=4)
#   2. It calls square(3) — a frame is pushed (n=3), runs, returns 9, frame popped
#   3. It calls square(4) — another frame (n=4), returns 16, frame popped
#   4. It adds them, returns 25, its OWN frame is popped
#
# This is the call stack. Every language has one.',
 'python', 6, 20),

(@fc_id,
 'Control Flow — Decisions and Jumps',
 'A computer reads instructions one after another, top to bottom. But real programs need to make decisions ("if the user is logged in, show the dashboard") and repeat work ("for each item in the basket, add its price"). That is what CONTROL FLOW is — telling the program to skip ahead, go back, or branch into one of several paths.\r\n\r\nUnderneath, all control flow becomes JUMPS at the CPU level. The CPU has a special register called the instruction pointer that says "the next instruction to run is at this address". An "if" statement compiles down to: compare these values, and if the result is false, change the instruction pointer to jump past the block. A loop is the same thing in reverse — at the bottom of the loop, jump back to the top if the condition still holds.\r\n\r\nEvery language gives you the same basic tools, just with different syntax: if / else (choose one path), elif / else if (multiple choices), and a way to do nothing in some cases. Once you learn one language''s version, the rest are just spelling differences.',
 '# Control flow lets the program decide which lines to run.

age = 17
has_permission = True

if age >= 18:
    print("You are an adult.")
elif age >= 13 and has_permission:
    print("Teen with permission — proceed.")
else:
    print("Sorry, access denied.")

# Under the hood, this becomes roughly:
#   compare age to 18
#   if NOT greater-or-equal, jump past first block
#   compare age to 13
#   compare has_permission to True
#   if either fails, jump to the else block
#   ...
#
# Every if/elif/else in every language eventually becomes
# "compare, then jump or do not jump". That is all the CPU does.

# A practical example — pick a message based on the time of day.
hour = 14
if hour < 12:
    greeting = "Good morning"
elif hour < 18:
    greeting = "Good afternoon"
else:
    greeting = "Good evening"
print(greeting)',
 'python', 7, 15),

(@fc_id,
 'Loops — What is Really Happening',
 'A loop is a controlled jump backwards. The program runs a block of code, hits the bottom, checks a condition, and either jumps back to the top to run again or carries on past the loop. That is literally all a loop is.\r\n\r\nLanguages give you a few flavours. A WHILE loop says "keep doing this as long as some condition is true". A FOR loop usually says "do this once for each item in a collection" — but underneath, it is still a while loop with a counter or iterator. Both eventually compile down to the same CPU pattern: do work, check, jump back if needed.\r\n\r\nThe most important loop concept is the TERMINATION CONDITION. Every loop must eventually become false, or it runs forever (an infinite loop). When you accidentally write one, your program freezes. That is not a mysterious crash — it is the CPU faithfully running your block over and over because you never told it when to stop.',
 '# A while loop — repeats until the condition becomes false.
count = 1
while count <= 5:
    print(f"Count is {count}")
    count = count + 1   # IMPORTANT: this line is what makes the loop end.
print("Loop finished")

# Same logic as a for loop — usually cleaner when iterating a sequence.
for n in range(1, 6):
    print(f"For loop n = {n}")

# Looping over a real collection
fruits = ["apple", "banana", "cherry"]
for f in fruits:
    print(f"I like {f}")

# Anatomy of a bug:
# while count <= 5:
#     print(count)
#     # forgot to increment count → infinite loop!
#
# The CPU does not "know" you meant to stop. It just keeps doing
# what you told it. The fix is always: change something inside
# the loop so the condition eventually becomes false.',
 'python', 8, 15),

(@fc_id,
 'Errors and the Debugging Mindset',
 'Errors are not failure. They are the program telling you, in surprising detail, what went wrong and where. Beginners panic when they see a red error message; experienced programmers read it carefully because it is usually the fastest path to the bug.\r\n\r\nThere are three broad kinds of errors. SYNTAX ERRORS happen when your code is not valid in the language — a missing bracket, a misspelled keyword. The interpreter or compiler refuses to even start. RUNTIME ERRORS happen while the program is running — dividing by zero, opening a file that does not exist, using a variable that was never defined. The program crashes part-way through. LOGIC ERRORS are the worst: the program runs fine, no error appears, but the answer is wrong. The computer did exactly what you said — just not what you meant.\r\n\r\nThe debugging mindset has one rule: assume nothing. Do not guess where the bug is — find out. Print the values of variables. Run the failing case alone. Read the error message twice. Most bugs you will ever face are simple once you stop trying to think your way to them and start looking at what the program is actually doing.',
 '# A SYNTAX ERROR — Python will refuse to run this file at all if uncommented:
# print("hello"     ← missing closing bracket

# A RUNTIME ERROR — the program runs until it hits this line, then crashes.
# Read the error message — it tells you the line and the exact problem.
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Caught a runtime error: {e}")

# A LOGIC ERROR — no crash, but the answer is wrong.
def average(numbers):
    total = sum(numbers)
    return total / len(numbers) + 1     # BUG: that "+ 1" should not be there

print(average([2, 4, 6]))   # 5.0 — wrong! Real average is 4.0
# No error message will tell you. The only way to catch this is
# to TEST with known inputs and check the output.

# Debugging in real life is: print things, narrow it down, fix it.
def average_fixed(numbers):
    print(f"  debug: numbers = {numbers}")
    total = sum(numbers)
    print(f"  debug: total   = {total}")
    return total / len(numbers)

print(average_fixed([2, 4, 6]))   # 4.0 — correct',
 'python', 9, 20),

(@fc_id,
 'Algorithms — How to Think Like a Solver',
 'An algorithm is just a precise sequence of steps for solving a problem. A recipe is an algorithm. The directions home are an algorithm. Writing code is mostly the act of inventing an algorithm in your head and then translating it into a programming language.\r\n\r\nGood programmers do not start by writing code. They start by writing the steps. "How would I do this by hand?" If you can describe the solution clearly in plain English, translating it to code is the easy part. If you can not describe it in English, you do not understand the problem well enough yet — and no amount of typing will save you.\r\n\r\nAlgorithms have qualities you learn to evaluate over time. Some are CORRECT (they always give the right answer). Some are FAST (they finish quickly even on huge inputs). Some are MEMORY-EFFICIENT (they do not eat all your RAM). Sometimes you trade one for another — a faster algorithm might use more memory. Picking the right algorithm matters more than what language you write it in.',
 '# Problem: find the largest number in a list.
#
# Step 1 — describe it in English first:
#   "Assume the first number is the largest. Look at each of the others.
#    If any of them is bigger than the current largest, remember it instead.
#    When you have seen them all, the one you remember is the answer."

def find_max(numbers):
    largest = numbers[0]              # assume the first is the largest
    for n in numbers[1:]:             # look at each of the others
        if n > largest:               # if it beats the current champion
            largest = n               # remember it instead
    return largest

print(find_max([4, 1, 8, 2, 9, 3, 7]))   # 9

# That is an algorithm. The "for / if / update" pattern is the same idea
# whether you write it in Python, Java, C++, or JavaScript.

# Bonus — count how many comparisons happen for a list of N items.
# This one does N-1 comparisons. We call that "O(N)" — linear time.
# If you doubled the list size, it would take roughly twice as long.
# Algorithm analysis is just thinking about how work grows with input.',
 'python', 10, 20),

(@fc_id,
 'Data Structures — Choosing How to Store Things',
 'A data structure is a chosen way of organising values in memory. Different shapes of data fit different problems, and picking the right one makes your code shorter, faster, and easier to reason about.\r\n\r\nFour show up everywhere. A LIST (or array) is an ordered sequence — perfect when order matters and you want to iterate. A DICTIONARY (or map / hash table) stores key→value pairs — perfect for fast lookup by name. A SET stores unique items — perfect when you need to ask "have I seen this before?". A TUPLE is a fixed-size group of values — perfect for returning multiple things at once.\r\n\r\nEvery language has these, sometimes under different names. JavaScript calls a dictionary an "object", Java calls it a HashMap. The names change; the shapes do not. Learning to spot which shape fits your problem is a skill that pays back forever. "I keep checking if something is in a list" → use a set. "I keep searching a list for a name" → use a dictionary. "Order does not matter and duplicates are a problem" → set.',
 '# LIST — ordered, can have duplicates, accessed by position.
scores = [80, 95, 72, 95, 60]
print(scores[0])           # 80
print(len(scores))         # 5

# DICTIONARY — fast lookup by key (name).
student = {
    "name":  "Ahmed",
    "age":   20,
    "gpa":   3.8,
}
print(student["name"])     # Ahmed
student["gpa"] = 3.9       # update by key
print(student)

# SET — only unique items, super fast "is this in there?" check.
seen = {"alice", "bob", "charlie"}
print("alice" in seen)     # True   — O(1) lookup
print("dave"  in seen)     # False
seen.add("dave")
print(seen)

# TUPLE — fixed group of values, often used to return two things.
def min_and_max(nums):
    return (min(nums), max(nums))

low, high = min_and_max([3, 7, 1, 9, 4])
print(low, high)           # 1 9

# Pick the structure that matches the QUESTION you keep asking the data.
# "Give me item #3"        → list / array
# "Give me the value for X" → dictionary
# "Have I seen X?"         → set',
 'python', 11, 20),

(@fc_id,
 'How Programs Talk to the Outside World',
 'A program by itself is just instructions and memory. Useful programs need INPUT (data coming in) and OUTPUT (results going out). The four main ways a program connects to the outside world are: the user (keyboard / screen), the filesystem (files on disk), the network (other computers), and external devices (cameras, sensors, printers).\r\n\r\nEach of these is slow compared to RAM. Reading from disk is thousands of times slower than reading from memory. Sending a network request is millions of times slower. This is why "performance" in real programs is almost never about how fast your code runs — it is about how often you wait on something outside your code. The CPU finishes most of your loop before the network call you sent ten milliseconds ago even comes back.\r\n\r\nUnderstanding this is what separates beginner code from professional code. The actual algorithm is usually fine. The slow part is the file read, the database query, the API call. Real performance work is about avoiding waiting, batching requests, and caching answers you already have.',
 '# A program that reads input, processes it, and writes output.

# 1. INPUT — ask the user a question.
# In a normal Python script you would use input(), but our compiler
# does not have a keyboard. Let us simulate with a hard-coded value.
user_name = "Ahmed"        # imagine this came from input("Your name: ")

# 2. PROCESSING — pure computation, all in RAM, very fast.
greeting = f"Hello, {user_name}! Welcome to Coder."

# 3. OUTPUT — send it somewhere. Here, the screen.
print(greeting)

# A real program might also:
#   - read a file:           with open("data.txt") as f: text = f.read()
#   - call an API:           import requests; r = requests.get("https://...")
#   - write a file:          with open("out.txt", "w") as f: f.write(text)
#
# Each of those is hundreds-to-millions of times slower than the
# computation in step 2. That is why you finish this course and
# suddenly understand: "ahh, THAT is why my app feels slow".

# Congrats — you just finished the Foundations course.
# Now pick a language (Python, JavaScript, Java...) and the syntax
# will feel like a small extra layer on top of what you already
# understand. Everything else is just spelling.',
 'python', 12, 25);

-- ── 3. Verify ───────────────────────────────────────────────
SELECT id, title, language, level, lessons FROM courses WHERE title = 'Programming Foundations';
SELECT id, order_num, title, xp_reward FROM lessons WHERE course_id = @fc_id ORDER BY order_num;
