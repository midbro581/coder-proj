-- =============================================================
-- CODER — reading_code_course.sql
-- "Reading Code Like a Detective" — 10 lessons that build the
-- skill EVERY major platform skips: reading and tracing code.
--
-- Research backing:
--   - Lister et al. 2004 ITiCSE WG (tracing predicts writing)
--   - Lopez et al. 2008 ICER (R²≈0.66 between trace & write)
--   - Xie & Loksa — start with deconstructionist activities
--   - Ericson 2022 (Parsons problems scaffold reading)
-- =============================================================

USE coder_db;

INSERT IGNORE INTO courses
  (title, description, language, level, duration, lessons, icon, color)
VALUES
  ('Reading Code Like a Detective',
   'Most platforms teach you to WRITE code. Almost none teach you to READ it. But you will read 10× more code than you write — every codebase, every Stack Overflow answer, every AI-generated function. Become the person who can open an unfamiliar file and understand it in five minutes.',
   'python',
   'Beginner',
   '3 weeks',
   10,
   'fas fa-search',
   '#06b6d4');

SET @rc_id := (SELECT id FROM courses WHERE title = 'Reading Code Like a Detective' LIMIT 1);
DELETE FROM lessons WHERE course_id = @rc_id;

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@rc_id,
 'Why Reading Comes Before Writing',
 'Universities and online platforms drop beginners into the deep end: "here is some syntax, now write a function to do X". And then beginners struggle, and feel stupid, and a lot of them quit. The research community figured out why decades ago. You cannot WRITE fluent code until you can READ fluent code. Asking a beginner to write before they can read is like asking a child to write a novel before they have read a book.\r\n\r\nThe 2008 Lopez study tested hundreds of beginners on three skills: tracing code, explaining code, and writing code. Tracing-and-explaining scores predicted writing scores with R² ≈ 0.66 — meaning two-thirds of the variation in writing ability was explained by reading ability alone. The implication is brutal: the fastest way to learn to write code is to spend time reading and tracing OTHER PEOPLE''S code first.\r\n\r\nThis course gives you the skill the others skip. By the end, you will be able to look at an unfamiliar function and tell yourself what it does, line by line, BEFORE you run it.',
 '# Read this function. DO NOT run it yet.
# Write down (in your head or on paper) what you think it returns
# for the input [3, 1, 4, 1, 5, 9, 2, 6].

def mystery(arr):
    result = []
    for x in arr:
        if x not in result:
            result.append(x)
    return result

# Did you predict it? Now run it and check.
print(mystery([3, 1, 4, 1, 5, 9, 2, 6]))

# If you predicted [3, 1, 4, 5, 9, 2, 6] — perfect. You traced
# the loop, you noticed the "if x not in result" filter, you
# concluded it removes duplicates. THAT is reading code.
#
# The rest of the course teaches you to do this fast, on bigger
# code, in any language.',
 'python', 1, 10),

(@rc_id,
 'Predict-Then-Run',
 'Here is the single most powerful habit in this course: before you click "Run", PREDICT what the output will be. Even if you are wrong, the prediction makes you read the code carefully instead of skimming. When the actual output differs from your prediction, that gap is the most valuable learning signal you can get — it tells you exactly which assumption was wrong.\r\n\r\nThis is not a beginner technique. Senior engineers do it constantly when reading new codebases. It is how you build a mental model fast: predict, verify, adjust, repeat. Most tutorials let you skip this — they show the output before you read the code. That is backwards. Always read first, predict second, run last.\r\n\r\nIn this lesson, three short snippets. For each one, predict before reading the comments. Score yourself honestly. Three out of three? Skip ahead. Less? Stay here and try more — predict-then-run is a muscle and it grows fast with reps.',
 '# Predict the output of each block BEFORE looking at the comment.

# === Snippet 1 ===
nums = [1, 2, 3]
nums.append(nums)
print(len(nums))
# Predict: ___
# Reality: 4. Because nums.append(nums) added the list to itself —
#          and the list now contains itself as the 4th element.
#          (This is a "circular reference". Read it twice.)

# === Snippet 2 ===
def greet(name="World"):
    return f"Hello, {name}!"

names = ["Alice", "", None]
for n in names:
    print(greet(n))
# Predict: three lines, each says...?
# Reality:
#   Hello, Alice!       (clear case)
#   Hello, !            (empty string is NOT None, so default doesn''t kick in)
#   Hello, None!        (None is not "missing", it''s an actual value)
# The default only fires when the argument is omitted entirely.

# === Snippet 3 ===
x = [0]
def add_to(lst):
    lst.append(1)
    return lst

y = add_to(x)
print(x)
print(y)
print(x is y)
# Predict: x = ?  y = ?  same object?
# Reality:
#   x = [0, 1]
#   y = [0, 1]
#   True — they are the SAME list. Lists are passed by reference.',
 'python', 2, 15),

(@rc_id,
 'Trace by Hand (Paper Beats Memory)',
 'Your brain is a powerful but lazy thing. When it reads code, it tends to skip over loops ("yeah, this does the thing a few times, whatever") and assumes function bodies do "roughly what the name says". This skipping is fine for skimming and disastrous for debugging.\r\n\r\nThe fix is to literally trace the code by hand. Paper, pen, table of variables down the side, current line number on the left. For each line, update the value of every variable that changed. When you hit a loop, write the iteration number. When you hit a function call, draw an arrow and trace the call. When you return, draw an arrow back.\r\n\r\nIt feels slow. It is. The first few times you do it, a 20-line function might take 10 minutes to trace. But you will catch every off-by-one, every wrong condition, every subtle aliasing bug. After a few weeks of doing it, your brain learns the same trick and starts tracing automatically. You will skim a function and SEE the trace happen in your head.',
 '# Trace this function by hand. Write a table:
#   step | i | total | numbers[i]
# Fill it in line by line for numbers = [4, 9, 2].

def running_total(numbers):
    total = 0
    for i in range(len(numbers)):
        total = total + numbers[i]
        print(f"  step {i}: total={total}")
    return total

result = running_total([4, 9, 2])
print(f"Final: {result}")

# Your trace should look like:
#   step | i | total before | numbers[i] | total after
#     0  | 0 |       0      |     4      |      4
#     1  | 1 |       4      |     9      |     13
#     2  | 2 |      13      |     2      |     15
#
# This is what professional debugging actually looks like.
# Slow at first. Lightning fast after a few hundred traces.',
 'python', 3, 15),

(@rc_id,
 'Read the Names First',
 'Most unfamiliar code is readable if you trust the names. Function names, variable names, class names — they were chosen by someone who was, in theory, trying to communicate intent. A function called `calculate_tax` calculates tax. A variable called `unread_messages` holds unread messages. Read the NAMES and the SHAPE of the code before you read the inner logic.\r\n\r\nA fast reading pass goes like this: glance at the function names in the file. Read the top-level structure (this is a class with three methods). Read the signature of each function (what does it take, what does it return). Now you know what the file does without reading a single line of logic. ONLY THEN do you zoom in on the function you care about.\r\n\r\nThis is the reading order pros use: outside-in, names first, signatures second, bodies last. Beginners often do the opposite — they read top to bottom, line by line, and get lost in the details before they have a map.',
 '# Look at this file. WITHOUT reading any function body,
# write down (in your head) what this file does.

class Order:
    def __init__(self, customer_id, items):
        self.customer_id = customer_id
        self.items = items
        self.status = "pending"

    def add_item(self, item):
        self.items.append(item)

    def remove_item(self, item):
        self.items.remove(item)

    def total(self):
        return sum(item["price"] * item.get("qty", 1) for item in self.items)

    def submit(self):
        self.status = "submitted"
        return self.total()

    def cancel(self):
        self.status = "cancelled"


def find_orders_by_customer(orders, customer_id):
    return [o for o in orders if o.customer_id == customer_id]


def total_revenue(orders):
    return sum(o.total() for o in orders if o.status == "submitted")


# Without reading bodies, the NAMES tell you:
#   - There is an Order class. It has items, a status, and a customer_id.
#   - Orders can be added to, removed from, totalled, submitted, cancelled.
#   - There are helpers to filter by customer and total revenue.
#
# Now if you need to DEBUG a "revenue is wrong" bug, you know
# exactly which function to look at — total_revenue — without
# having read a single body. That is reading like a detective.

# Quick test
o1 = Order("alice", [{"name": "book", "price": 10, "qty": 2}])
o2 = Order("alice", [{"name": "pen",  "price": 3}])
o1.submit(); o2.submit()
print(f"Revenue: {total_revenue([o1, o2])}")',
 'python', 4, 15),

(@rc_id,
 'Follow the Data, Not the Control Flow',
 'Beginners read code top to bottom and follow what HAPPENS — first this line runs, then this, then a loop, then this. Senior engineers often read code by following the DATA — where does this variable come from, and where does it go? It is a completely different mental movement.\r\n\r\nPick a variable that matters. Trace where it is set. Trace where it is read. Trace where it is mutated. Suddenly you understand what the code does, regardless of which order the lines appear in. This is especially powerful for event-driven code (websites, games, UI) where there is no obvious "top to bottom" because the program reacts to clicks and messages.\r\n\r\nA simple way to practice: pick any function. Pick the first variable. Highlight every line that mentions it. Read only those lines, in order. You just isolated the LIFE of that variable from the rest of the noise.',
 '# This function does multiple things at once. Trace ONLY the
# variable "errors" — its life from creation to return.

def validate_user(user):
    errors = []                                  # ← created (empty)

    if not user.get("name"):
        errors.append("name is required")        # ← mutated

    email = user.get("email", "")
    if "@" not in email:
        errors.append("email looks invalid")     # ← mutated

    age = user.get("age", 0)
    if age < 13:
        errors.append("must be 13 or older")     # ← mutated

    if not user.get("country"):
        # Notice: we WARN but do not record it as an error
        print("warning: country is missing")

    return errors                                # ← returned

# Now you know "errors" without reading anything about email parsing,
# age comparison, or warnings. It''s just a list of strings, populated
# by 3 specific conditions, returned at the end.

print(validate_user({"name": "", "email": "bad", "age": 10}))
# Output: ["name is required", "email looks invalid", "must be 13 or older"]

# Reading by data is the fastest way to understand unfamiliar code
# when you only care about ONE thing in it.',
 'python', 5, 20),

(@rc_id,
 'Find the Entry Point',
 'Every program has a starting line. Find it, and the rest unfolds. In Python it is usually `if __name__ == "__main__":` or just the bottom of the file. In Java it is `public static void main`. In JavaScript on a webpage it is whatever the script tag loads. In React it is `ReactDOM.createRoot(...).render(...)`. In a Flask app it is `app.run()`.\r\n\r\nOnce you have the entry point, follow the calls outward. The entry point calls a function — open it. That function calls more functions — open them. Within 10 minutes of disciplined reading, you have walked the entire control flow of any program.\r\n\r\nThis is also how AI tools and senior engineers explore unfamiliar codebases — start at main, follow the calls. If you ever feel lost in a project, do not panic and grep randomly. Find main. Follow the calls. The codebase will explain itself.',
 '# A small program. Find the entry point first, then trace the flow.

def fetch_data():
    print("  [fetch_data] called")
    return [{"id": 1, "value": 42}, {"id": 2, "value": 17}]

def process(data):
    print("  [process] called")
    return [item["value"] * 2 for item in data]

def report(results):
    print("  [report] called")
    print(f"  Results: {results}")

def run_pipeline():
    print("[run_pipeline] start")
    raw = fetch_data()
    processed = process(raw)
    report(processed)
    print("[run_pipeline] end")

# === ENTRY POINT ===
if __name__ == "__main__":
    run_pipeline()

# Reading order:
#   1. See the __main__ block → it calls run_pipeline()
#   2. Open run_pipeline → it calls fetch_data, process, report
#   3. Open each one and you have the whole picture
#
# 4 functions. Read in 60 seconds. Always start at main.',
 'python', 6, 15),

(@rc_id,
 'Read the Tests to Learn the Code',
 'If the codebase has tests, they are the best documentation in the project — and the best teaching material. A test shows you: what inputs the function expects, what outputs it produces, and what edge cases the author considered worth checking. In ten minutes of reading tests, you can know a module better than someone who has spent an hour reading the implementation.\r\n\r\nWhen you join a new project, look for the test files first. They are usually named `test_*.py`, `*_test.go`, `*.spec.js`, or live in a `tests/` folder. Read the test names — they read like a spec ("test_empty_list_returns_zero", "test_handles_negative_input"). The test names alone tell you what the function does and what it must handle.\r\n\r\nThis trick has a bonus: if you ever want to CONTRIBUTE to a project, the existing tests show you what level of test coverage they expect from new code. You can match the style. You will look like you have been there for years.',
 '# Read these tests. WITHOUT reading the implementation below them,
# write down what the function does and what edge cases it handles.

def assert_eq(actual, expected, desc):
    """Tiny test helper — print pass/fail with description."""
    status = "PASS" if actual == expected else f"FAIL (got {actual!r})"
    print(f"  [{status}] {desc}")

# === Tests (read these first) ===
def test_normalize_phone():
    assert_eq(normalize_phone("(555) 123-4567"),  "5551234567",
              "removes spaces, brackets, dashes")
    assert_eq(normalize_phone("+1 555 123 4567"), "5551234567",
              "strips country code and spaces")
    assert_eq(normalize_phone(""),                "",
              "empty string → empty string")
    assert_eq(normalize_phone("abc"),             "",
              "non-digit input → empty string")
    assert_eq(normalize_phone("555.123.4567"),    "5551234567",
              "removes dots")

# From the tests alone you now know:
#   - The function takes a phone number string
#   - Strips brackets, spaces, dashes, dots, country codes
#   - Returns only digits
#   - Empty input returns empty string
#
# That is the SPEC. The implementation has to satisfy it:

def normalize_phone(text):
    digits = "".join(ch for ch in text if ch.isdigit())
    if digits.startswith("1") and len(digits) == 11:
        return digits[1:]    # drop US country code
    return digits

test_normalize_phone()
# Tests pass — you understood the function from reading the spec,
# not from reading the implementation. That is the power move.',
 'python', 7, 20),

(@rc_id,
 'Renaming Hostile Variables in Your Head',
 'Some code is written with terrible variable names. Single letters, abbreviations, leftovers from a different era. You cannot always rewrite it (production code, old libraries, AI-generated snippets) — but you can MENTALLY rename as you read. Every time you see `x`, think "scores". Every time you see `tmp`, think "the running total".\r\n\r\nThe practical version of this trick: when you encounter hostile code, do one minute of detective work to figure out what the bad names actually represent. Look at where they are set, what types they have, how they are used. Build a mini glossary in your head (or on paper). Now read the function as if it had readable names. It is a different function once you do this.\r\n\r\nBonus tip: if the code is yours, just rename. Modern editors do it safely with a refactor tool. If the code is someone else''s, a comment near the function saying "n = number of retries, m = max attempts" is a kindness to the next person.',
 '# Hostile version. Read it. What does it do?

def f(a, b, c=0):
    r = 0
    for x in a:
        if x > c:
            r += x * b
    return r

# Pause. Build your glossary:
#   a = a list of numbers (we loop over it)
#   x = a single number in that list
#   c = a threshold (we compare x > c)
#   b = a multiplier (we multiply x by it)
#   r = a running total (we add to it)
#
# So the function is:
#   for each number in a list, if it exceeds a threshold,
#   add it (times a multiplier) to a running total. Return the total.
#
# Same code, RENAMED for the reader:
def sum_weighted_above_threshold(numbers, weight, threshold=0):
    total = 0
    for value in numbers:
        if value > threshold:
            total += value * weight
    return total

# Identical behaviour. Vastly different readability.
data = [3, -1, 8, 2, -5, 10]
print(f(data, 2, 0))                                # 46
print(sum_weighted_above_threshold(data, 2, 0))     # 46

# Train yourself: every time you read hostile code, mentally rename
# while you read. Eventually it becomes automatic.',
 'python', 8, 20),

(@rc_id,
 'Reading AI-Generated Code',
 'Half the code you encounter in 2026 was written by an AI. Some of it is excellent. Some of it is subtly wrong in ways the AI cannot detect. The Anthropic 2026 RCT found that students who used AI scored 17% lower on debugging questions because they did not learn to spot AI errors. The skill of reading AI-generated code is now essential, and it has its own techniques.\r\n\r\nFirst: AI code is often plausible but uses imaginary functions or libraries. Always verify imports and function names. Second: AI tends to include "defensive" code that looks careful but is often wrong (try/except blocks that swallow real errors, validations that contradict the function''s contract). Third: AI is great at common patterns but bad at unusual edge cases — read the boundaries (empty input, negative numbers, missing keys) extra carefully.\r\n\r\nThe rule: READ EVERY LINE the AI produced. If you would not have written it that way, ask why. If you do not understand it, do not paste it. AI is a typist that knows a thousand languages shallowly — your job is to be the senior engineer reviewing its work.',
 '# A snippet that LOOKS like real AI-generated code. Read it carefully.
# Find at least three things to question.

def get_user_email(users, user_id):
    """Look up a user''s email by their ID."""
    try:
        for user in users:
            if user["id"] == user_id:
                return user.get("email", "").strip().lower()
        return None
    except Exception as e:
        print(f"Error: {e}")
        return ""

# Three things to question:
#
# 1. The try/except catches ALL exceptions including KeyboardInterrupt,
#    SystemExit, and any real bug. That hides crashes you NEED to see.
#
# 2. On error, it returns "" — but on "not found" it returns None.
#    Two different "no result" values is a future bug factory.
#
# 3. The function lowercases the email — but does it always make sense?
#    If the user typed their email in mixed case for display purposes,
#    you might be storing/comparing against the WRONG case downstream.
#
# A senior engineer reading this would ask:
#   - Why catch all exceptions?
#   - Why two "missing" values?
#   - Was the case-normalization a deliberate choice or an AI habit?
#
# Always interrogate AI code like this. Plausible code is not correct code.

# Test the function to see the inconsistency
users = [{"id": 1, "email": " Alice@Example.COM "}]
print(repr(get_user_email(users, user_id=1)))    # "alice@example.com"
print(repr(get_user_email(users, user_id=99)))   # None
# Inconsistent return type already proves point #2.',
 'python', 9, 25),

(@rc_id,
 'The Five-Minute Rule',
 'When you encounter unfamiliar code, give yourself exactly five minutes of focused reading before you do anything else. Not 30 seconds of skim before reaching for ChatGPT. Not an hour of agony before asking. Five minutes of disciplined detective work.\r\n\r\nThe five minutes go like this. Minute 1: find the entry point and the names. Minute 2: read the signatures of the relevant functions. Minute 3: pick the one most likely to contain what you need; trace it. Minute 4: predict what it does, then verify by running or by reading more carefully. Minute 5: write down (literally) what you now think the code does, in plain English.\r\n\r\nAt the five-minute mark, decide. Did you understand enough? Great, move on. Still stuck? Now you can ask for help — and you will ask much better questions because you spent five minutes building context. "I read this function and I think it does X, but for inputs like [3, 4] I expected 7 and got 10. Where am I wrong?" is a question any senior or AI can answer instantly. "It does not work" is not.\r\n\r\nThis is the capstone of the course. Five minutes of disciplined reading beats 50 minutes of frustrated trial-and-error. Practice the discipline and you will outpace people who started coding before you did.',
 '# Final exercise — apply EVERYTHING from this course to this code.
# Set a 5-minute timer. Read like a detective. Predict the output.

class ShoppingCart:
    def __init__(self):
        self._items = {}

    def add(self, name, price, qty=1):
        if name in self._items:
            self._items[name]["qty"] += qty
        else:
            self._items[name] = {"price": price, "qty": qty}

    def remove(self, name):
        self._items.pop(name, None)

    def total(self):
        return sum(item["price"] * item["qty"] for item in self._items.values())

    def apply_coupon(self, code):
        coupons = {"WELCOME10": 0.9, "BIGSAVE": 0.75}
        if code in coupons:
            return self.total() * coupons[code]
        return self.total()


cart = ShoppingCart()
cart.add("book", 10.00, qty=2)
cart.add("pen",  2.50)
cart.add("book", 10.00)       # ← read this carefully
cart.remove("notebook")        # ← and this
print(cart.total())
print(cart.apply_coupon("WELCOME10"))
print(cart.apply_coupon("UNKNOWN"))

# Apply your tools:
#   1. Read the names: ShoppingCart, add, remove, total, apply_coupon
#   2. Find entry point: the last 7 lines
#   3. Trace through cart by hand
#   4. Predict each print() output BEFORE running
#
# Predictions you should reach:
#   - cart contains: book qty=3, pen qty=1  (book was added twice, "notebook" was never there)
#   - total = 30 + 2.50 = 32.50
#   - WELCOME10 → 32.50 * 0.9 = 29.25
#   - UNKNOWN   → 32.50 (no coupon applied)
#
# You have just read an entire class without anyone helping.
# That is the skill. Now go read every codebase in the world.',
 'python', 10, 30);

SELECT id, title, lessons FROM courses WHERE id = @rc_id;
SELECT order_num, title, xp_reward FROM lessons WHERE course_id = @rc_id ORDER BY order_num;
