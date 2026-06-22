-- =============================================================
-- CODER — debugging_course.sql
-- "Debugging Like a Pro" — 10 lessons that turn bugs INTO the
-- curriculum instead of treating them as interruptions.
--
-- Research backing:
--   - Kafai & DeLiema 2019 (debugging-as-productive-failure)
--   - Becker et al. 2019 ITiCSE WG (error messages still fail
--     novices after 50 years of research)
--   - Anthropic 2026 RCT (skill gap was LARGEST on debugging
--     questions for AI-assisted learners — d=0.738)
-- =============================================================

USE coder_db;

INSERT IGNORE INTO courses
  (title, description, language, level, duration, lessons, icon, color)
VALUES
  ('Debugging Like a Pro',
   'Bugs are not failures — they are the fastest teachers you will ever have. This course makes debugging a SKILL, not a panic response. Learn to read error messages, bisect a broken program, follow a stack trace, and find the bug in someone else''s code in under five minutes.',
   'python',
   'Beginner',
   '3 weeks',
   10,
   'fas fa-bug',
   '#ef4444');

SET @dbg_id := (SELECT id FROM courses WHERE title = 'Debugging Like a Pro' LIMIT 1);
DELETE FROM lessons WHERE course_id = @dbg_id;

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@dbg_id,
 'The Debugging Mindset',
 'Beginner programmers see a red error message and feel embarrassed. Professional programmers see a red error message and feel grateful. That is not a personality difference — it is a learned reaction, and you will learn it in this course.\r\n\r\nHere is the truth: a bug is the program telling you, with unusual precision, that one of your assumptions is wrong. Without the bug you would have shipped that wrong assumption into production and learned about it from an angry user. The bug is a free, immediate, detailed teacher. The fastest programmers in the world are not the ones who write fewer bugs — they are the ones who diagnose them faster.\r\n\r\nThe core mindset shift is: BUGS ARE INFORMATION. When the program crashes, do not delete the line and try again. Do not paste the error into ChatGPT. Read it. Predict where it is. Look. The few seconds you spend understanding why a bug happened are worth hours of guessing.\r\n\r\nResearch finding (Anthropic, 2026): students who used AI to skip past errors scored 17% lower on skill tests than students who hit the errors themselves. The errors are the lesson. Do not let anything rob you of them.',
 '# Three buggy programs. For each one, BEFORE running it,
# read it carefully and write down (in your head) where you think
# the bug is. Then run it and see if you were right.

# Bug #1
numbers = [1, 2, 3, 4, 5]
total = 0
for i in range(len(numbers) + 1):   # Where is the bug?
    total += numbers[i]
print(f"Total: {total}")

# Did you spot it BEFORE running? Most people see only after the crash.
# Train your eyes by predicting first. That is the entire course
# in one habit: predict, then verify.',
 'python', 1, 10),

(@dbg_id,
 'Read the Error Message (Really Read It)',
 'Error messages look scary because they are dense, not because they are mean. Inside a Python traceback or a Java stack trace, almost every word is telling you exactly what went wrong and where. Beginners scan them for the colour red, then panic. Professionals read them top to bottom.\r\n\r\nEvery error message in every language contains three things: WHAT went wrong (the error type), WHERE it happened (the file and line number), and CONTEXT (the values or call chain that led to it). Read in that order. Sometimes the error type alone is enough — "NameError: name ''x'' is not defined" tells you exactly what the problem is. Sometimes you need the line number. Sometimes you need to walk up the stack trace to see who called the broken function.\r\n\r\nA pro tip you will not see anywhere else: ALWAYS read the LAST line of the error first. That is usually the actual problem. Then walk upward to see where it was caused from. Errors read bottom-up.',
 '# Look at a real error message and decode it line by line.

def divide(a, b):
    return a / b

def calculate_average(numbers):
    total = sum(numbers)
    return divide(total, len(numbers))

# The bug — what happens when the list is empty?
print(calculate_average([]))

# When you run this you will see something like:
#
#   Traceback (most recent call last):
#     File "main.py", line 9, in <module>
#       print(calculate_average([]))
#     File "main.py", line 6, in calculate_average
#       return divide(total, len(numbers))
#     File "main.py", line 3, in divide
#       return a / b
#   ZeroDivisionError: division by zero
#
# READ BOTTOM UP:
#   Last line  → WHAT: division by zero
#   Above that → WHERE: in divide(), line 3
#   Above that → WHO CALLED IT: calculate_average() on line 6
#   Above that → WHO CALLED THAT: top-level code on line 9
#
# Now you know everything: an empty list → len()==0 → division by 0.
# The error message just TOLD you the whole story.',
 'python', 2, 15),

(@dbg_id,
 'The Five Whys',
 'A bug fix that does not understand the cause is just a vandalism patch — it makes the symptom disappear but leaves the underlying mistake to bite you again somewhere else. The Five Whys is a technique from Toyota''s manufacturing line that works perfectly for code: ask "why?" five times in a row, and the real cause usually surfaces.\r\n\r\nExample. The program crashed. WHY? Because a variable was None. WHY was it None? Because the function returned None instead of a number. WHY did it return None? Because it took the early-exit branch. WHY did it take that branch? Because the input list was empty. WHY was the input list empty? Because the file we were reading from is actually a different format than we assumed.\r\n\r\nAt that point you have not just fixed a crash — you have learned something true about the system. The five-whys habit is what separates programmers who fix the same bug three times from programmers who fix it once.',
 '# Practice the Five Whys on a real bug.

import sys

def get_user_age(user_data, user_id):
    # Find the user and return their age
    user = next((u for u in user_data if u["id"] == user_id), None)
    return user["age"]            # ← will crash if user is None

def can_vote(user_data, user_id):
    return get_user_age(user_data, user_id) >= 18

# Test data
users = [
    {"id": 1, "age": 25},
    {"id": 2, "age": 17},
]

# This crashes. Let''s apply Five Whys.
try:
    print(can_vote(users, user_id=99))
except Exception as e:
    print(f"Crashed: {type(e).__name__}: {e}\\n")

# Why #1: TypeError — tried to index None.
# Why #2: get_user_age returned None["age"] because user was None.
# Why #3: next() returned None because id=99 was not found.
# Why #4: We called can_vote with an id that does not exist in users.
# Why #5: The caller code did not validate the id before using it.
#
# Five whys → REAL fix is to validate input AND handle missing users:
def get_user_age_fixed(user_data, user_id):
    user = next((u for u in user_data if u["id"] == user_id), None)
    if user is None:
        raise ValueError(f"No user with id={user_id}")
    return user["age"]

# Now the error is explicit and the caller sees the real problem.
try:
    print(can_vote(users, user_id=99))   # still uses the old version
except Exception:
    pass
print(get_user_age_fixed(users, user_id=1))   # 25',
 'python', 3, 20),

(@dbg_id,
 'Bisection — When You Have No Idea Where the Bug Is',
 'Sometimes the program does not crash, it just produces the wrong answer. Or it crashes deep inside a 500-line function with no useful error. Where do you even start?\r\n\r\nBisection. Comment out half the code (or skip half the loop, or run half the steps). Does the bug still happen? If YES, the bug is in the half you kept. If NO, it is in the half you removed. Repeat with the half that has the bug. After about 10 rounds of halving, you have isolated the bug to a single line, no matter how big the program was.\r\n\r\nThis is the same idea as binary search — it works because each step throws away half the possibilities. Git even has a built-in bisect command (`git bisect`) that uses it to find which commit introduced a bug across a 10,000-commit history. Same technique, different scale.',
 '# A 100-step pipeline produces a wrong result somewhere.
# Find the broken step using bisection.

def step(n, value):
    # Most steps just add 1, but one is sabotaged.
    if n == 47:
        return value * 0      # ← the bug
    return value + 1

# Run all 100 steps and see the broken value
value = 100
for n in range(100):
    value = step(n, value)
print(f"Final value: {value}  (expected 200)")

# Now bisect: where does the value go wrong?
def run_range(start, end, initial=100):
    v = initial
    for n in range(start, end):
        v = step(n, v)
    return v

# Test halves
print(f"After steps 0–49:  {run_range(0, 50)}")      # broken!
print(f"After steps 0–24:  {run_range(0, 25)}")      # fine
print(f"After steps 25–49: {run_range(25, 50, initial=run_range(0, 25))}")  # broken!
# We halved the range to 25–49. Keep halving:
print(f"After step 25–37:  {run_range(25, 38, initial=run_range(0, 25))}")
print(f"After step 38–49:  {run_range(38, 50, initial=run_range(0, 38))}")
# A few more bisections and you would land exactly on step 47.
# 100 steps → ~7 checks to find the bug. That is bisection.',
 'python', 4, 20),

(@dbg_id,
 'Print Statement Archaeology',
 'There is a fashion among beginners to feel embarrassed about using print statements to debug — like real programmers should use a "debugger". The truth is that print debugging is undefeated. It is fast, it works in every language, it works in production logs, it works inside containers, and it works when nothing else does. Use the debugger when it helps. Use print when it is faster. Often, print is faster.\r\n\r\nThe trick is to print the RIGHT things. Print the value of a variable just before the line you suspect. Print the type, not just the value — many bugs are "I thought this was an int but it is a string". Print at the start and end of a function to see if it is being called at all. Print in a loop with the iteration number — you will discover loops that run too many or too few times.\r\n\r\nWhen you are done, do not just delete the prints — they are evidence. Save the most useful ones as proper LOGS so future-you (or future-them) sees the same evidence next time the bug returns.',
 '# A bug — the average of [10, 20, 30] should be 20, but it returns 0.
# Use print debugging to find why.

def average(numbers):
    total = 0
    for n in numbers:
        total += n
    return total / len(numbers)

# Looks fine. So why does this break?
data = "10,20,30"
parsed = data.split(",")
print(f"DEBUG parsed = {parsed}")        # ← print 1: what did we parse?
print(f"DEBUG type   = {type(parsed[0])}") # ← print 2: what TYPE are these?

# AHA — split() returned strings, not ints. "10" + "20" + "30" = "102030".
# But Python lets you sum strings... wait, does it?
# Actually no — sum() on strings errors. So the bug is...
# Let''s see what happens:
try:
    result = average(parsed)
    print(f"Result: {result}")
except Exception as e:
    print(f"BUG: {type(e).__name__}: {e}")

# Fix — convert to ints first
parsed_ints = [int(x) for x in parsed]
print(f"Fixed result: {average(parsed_ints)}")

# Total prints used: 3. Time to find the bug: about 20 seconds.
# Debugger setup time you saved: about 2 minutes.',
 'python', 5, 15),

(@dbg_id,
 'Reading a Stack Trace',
 'A stack trace is a snapshot of every function that was in the middle of running when the program crashed — top of the stack is where the crash actually happened, bottom is where the program started. It is the most information-dense thing your computer ever gives you about an error.\r\n\r\nReading one is a skill. Walk top-down to see the chain of who-called-who. Walk bottom-up to see what actually broke. Most pros read the very last line first (the actual error), then walk upward looking for the FIRST file path they recognise as their own code (skip framework/library frames — those are rarely the bug). That is your prime suspect.\r\n\r\nA common mistake is to assume the crash is on the line the trace points at. Sometimes it is — but often the line is correct and the BUG is in the previous line that set up bad data. The stack trace tells you the EXECUTION location of the failure, not necessarily the LOGIC location of the mistake.',
 '# A multi-layer call that crashes — read the trace.

def parse_price(text):
    return float(text.replace("$", ""))   # innocent-looking

def total_basket(items):
    total = 0
    for item in items:
        total += parse_price(item["price"])
    return total

def checkout(cart):
    grand_total = total_basket(cart)
    print(f"Checkout: ${grand_total:.2f}")

# Almost works. But one item has a typo.
basket = [
    {"name": "book",   "price": "$12.99"},
    {"name": "pen",    "price": "$2.50"},
    {"name": "laptop", "price": "$1,299.00"},   # ← comma will break float()
]

try:
    checkout(basket)
except Exception as e:
    print(f"{type(e).__name__}: {e}")
    print("\\nReading the stack trace:")
    import traceback
    traceback.print_exc()

# What the trace tells us:
#   - Last frame: parse_price(), float() failed because of the comma
#   - One frame up: total_basket() called parse_price with bad input
#   - One frame up: checkout() called total_basket with the bad basket
#   - One frame up: top-level code passed the bad basket in
#
# The crash is in parse_price, but the BUG is the data shape.
# Fix the parser to handle commas — or fix the caller to clean data first.',
 'python', 6, 20),

(@dbg_id,
 'Reproduce-First (The Minimal Failing Case)',
 'You cannot fix what you cannot trigger. The first move on any non-obvious bug is: reduce the problem to the smallest piece of code that still produces it. A 500-line program that crashes "sometimes" is a nightmare. A 5-line program that crashes "every time you run it" is solved by lunch.\r\n\r\nThe technique is brutal subtraction. Take the failing program. Delete a chunk. Does it still fail? Yes → keep deleting. No → put it back. After a few rounds you have a TINY example with the same bug. This is called a Minimal Reproducible Example, or MRE. It is the same artifact you would attach to a bug report or a Stack Overflow question.\r\n\r\nTwo wins from doing this. First, the minimal example often makes the bug obvious — you can SEE it once the noise is gone. Second, even if you cannot solve it, your minimal example is exactly what an expert (or an AI) needs to help you in seconds instead of hours.',
 '# Start with a noisy buggy program. Reduce it.

# === Step 0 — full noisy version (45 lines of stuff) ===
def load_config():
    return {"max": 10, "tax": 0.05, "currency": "USD"}

def format_currency(amount, currency):
    return f"{currency} {amount:.2f}"

def calculate(items, config):
    subtotal = sum(item["qty"] * item["price"] for item in items)
    tax = subtotal * config["tax"]
    return format_currency(subtotal + tax, config["currency"])

# Somewhere in there, this crashes. Where?
config = load_config()
items = [{"name": "a", "qty": 2, "price": 10},
         {"name": "b", "qty": "three", "price": 5}]    # ← qty is a string!

try:
    print(calculate(items, config))
except Exception as e:
    print(f"Full version crash: {type(e).__name__}: {e}")

# === Step 1 — STRIP everything that is not part of the bug ===
# The crash is from item["qty"] * item["price"]. The function setup,
# the format_currency call, the config loading — all irrelevant.
# Minimal reproduction:

try:
    qty   = "three"
    price = 5
    result = qty * price
    print(result)
except Exception as e:
    print(f"\\nMinimal reproduction:\\n  qty * price where qty=\\"three\\"")
    print(f"  → {type(e).__name__}: {e}")

# Wait — "three" * 5 in Python is "threethreethreethreethree"!
# It does NOT crash. So this is a SEMANTIC bug, not a crash bug.
# The minimal repro just taught us the bug is "wrong output" not
# "exception". That changes how we hunt it.
print(f"\\nActual silent bug: ''three'' * 5 = {''three'' * 5}")',
 'python', 7, 20),

(@dbg_id,
 'Rubber Duck Debugging',
 'The rubber duck is the single most effective debugging technique in history. Place a rubber duck on your desk. When you are stuck on a bug, EXPLAIN THE CODE TO IT. Out loud. Line by line. "First we do this, then we do that, and then THIS variable should be... oh. Oh I see it now."\r\n\r\nThe trick is not the duck. The trick is forcing yourself to articulate every step in words, in order, slowly. Your brain when reading code skips and assumes. Your brain when SPEAKING code has to actually justify every step. Bugs hide in the gap between what you skipped and what is actually written. Speaking removes the gap.\r\n\r\nIn 2026 the duck has competitors. You can rubber-duck to ChatGPT, to a notebook, to a colleague. They all work for the same reason: the act of explaining forces precision. But there is one specific advantage of the duck — the duck never gives you a hint that bypasses the explanation. The duck makes you find it yourself, which is how you actually learn.',
 '# Practice: read this code OUT LOUD before reading the analysis below.
# Yes, really out loud. Tell the duck what each line does.

def find_max(numbers):
    largest = 0                          # Line 1
    for n in numbers:                    # Line 2
        if n > largest:                  # Line 3
            largest = n                  # Line 4
    return largest                       # Line 5

# Test it
print(find_max([3, 7, 2, 9, 4]))      # works: 9
print(find_max([5, 8, 6]))            # works: 8

# Now the tricky one:
print(find_max([-3, -7, -2, -9, -4]))    # Hmm.

# DUCK CONVERSATION:
#   "I set largest to ZERO at the start.
#    Then I check each number — if it is BIGGER than largest, update.
#    But all the numbers are NEGATIVE.
#    No negative number is bigger than zero...
#    So largest stays at zero...
#    But zero is NOT IN THE LIST."
#
# Saying it out loud → the bug appears. The fix:
def find_max_fixed(numbers):
    largest = numbers[0]                 # ← start with the FIRST number
    for n in numbers[1:]:
        if n > largest:
            largest = n
    return largest

print(find_max_fixed([-3, -7, -2, -9, -4]))   # -2 (correct)',
 'python', 8, 15),

(@dbg_id,
 'It is Almost Never the Compiler',
 'There is an old programming joke: "I think I found a bug in the compiler." The follow-up is always: "No you did not."\r\n\r\nWhen things stop working, beginners blame the tool. The language is weird. The compiler is buggy. Python is being inconsistent. The IDE is haunted. 99.9% of the time, this is wrong. The compiler, the interpreter, the standard library — these are used by millions of people every day. If they had the bug you think they have, it would be a huge news story. They do not have that bug. You do.\r\n\r\nThe correct prior is: when reality disagrees with my expectation, my expectation is wrong. The tool is fine. My mental model is missing something. This is not just a debugging tip — it is a learning attitude. Every time you find a "weird behaviour" that turns out to be how the language actually works, you have closed a gap in your mental model. That is more valuable than the bug fix.',
 '# Three "the language is broken" moments that are not the language being broken.
# Each one, BEFORE you read the explanation, predict the output.

# === Surprise #1 ===
a = [1, 2, 3]
b = a
b.append(4)
print("Test 1:", a)
# "Why did a change? I never touched a!"
# Reality: a and b are the same list. Lists are passed by reference.
# Not a bug — a missing piece of your mental model.

# === Surprise #2 ===
print("Test 2:", 0.1 + 0.2 == 0.3)
# "Of course 0.1 + 0.2 equals 0.3. Why is this False?"
# Reality: floating-point numbers cannot represent 0.1 exactly in binary.
# Not a bug — that is how every language on every CPU stores floats.

# === Surprise #3 ===
def make_counters():
    counters = []
    for i in range(3):
        counters.append(lambda: i)
    return counters

for c in make_counters():
    print("Test 3:", c())
# "I made three counters that should return 0, 1, 2. Why all 2?"
# Reality: closures capture VARIABLES not VALUES. By the time the
# lambdas run, i is already 2 (the last value of the loop).
# Not a bug — that is how closures work everywhere.

# Whenever you mutter "the language is broken", write down what
# you EXPECTED and what HAPPENED. The gap is your next lesson.',
 'python', 9, 20),

(@dbg_id,
 'Bugs You Caused vs Bugs You Inherited',
 'Eventually you will join a project where bugs have been there longer than you have. Old bugs in someone else''s code feel different from your own — you cannot reach the original assumption that made it broken, and the surrounding code may not match the broken function''s expectations. This is the hardest debugging there is, and it has its own playbook.\r\n\r\nStep one: do not "fix" anything yet. UNDERSTAND first. Read the test cases (if any) — they tell you what the original author thought the function should do. Look at git blame — when was this line written, by whom, and what commit message did they leave? Read the issue or pull request that introduced it. Half the time, you discover the "bug" was deliberate handling of an edge case you did not know existed.\r\n\r\nStep two: write a test that REPRODUCES the bug before you fix it. This pins the bug in place and proves your fix actually worked. If you fix without a test, you might just be masking the symptom in a way that breaks something else.\r\n\r\nStep three: fix the bug AND leave the code clearer than you found it. A comment explaining what was confusing is a gift to the next person.',
 '# Imagine you inherited this function. It "has a bug" — sometimes
# users complain about wrong totals. Where is the bug? Read the
# test cases to learn what the original author INTENDED.

def calculate_total(items, discount_code=None):
    """Return the total price of items, with optional discount."""
    subtotal = sum(item["price"] * item.get("qty", 1) for item in items)
    if discount_code == "SAVE10":
        return subtotal * 0.9
    if discount_code == "SAVE20":
        return subtotal * 0.8
    return subtotal

# Existing tests (left by the original author — read them like a story)
items = [{"name": "book", "price": 10, "qty": 2}, {"name": "pen", "price": 3}]

assert calculate_total(items) == 23                   # no discount
assert calculate_total(items, "SAVE10") == 20.7       # 10% off
assert calculate_total(items, "SAVE20") == 18.4       # 20% off

# So the tests pass. What did the bug report actually say?
# Real complaint: "I typed save10 and it did not discount me."
#
# AHA — the function checks "SAVE10" exactly. Lowercase "save10"
# falls through to the no-discount branch. The function works
# as written; the BUG is that it does not normalize input.

# Reproduce first
result = calculate_total(items, "save10")
print(f"Repro: code=''save10'' → total={result}  (user expected 20.7)")

# Now fix and leave the code clearer than you found it
def calculate_total_fixed(items, discount_code=None):
    """Return the total. Discount code is case-insensitive."""
    subtotal = sum(item["price"] * item.get("qty", 1) for item in items)
    code = (discount_code or "").upper()              # NEW: normalize
    discounts = {"SAVE10": 0.9, "SAVE20": 0.8}
    return subtotal * discounts.get(code, 1.0)

print(f"Fixed: code=''save10'' → total={calculate_total_fixed(items, ''save10'')}")

# You fixed the bug AND made the code shorter, clearer, and tested.
# That is what professional debugging looks like.
#
# You finished Debugging Like a Pro.
# Next up: Reading Code Like a Detective — where reading IS the skill.',
 'python', 10, 30);

SELECT id, title, lessons FROM courses WHERE id = @dbg_id;
SELECT order_num, title, xp_reward FROM lessons WHERE course_id = @dbg_id ORDER BY order_num;
