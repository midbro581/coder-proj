-- =============================================================
-- CODER — computational_thinking_course.sql
-- "Think Like a Coder" — 10 lessons that teach problem-solving
-- BEFORE syntax, the missing prerequisite to every other course.
--
-- Research backing:
--   - Perkins & Martin 1986 (fragile knowledge & neglected strategies)
--   - Pea 1986 (novice mistakes are conceptual, not syntactic)
--   - Xie & Loksa (decompose-before-write theory of instruction)
-- =============================================================

USE coder_db;

INSERT IGNORE INTO courses
  (title, description, language, level, duration, lessons, icon, color)
VALUES
  ('Think Like a Coder',
   'Before you write a single line, learn how programmers actually THINK. Decomposition, pattern recognition, abstraction, pseudocode — the invisible skills that decide whether you finish a problem in 5 minutes or get stuck for 5 hours.',
   'python',
   'Beginner',
   '3 weeks',
   10,
   'fas fa-lightbulb',
   '#eab308');

SET @ct_id := (SELECT id FROM courses WHERE title = 'Think Like a Coder' LIMIT 1);
DELETE FROM lessons WHERE course_id = @ct_id;

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@ct_id,
 'Decomposition — Break the Big Thing Into Small Things',
 'A senior engineer and a beginner sit down to solve the same problem. The beginner stares at the screen and starts typing. The senior writes five bullet points on a piece of paper. The senior finishes first. This is not a personality difference — it is a habit, and you can learn it in one lesson.\r\n\r\nDecomposition means breaking a hard problem into smaller problems that are each obvious. You do not solve "build a chess game". You solve "draw a board", then "place pieces on the board", then "let a player click a piece", then "validate the move", then... none of those alone is hard. Together they are a chess game.\r\n\r\nThe rule: if a problem feels overwhelming, the unit is too big. Cut it in half. Then cut each half. Keep cutting until each piece feels almost trivial. THEN you start coding.',
 '# Decomposition demo — write a tip calculator.

# === The big problem ===
# "Build a program that asks for a meal price and tip percent,
#  and prints the total with tip."

# Resist the urge to type. Decompose first.
#
# Sub-problems:
#   (1) Get the meal price from somewhere (input or hardcoded)
#   (2) Get the tip percent
#   (3) Calculate the tip amount = price * percent / 100
#   (4) Calculate the total = price + tip amount
#   (5) Format the result with two decimal places
#   (6) Print it

# Now each sub-problem is a single line. Watch:

def tip_calculator(price, tip_percent):
    tip_amount = price * tip_percent / 100      # (3)
    total      = price + tip_amount             # (4)
    formatted  = f"${total:.2f}"                # (5)
    return formatted                            # (6)

# Test cases — (1) and (2) are just inputs we pass in
print(tip_calculator(50.00, 15))    # $57.50
print(tip_calculator(120.00, 20))   # $144.00
print(tip_calculator(8.50, 10))     # $9.35

# Six bullet points → six lines of code. The decomposition WAS
# the program. Coding it was the easy part.',
 'python', 1, 15),

(@ct_id,
 'Pattern Recognition',
 'Most problems you will solve in your career are not new. They are old problems wearing new costumes. Pattern recognition is the skill of noticing "this is just a sorting problem", "this is just a counting problem", "this is just a graph traversal" — and then reaching for the well-known solution instead of inventing one from scratch.\r\n\r\nThe most common beginner patterns: counting how many times something happens (use a dict), finding the largest/smallest (use a running max/min), removing duplicates (use a set), checking if two things match (compare). Once these are in your toolkit, you start seeing them everywhere. "Count the most common word", "find the longest streak", "remove repeated characters" — all the same patterns under different names.\r\n\r\nThe more patterns you know, the more problems look familiar. Every time you solve a new problem, write down: "this was an X pattern". After 50 problems, the next 50 take half the time.',
 '# Three different-looking problems. Notice — they are all the
# SAME pattern: "count how many of each thing".

# Pattern: count each unique thing in a collection
def count_each(items):
    counts = {}
    for x in items:
        counts[x] = counts.get(x, 0) + 1
    return counts

# Problem 1: How many of each fruit?
fruits = ["apple", "banana", "apple", "cherry", "banana", "apple"]
print(count_each(fruits))
# {''apple'': 3, ''banana'': 2, ''cherry'': 1}

# Problem 2: How many of each grade did the class get?
grades = ["A", "B", "A", "C", "A", "B", "F"]
print(count_each(grades))
# {''A'': 3, ''B'': 2, ''C'': 1, ''F'': 1}

# Problem 3: How often does each character appear?
text = "mississippi"
print(count_each(list(text)))
# {''m'': 1, ''i'': 4, ''s'': 4, ''p'': 2}

# THREE problems → ONE pattern. Once you see it, you cannot un-see it.
# Most programming careers are made of recognizing 30-40 such patterns.',
 'python', 2, 15),

(@ct_id,
 'Abstraction — Hide the Boring Stuff',
 'Abstraction is the act of giving a complicated thing a simple name so you can think about it without remembering its insides. When you write `print("hello")`, you are using an abstraction — somewhere inside `print` there are thousands of lines of code that figure out fonts, terminal encodings, and operating system calls. You do not care. You just want hello on the screen.\r\n\r\nAs a programmer, you do this all the time. You write a function to "format a phone number" — that is now an abstraction. Anywhere else in your code, you write `format_phone(...)` and forget how it works. Your brain is freed up to think about the bigger problem.\r\n\r\nThe rule for using abstraction well: if you have done the same thing twice, give it a name. If you have written the same five lines in three places, those five lines want to be a function. Good abstraction makes programs short and easy to change. Bad abstraction (named badly, doing too many things) makes programs WORSE — so name carefully.',
 '# Without abstraction
total_a = 10 * 0.05 + 10
total_b = 25 * 0.05 + 25
total_c = 8 * 0.05 + 8
print(f"Receipts: ${total_a:.2f}, ${total_b:.2f}, ${total_c:.2f}")
# Five percent appears three times. If the tax rate changes, you
# update three places. If you forget one, silent bug.

# With abstraction
TAX_RATE = 0.05

def with_tax(price):
    return price + price * TAX_RATE

total_a = with_tax(10)
total_b = with_tax(25)
total_c = with_tax(8)
print(f"Receipts: ${total_a:.2f}, ${total_b:.2f}, ${total_c:.2f}")

# Same result, but now:
#   - "with tax" is a NAMED idea
#   - Tax rate is ONE place to change
#   - The rest of the code talks about prices, not multiplication

# Abstraction is how 100,000-line programs are possible. Without it,
# a brain cannot hold the whole thing. With it, every level looks small.',
 'python', 3, 15),

(@ct_id,
 'Pseudocode — Write Before You Code',
 'Professional programmers write before they code. Not always in pseudocode — sometimes a paragraph of English, sometimes a sketch on paper, sometimes bullet points in a comment. But always SOMETHING before they touch the keyboard. The act of writing the steps forces precision and reveals holes in your plan before they become bugs.\r\n\r\nPseudocode is not a language. It is plain English written in a code-like shape. It does not have to be syntactically correct — it just has to be unambiguous. "FOR each item in the list, IF the price is above 100, ADD it to the expensive list, RETURN expensive list at the end" — that is pseudocode. You could implement it in Python, Java, JavaScript, or Swahili. The thinking is done.\r\n\r\nWhen you struggle with a problem, the cure is almost always: write pseudocode. If you cannot write pseudocode, you do not yet understand the problem — and code will not save you.',
 '# Problem: given a list of numbers, return the SUM of the squares
# of the numbers that are GREATER than the average.
#
# Step 1 — write pseudocode (in a comment, in plain English):
#
#   compute the average
#   for each number:
#     if it is greater than average:
#       square it
#       add to a running total
#   return the total

# Step 2 — translate one bullet at a time into Python:

def sum_of_above_avg_squares(numbers):
    average = sum(numbers) / len(numbers)        # "compute the average"
    total = 0                                    # running total
    for n in numbers:                            # "for each number"
        if n > average:                          # "if it is greater than average"
            total += n * n                       # "square it, add to total"
    return total                                 # "return the total"

print(sum_of_above_avg_squares([1, 2, 3, 4, 5]))   # avg=3 → above is 4,5 → 16+25 = 41
print(sum_of_above_avg_squares([10, 10, 10]))      # all equal → above is none → 0

# Notice — once the pseudocode was right, writing the Python took
# 30 seconds. The thinking was done before the typing started.
# That is why pros are fast: they think first.',
 'python', 4, 20),

(@ct_id,
 'Edge Cases — The Bug Factory',
 'When you finish coding the "happy path" (the case you imagined), your work is half done. The other half is finding the EDGE CASES — the inputs you did not imagine. Empty list. Single item. Negative number. Zero. Duplicates. Sorted backwards. The string "". The character "💩". The very-large-number case. The slow-network case.\r\n\r\nMost real-world bugs are edge cases. Most interview rejections are edge cases. Most production fires are edge cases. The skill of stopping after you have the happy path and ASKING "what could break this?" separates intermediates from beginners.\r\n\r\nA mental checklist: for any function I just wrote, what happens with EMPTY input? With ONE item? With duplicates? With the type I did not expect (string instead of int)? With the value at the boundary (0, -1, MAX_INT)? Run those cases. Fix what breaks. Now ship.',
 '# A function that "works" — until you try the edge cases.

def average(numbers):
    return sum(numbers) / len(numbers)

# Happy path — works
print(average([2, 4, 6]))    # 4.0

# Edge cases — run them ALL before declaring victory
edge_cases = [
    ("empty list",        []),
    ("single item",       [42]),
    ("negative numbers",  [-3, -1, -5]),
    ("zero",              [0]),
    ("floats",            [1.5, 2.5, 3.5]),
    ("huge numbers",      [10**18, 10**18, 10**18]),
    ("duplicates",        [5, 5, 5, 5]),
]

for desc, case in edge_cases:
    try:
        print(f"  {desc:<20} → {average(case)}")
    except Exception as e:
        print(f"  {desc:<20} → CRASH: {type(e).__name__}: {e}")

# The empty list case crashes. Fix it:
def average_safe(numbers):
    if not numbers:
        return None       # or 0, or raise — pick a CONTRACT and document it
    return sum(numbers) / len(numbers)

print(average_safe([]))           # None — handled
print(average_safe([2, 4, 6]))    # 4.0 — still works

# Five edge cases checked → one bug found. Always check the edges.',
 'python', 5, 20),

(@ct_id,
 'The "Brute Force First" Rule',
 'When you face a problem and you can think of a slow ugly solution, WRITE THE SLOW UGLY SOLUTION FIRST. Get it working. Make it pass the tests. Then — and only then — make it elegant or fast.\r\n\r\nBeginners get stuck because they try to invent the clever solution from a blank page. Pros get unstuck because they always have a working solution to look at, even if it is embarrassing. Working code is infinitely more valuable than imagined code.\r\n\r\nThe phrase is "first make it work, then make it right, then make it fast" — in that order. Most "fast" code in the world started as someone''s slow draft that they were not afraid to write.',
 '# Problem: find the two numbers in a list that add up to a target.
# (Famous LeetCode #1 "Two Sum".)

# === Brute force first — try every pair ===
def two_sum_brute(numbers, target):
    for i in range(len(numbers)):
        for j in range(i + 1, len(numbers)):
            if numbers[i] + numbers[j] == target:
                return [i, j]
    return None

# It works. Slow on big inputs (O(n²)), but it WORKS.
print(two_sum_brute([2, 7, 11, 15], 9))    # [0, 1]
print(two_sum_brute([3, 2, 4], 6))         # [1, 2]

# Now MAKE IT FAST — once you understand the problem.
# Insight: for each number, you know what its partner must be (target - n).
# Track numbers you have seen in a dict so lookup is O(1).
def two_sum_fast(numbers, target):
    seen = {}                              # number → its index
    for i, n in enumerate(numbers):
        complement = target - n
        if complement in seen:
            return [seen[complement], i]
        seen[n] = i
    return None

print(two_sum_fast([2, 7, 11, 15], 9))    # [0, 1]
print(two_sum_fast([3, 2, 4], 6))          # [1, 2]

# The brute force taught you the problem. The fast version was easy
# to write AFTER you understood it. Trying to write the fast version
# first is how beginners get stuck for an hour. Brute force first.',
 'python', 6, 25),

(@ct_id,
 'Small Steps, Tested Often',
 'A program is a tower of small pieces. If you build the whole tower and then test, when it falls you have NO IDEA which piece was the problem. If you build one piece and test, build one piece and test, when something fails you know exactly where.\r\n\r\nThis is one of the most important habits in coding. Write 5 lines. Run them. See the output. Are you on track? Yes? Write 5 more. No? Fix it now while the change is fresh in your mind. Compare this to writing 50 lines, hitting an error, and having no idea which of those 50 lines is wrong — that is the difference between a 5-minute debug and a 50-minute debug.\r\n\r\nThe ultimate version of this is Test-Driven Development: write a tiny test FIRST, watch it fail, then write the code that makes it pass, then write the next test. But even without formal TDD, the habit of "write a little, run it, see it, write a little more" pays for itself the first time you avoid a multi-hour debugging session.',
 '# Building a function "small steps, tested often" — narrated.

# === Step 1: skeleton ===
def is_palindrome(s):
    return False    # always wrong, but the function exists

print("Step 1:", is_palindrome("hello"))   # False
# OK, function exists, returns something.

# === Step 2: handle the obvious case ===
def is_palindrome(s):
    return s == s[::-1]

print("Step 2:", is_palindrome("racecar"))  # True ✓
print("Step 2:", is_palindrome("hello"))    # False ✓
# Two checks pass. Move on.

# === Step 3: handle edge case — empty string and single char ===
print("Step 3:", is_palindrome(""))          # True ✓ (empty == empty reversed)
print("Step 3:", is_palindrome("a"))         # True ✓

# === Step 4: handle case sensitivity and spaces ===
def is_palindrome(s):
    cleaned = "".join(ch for ch in s.lower() if ch.isalnum())
    return cleaned == cleaned[::-1]

print("Step 4:", is_palindrome("A man a plan a canal Panama"))   # True ✓
print("Step 4:", is_palindrome("racecar"))                       # True ✓
print("Step 4:", is_palindrome("hello"))                         # False ✓

# Each step: small change, immediate test. If step 4 had broken
# step 3, you would have known instantly. That is the discipline.',
 'python', 7, 20),

(@ct_id,
 'Naming — Where Half of Code Quality Lives',
 'There is a famous joke: "There are only two hard problems in computer science: cache invalidation, naming things, and off-by-one errors." Naming is genuinely hard, and getting better at it is one of the highest-leverage skills you can develop.\r\n\r\nGood names share three properties. They are SPECIFIC ("user_id" not "id"). They reveal INTENT ("max_retries" not "n"). They are PRONOUNCEABLE (you can say them in a meeting without sounding ridiculous). A function named `process_user_signup_with_email_verification` is annoying to type but every reader knows exactly what it does. A function named `proc` is fast to type and useless.\r\n\r\nA practical rule: if your code needs a comment to explain what a variable is for, you usually picked the wrong name. Rename the variable so the comment is unnecessary. Your future self (and your teammates) will thank you.',
 '# Same code, three names. Pick the one that needs no comment.

# === Version A — single-letter names ===
def f(d, t):
    n = sum(1 for x in d if x > t)
    return n

print("A:", f([5, 10, 15, 20], 12))   # 2 — but what does that mean?

# === Version B — abbreviations ===
def cnt_abv(dat, thr):
    n = sum(1 for x in dat if x > thr)
    return n

print("B:", cnt_abv([5, 10, 15, 20], 12))   # 2 — still requires guessing

# === Version C — names that speak ===
def count_values_above_threshold(values, threshold):
    return sum(1 for v in values if v > threshold)

print("C:", count_values_above_threshold(values=[5, 10, 15, 20], threshold=12))

# Notice — version C reads like an English sentence at the call site.
# You can drop into the code 6 months later and instantly understand.
# The cost was 18 extra characters. The value is forever.

# The naming heuristic:
#   "Could a new teammate guess what this does from the name alone?"
# If yes → keep it. If no → rename it.',
 'python', 8, 20),

(@ct_id,
 'The "What Would Break This?" Habit',
 'When a senior engineer finishes a function, they do not click "save and move on". They stop, look at the function, and ask themselves: "what would break this?". Then they try those breaks. This habit prevents 80% of bugs from ever shipping.\r\n\r\nIt is the same skill as edge cases (lesson 5), but at a higher level. You are not just listing edge cases — you are PROBING. "What if the network is slow?" "What if two users call this at the same time?" "What if the input has 10 million items?" "What if a user pastes Unicode I have never seen?" Each question becomes a quick test. Each test either passes (great, robust code) or fails (find the next bug before the user does).\r\n\r\nThis is also the question to ask before code review, before merging, before deploying. It is what separates code that runs in development from code that runs in production. Develop the habit and your bug count will collapse.',
 '# Practice the "what would break this?" habit on a payment function.

def charge_credit_card(amount, card_number):
    """Charge the given amount to the card. Returns True on success."""
    if amount > 0 and len(card_number) == 16:
        # ... pretend it talks to a real payment gateway ...
        print(f"  charged ${amount:.2f} to ...{card_number[-4:]}")
        return True
    return False

# Happy path — works
charge_credit_card(50.00, "4111111111111111")

# "What would break this?" — list the threats:
threats = [
    ("zero amount",          0.00,        "4111111111111111"),
    ("negative amount",      -50.00,      "4111111111111111"),
    ("wrong card length",    50.00,       "411111"),
    ("card has letters",     50.00,       "abcd111111111111"),
    ("amount is huge",       10**12,      "4111111111111111"),
    ("amount has 8 decimals",50.12345678, "4111111111111111"),
    ("None instead of str",  50.00,       None),
]

print("\\nThreat tests:")
for desc, amount, card in threats:
    try:
        ok = charge_credit_card(amount, card)
        print(f"  {desc:<22} → {''CHARGED'' if ok else ''rejected''}")
    except Exception as e:
        print(f"  {desc:<22} → CRASH: {type(e).__name__}: {e}")

# Look at the output. The "negative amount" case is rejected — good.
# But "amount is huge" is happily charged. Is that the contract?
# Probably not. You just found a future production bug, BEFORE a user
# accidentally charged themselves a trillion dollars.
#
# That is the habit. Ask, probe, find, fix — before the world does.
# Congrats — you finished Think Like a Coder. Now go build something.',
 'python', 9, 25),

(@ct_id,
 'Putting It All Together',
 'You have learned nine ways of thinking. The final lesson is a single big problem where you use ALL of them. No starter code, no walkthrough — just a problem and the toolkit you built.\r\n\r\nThe problem: Build a program that takes a paragraph of text and returns the THREE MOST COMMON WORDS, ignoring punctuation and case, and excluding common stop words ("the", "and", "is", "a", etc.).\r\n\r\nApproach it the way this course has taught you. (1) Decompose into small subproblems. (2) Recognize patterns — counting, sorting, filtering. (3) Write pseudocode before code. (4) Build small, test often. (5) Try edge cases — empty input, all-stopword input, ties, single word. (6) Name your variables so a teammate could read them. (7) Brute-force a working solution first. (8) Ask "what would break this?" before declaring done.\r\n\r\nIf you finish in 15 minutes, you have absorbed the course. If you finish in 5 minutes, you are ready for any language track on Coder. Below is one solution to compare against AFTER you have tried yours.',
 '# Try yours first. Below is one possible solution.

STOP_WORDS = {"the", "and", "is", "a", "an", "of", "in", "to", "for", "it"}

def top_three_words(text):
    # Step 1: normalize — lowercase and strip punctuation
    cleaned = "".join(ch.lower() if ch.isalnum() or ch == " " else " "
                      for ch in text)

    # Step 2: split into words and drop stop words
    words = [w for w in cleaned.split() if w and w not in STOP_WORDS]

    # Step 3: count each word (the counting pattern)
    counts = {}
    for w in words:
        counts[w] = counts.get(w, 0) + 1

    # Step 4: pick the three highest by count
    sorted_words = sorted(counts.items(), key=lambda pair: -pair[1])
    return [word for word, _ in sorted_words[:3]]


# Test with the happy path
text = ("The quick brown fox jumps over the lazy dog. "
        "The fox is quick and the fox is brown.")
print(top_three_words(text))
# Expected: fox (most common), then brown / quick (tied at 2)

# Edge cases — "what would break this?"
print(top_three_words(""))                          # []
print(top_three_words("the and is"))                # [] — all stop words
print(top_three_words("hello!!! HELLO?? Hello..."))  # ["hello"]
print(top_three_words("a"))                          # [] — stop word

# Reflect:
#   - Decomposition: 4 named steps
#   - Pattern: counting pattern + sorting pattern
#   - Pseudocode: was in the comments before each step
#   - Edge cases: 4 tested explicitly
#   - Naming: cleaned, words, counts, sorted_words — all readable
#   - Brute force: a simpler sorted() call did the job — fast enough
#
# You used every skill from this course in 20 lines of code.
# Welcome to thinking like a programmer.',
 'python', 10, 35);

SELECT id, title, lessons FROM courses WHERE id = @ct_id;
SELECT order_num, title, xp_reward FROM lessons WHERE course_id = @ct_id ORDER BY order_num;
