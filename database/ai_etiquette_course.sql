-- =============================================================
-- CODER — ai_etiquette_course.sql
-- "AI Pair-Programming Etiquette" — 8 lessons grounded in the
-- Anthropic 2026 RCT (n=52, d=0.738) showing AI-assisted
-- learners scored 17% lower on skill quizzes — UNLESS they
-- used specific high-scoring usage patterns.
--
-- Six patterns from that study, low → high score:
--   AI Delegation              <40%
--   Progressive AI Reliance    <40%
--   Iterative AI Debugging     <40%
--   Conceptual Inquiry         65–86%
--   Hybrid Code-Explanation    65–86%
--   Generation-Then-Comprehension 65–86%
-- =============================================================

USE coder_db;

INSERT IGNORE INTO courses
  (title, description, language, level, duration, lessons, icon, color)
VALUES
  ('AI Pair-Programming Etiquette',
   'Anthropic''s 2026 study showed AI-assisted learners scored 17% LOWER on skill tests than students who struggled alone — unless they used specific habits. This course teaches the habits that make AI a learning amplifier, not a learning replacement.',
   'python',
   'Beginner',
   '2 weeks',
   8,
   'fas fa-robot',
   '#f97316');

SET @aie_id := (SELECT id FROM courses WHERE title = 'AI Pair-Programming Etiquette' LIMIT 1);
DELETE FROM lessons WHERE course_id = @aie_id;

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@aie_id,
 'The 17% Problem',
 'In early 2026, researchers at Anthropic ran a controlled experiment. Fifty-two beginner programmers were asked to learn a new Python library (Trio, for async programming) — half had AI assistance, half did not. After one hour of learning, both groups took a skill quiz on what they had learned.\r\n\r\nThe AI-assisted group scored 17% LOWER. The effect was strong (Cohen''s d = 0.738, p = 0.010), and the biggest gap was on debugging questions. Why? Because the AI-assisted group encountered a median of 1 error during learning. The control group encountered a median of 3. The AI smoothed away the errors — and the errors were the lesson.\r\n\r\nThis is the most important finding in coding-education research right now, and it is the entire reason this course exists. AI is not bad. Lazy AI USAGE is bad. The same study found that learners who used specific habits — asking the AI to explain instead of code, generating then reading, asking for concepts not solutions — scored significantly BETTER than the control. So the goal of this course is simple: teach you the habits that put you in the upper half, not the lower half.',
 '# A demonstration of the 17% gap in two cells.

# === Lazy AI usage ===
# Student to AI: "write a function to find duplicates in a list"
def find_duplicates(lst):
    seen = set()
    dupes = set()
    for x in lst:
        if x in seen:
            dupes.add(x)
        seen.add(x)
    return list(dupes)

# Student pastes, runs, it works, moves on.
print(find_duplicates([1, 2, 3, 2, 4, 3]))

# What was learned? Almost nothing. The student does not know
# WHY sets are O(1) lookup, does not know what happens with
# unhashable items, did not encounter any error.

# === Skilled AI usage (next lessons teach these moves) ===
# Student to AI: "I have a list and I want to find duplicates.
#                 What is the SIMPLEST WAY conceptually?"
# AI: "Track items you''ve seen. Anything you see twice is a dupe."
# Student: writes it themselves, gets a bug, fixes it, NOW understands.

def find_duplicates_learned(lst):
    seen = set()
    duplicates = []
    for x in lst:
        if x in seen and x not in duplicates:
            duplicates.append(x)
        seen.add(x)
    return duplicates

print(find_duplicates_learned([1, 2, 3, 2, 4, 3]))

# Same output. Wildly different learning. That is the gap.',
 'python', 1, 15),

(@aie_id,
 'Pattern 1 — Conceptual Inquiry (Score 86%)',
 'The highest-scoring usage pattern in the Anthropic study was called Conceptual Inquiry. It is exactly what it sounds like: students asked the AI to explain CONCEPTS, not to produce CODE. "What is async/await?" "Why would I use a generator instead of a list?" "What is the difference between a set and a list for lookup?".\r\n\r\nThis works because the student stays in the driver''s seat. They learn the idea, then they apply the idea themselves. The AI is acting as a tutor, not a typist. The student still has to translate concept into code, which is where most of the learning happens.\r\n\r\nThe rule is simple. Before you ask AI to write code, ask it to explain the IDEA you need. Then write the code yourself. If you get stuck, ask another concept question. Save the "give me the code" requests for late in the process, when you understand what you are asking for.',
 '# Conceptual Inquiry in action.
# You are stuck — your loop runs but the final answer is wrong.

# === Bad question ===
# "Fix this code for me: [paste 50 lines]"
# What AI does: rewrites half of it, you do not know what changed.

# === Conceptual Inquiry ===
# "I have a loop that should count even numbers, but my counter
#  is always 0. What CONCEPTS should I check?"
# AI: "Look at three things — (1) is the loop running at all?
#       (2) is your condition checking what you think? (3) where
#       are you incrementing the counter and is it inside the loop?"
# YOU: go check those three things yourself.

# Demo — a buggy loop, then fixed via conceptual inquiry
numbers = [3, 6, 1, 8, 2]
count = 0
for n in numbers:
    if n % 2 == 0:
        count = 0          # ← bug, but concept question helps you find it
        count += 1

print(f"Even count: {count}")

# Concept #3 from the AI: "where are you incrementing — is it inside?"
# You re-read your loop, see count = 0 inside the loop. AHA.
# You fix it yourself. You will never make this mistake again.

count = 0
for n in numbers:
    if n % 2 == 0:
        count += 1
print(f"Fixed even count: {count}")        # 2

# Conceptual Inquiry preserves the "I figured it out" moment.
# That moment is where the learning lives.',
 'python', 2, 15),

(@aie_id,
 'Pattern 2 — Generation-Then-Comprehension (Score 75%)',
 'The second high-scoring pattern is Generation-Then-Comprehension. You let the AI write some code, but then — before you run it, before you ship it — you READ EVERY LINE and explain it back to yourself out loud. Only then do you accept it.\r\n\r\nThe Anthropic study found that students who did this scored almost as well as students who never used AI. The reason: explaining the code to yourself triggers the same comprehension process as writing it from scratch. You still build the mental model. You just skipped the typing.\r\n\r\nThe danger pattern is "AI Delegation" (score <40%) — copy, paste, run, move on. You did not read it. You did not understand it. The next time you need this pattern you cannot reproduce it. You have outsourced your skill.',
 '# Generation-Then-Comprehension in practice.

# AI was asked: "give me a Python function that finds the longest
#                consecutive run of the same character in a string"

# AI returns:
def longest_run(s):
    if not s:
        return 0
    best = 1
    current = 1
    for i in range(1, len(s)):
        if s[i] == s[i-1]:
            current += 1
            if current > best:
                best = current
        else:
            current = 1
    return best

# STOP. Do not run it yet. Read every line and tell yourself what it does:
#
#   if not s: return 0
#     → handle empty string edge case
#
#   best = 1; current = 1
#     → if the string has 1 char, the longest run is 1
#
#   for i in range(1, len(s)):
#     → start at index 1 so we can look BACK to s[i-1]
#
#   if s[i] == s[i-1]: current += 1
#     → same character as previous → extend current run
#
#   if current > best: best = current
#     → keep the maximum run seen so far
#
#   else: current = 1
#     → different character → restart the current run counter
#
#   return best
#     → final answer
#
# NOW run it. You will not just have the answer — you will have learned
# the "track current vs best as you sweep" pattern, which appears
# everywhere in coding.

print(longest_run("aaabbcccccd"))   # 5
print(longest_run("abcdef"))         # 1
print(longest_run(""))                # 0',
 'python', 3, 20),

(@aie_id,
 'Pattern 3 — Hybrid Code-Explanation (Score 65%)',
 'The third high-scoring pattern is Hybrid Code-Explanation. You ask the AI for code AND a line-by-line explanation in the same response. You read both side by side. Now the AI is not just a code generator — it is a teacher narrating its own work.\r\n\r\nThis works because the explanation forces the AI to commit to a justification for each line. It also catches AI hallucinations — if the AI cannot explain why it called a function that does not exist, you will spot it. And it gives you a permanent learning artifact: the next time you see similar code, you have the narration in your memory.\r\n\r\nThe prompt template is: "Write [thing]. After the code, explain each line in plain English." Use that template. Always.',
 '# Example of what to expect when you use Hybrid Code-Explanation.

# YOU: "Write a Python function that returns the most common word
#        in a string. After the code, explain each line."

# AI:
def most_common_word(text):
    words = text.lower().split()            # (1)
    counts = {}                              # (2)
    for word in words:                       # (3)
        counts[word] = counts.get(word, 0) + 1   # (4)
    return max(counts, key=counts.get)      # (5)

# Explanation (this is what to ASK FOR — and what to READ):
#   (1) Lowercase the text so "The" and "the" count as the same word.
#       Split on whitespace into a list of words.
#   (2) Create an empty dictionary to count occurrences.
#   (3) Loop over every word in the list.
#   (4) Look up the current count for this word (0 if not seen yet)
#       and add 1. Store the new count.
#   (5) max() picks the key with the highest value, using counts.get
#       as the comparison function. Returns the word, not the count.

# Now you understand all 5 lines. You learned dict.get(), the count
# pattern, AND max() with a key function. One AI call → three concepts.

print(most_common_word("the cat and the dog and the bird"))   # "the"

# Always ask for explanation. It costs almost nothing and turns
# every AI interaction into a tutoring session.',
 'python', 4, 20),

(@aie_id,
 'Anti-Pattern — AI Delegation',
 'AI Delegation is the lowest-scoring pattern in the Anthropic study (<40% on the skill quiz). It is also the most natural and most dangerous: tell the AI what you want, paste the answer, ship it, never look back. The student becomes a project manager for an AI that codes faster than they can think.\r\n\r\nWhy is this bad? Three reasons. (1) You do not learn. You see the output but not the path. (2) You cannot debug your own code, because it is not really your code. (3) You become a worse engineer over time — every Delegation-shaped problem you handle removes a learning opportunity that would have made you stronger.\r\n\r\nThe specific symptom is this: you write a one-line prompt, the AI writes 50 lines, you scroll past them, click run, and move on. If you have done this, you are in the bottom half of the 2026 study. The good news: this is a habit, not a personality. Catch yourself doing it and switch to one of the high-scoring patterns. Five seconds of effort.',
 '# Notice the anti-pattern in yourself. Both code samples are identical.
# The difference is what the LEARNER did with them.

# === Anti-pattern (Delegation) ===
# Student typed: "function to parse a date string in YYYY-MM-DD format"
# AI returned:
from datetime import datetime
def parse_date(text):
    return datetime.strptime(text, "%Y-%m-%d")

result_a = parse_date("2026-06-16")
print(result_a)

# Student ran it, saw it worked, closed the tab. Two weeks later
# they are asked to parse "16/06/2026" and they have no idea where
# to start. Why? They never saw what %Y-%m-%d meant.

# === Right pattern (Hybrid Code-Explanation) ===
# Same code, but the student typed:
#   "function to parse a date string in YYYY-MM-DD format.
#    Explain what the format string means."
# AI returned the code AND:
#   "%Y = 4-digit year, %m = 2-digit month, %d = 2-digit day.
#    strptime parses a string into a datetime according to the format."

# Two weeks later, the student needs to parse "16/06/2026" and they
# instantly know they need "%d/%m/%Y". Same code. Different learning.

result_b = datetime.strptime("16/06/2026", "%d/%m/%Y")
print(result_b)

# This is what the 17% gap looks like in practice.',
 'python', 5, 20),

(@aie_id,
 'The Three Contexts',
 'When you DO need the AI to write code for you, prompt quality determines result quality. Research by Geng et al. (2025) found that novice programmers wrote "Low Context" prompts 28% of the time vs 8% for experienced students — and the difference was three specific kinds of context they forgot to include.\r\n\r\nThe FEATURE context: what is the user-facing goal? "I want a button that adds items to a cart" is feature context. The CODEBASE context: what does the existing code look like? "This is a Flask app using SQLAlchemy" is codebase context. The CONSTRAINT context: what limits matter? "It must run in Python 3.10, no external dependencies" is constraint context.\r\n\r\nA prompt with all three is twice as long as a typical beginner prompt and produces dramatically better results. Always give all three. It costs ten seconds. It saves ten minutes.',
 '# Compare two prompts and the kind of code each produces.

# === Low-context prompt (what novices type) ===
# "write a function to check if a user is logged in"
# AI will guess: maybe checks a session, maybe a cookie, maybe a JWT.
# You will get something but it may not fit your app at all.

# === Three-context prompt ===
# "FEATURE: A homepage that shows different content for logged-in users.
#  CODEBASE: Flask app, using flask_login, user model has an `is_active`
#            field, sessions stored in Flask''s default session.
#  CONSTRAINT: Must return a Python boolean. Cannot make a DB query
#              (this runs in a hot path)."
# AI will produce:
from typing import Optional

def is_logged_in(session: dict) -> bool:
    """Check login by inspecting the session only. No DB call."""
    user_id = session.get("user_id")
    return user_id is not None and session.get("is_active", False)

# Test
print(is_logged_in({"user_id": 42, "is_active": True}))   # True
print(is_logged_in({"user_id": 42, "is_active": False}))  # False
print(is_logged_in({}))                                    # False

# Notice what the three contexts bought you:
#   - The code uses session (FEATURE matched)
#   - It uses flask_login conventions (CODEBASE matched)
#   - It avoids DB queries (CONSTRAINT respected)
#
# Practice: every AI prompt, count to three. Feature, codebase, constraint.',
 'python', 6, 20),

(@aie_id,
 'Spot the Hallucinated API',
 'AI models invent function names. They invent library APIs. They invent command-line flags. They do it confidently. The technical name for this is "hallucination" — and the cost of trusting it without verifying is wasted hours debugging code that was wrong from the first line.\r\n\r\nThe signs of an AI hallucination: (1) the function name is suspiciously perfect for your request — "exactly_what_i_need()" — without you ever having seen it before. (2) The import path is plausible but wrong: `from datetime.parser import parse` does not exist (it is `from dateutil.parser import parse`). (3) A real library has an extra method that you cannot find in the docs.\r\n\r\nThe rule: every function name and every import the AI gives you, verify in the real documentation BEFORE you run the code. Twenty seconds of `Ctrl+F` on the official docs saves an afternoon of "why does this import not work?".',
 '# Three snippets that LOOK fine. One has a real hallucination.

# === Snippet 1 ===
# AI gave: "Use json.loads to parse a JSON string"
import json
result_a = json.loads(''{"name": "Ahmed", "age": 25}'')
print(result_a)
# REAL — json.loads exists. Verify by Ctrl+F on docs.python.org/json

# === Snippet 2 ===
# AI gave: "Use random.shuffle to randomize a list"
import random
arr = [1, 2, 3, 4, 5]
random.shuffle(arr)
print(arr)
# REAL — random.shuffle exists.

# === Snippet 3 ===
# AI gave: "Use list.find(x) to get the position of x in a list"
arr2 = [10, 20, 30]
try:
    idx = arr2.find(20)        # ← HALLUCINATION
    print(idx)
except AttributeError as e:
    print(f"AI hallucinated: {e}")
    print("The REAL method is arr.index(20):")
    print(arr2.index(20))

# This is a textbook hallucination. Strings have .find(). Lists
# do not. The AI conflated them because they "feel" similar. To
# the AI, both are "search for an item in a sequence" — close
# enough in pattern, wrong in reality.
#
# Always verify. Especially when the method name sounds too convenient.',
 'python', 7, 20),

(@aie_id,
 'The AI-Off Challenge',
 'The capstone for this course is also the simplest exercise: turn the AI OFF for one full coding session. No Copilot. No ChatGPT. No tab to paste into. Just you, the docs, and the compiler.\r\n\r\nWhy? Because the Anthropic study found one consistent thing across all six patterns — the WORST scores went to learners who used AI for everything, the BEST scores went to learners who knew when not to. The skill of knowing when not to use AI is itself worth building. The way to build it is to occasionally remove the tool and remember what you can do without it.\r\n\r\nMake this a weekly habit. One coding session a week, AI off. Notice what feels hard. Notice what you reach for that is not there. Notice how much faster you read documentation when there is no shortcut. Those are the skills atrophying when AI is always on, and one hour a week is enough to keep them strong. Coder will give you BONUS XP for completing lessons in "AI-off mode" — it is the most valuable XP on the platform.',
 '# AI-off practice problem.
# Below is a problem statement. Solve it WITHOUT pasting to any AI.
# Read the problem, plan an approach, write the code, test it.
# Use only what you can find in the official Python docs.

# === Problem ===
# Write a function `summarize_lengths(words)` that takes a list
# of strings and returns a dictionary mapping each unique LENGTH
# to the COUNT of words with that length.
#
# Example: summarize_lengths(["cat", "dog", "bird", "ox"])
# Returns: {3: 2, 4: 1, 2: 1}    (cat & dog are length 3, bird is 4, ox is 2)
#
# Constraints:
#   - Pure Python, no imports
#   - Handle the empty list correctly
#   - Order of dict keys does not matter

# === Try it yourself first. Then compare with this solution ===
def summarize_lengths(words):
    counts = {}
    for w in words:
        length = len(w)
        counts[length] = counts.get(length, 0) + 1
    return counts

print(summarize_lengths(["cat", "dog", "bird", "ox"]))
print(summarize_lengths([]))
print(summarize_lengths(["a", "bb", "ccc", "dd", "eee", "f"]))

# Did you solve it without AI? Great — that is the skill.
# Was it slower than using AI? Yes — but you learned the pattern,
# and the pattern stays.
#
# Course complete. You now know:
#   - Why AI can hurt learning if used lazily
#   - Three high-scoring usage patterns (Conceptual Inquiry,
#     Generation-Then-Comprehension, Hybrid Code-Explanation)
#   - One critical anti-pattern (AI Delegation)
#   - The three contexts to always include in prompts
#   - How to spot hallucinated APIs
#   - The discipline of regular AI-off sessions
#
# Be the programmer in the upper half of the study. Always.',
 'python', 8, 35);

SELECT id, title, lessons FROM courses WHERE id = @aie_id;
SELECT order_num, title, xp_reward FROM lessons WHERE course_id = @aie_id ORDER BY order_num;
