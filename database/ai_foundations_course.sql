-- =============================================================
-- CODER — ai_foundations_course.sql
-- "AI, ML & LLMs from Scratch" — a 12-lesson course that
-- demystifies AI for absolute beginners and shows them how to
-- build a tiny one with code they can read line by line.
--
-- Designed against research findings:
--   - Sorva 2013 (notional machine — show what's REALLY happening)
--   - Ericson 2022 (predict-then-run scaffolding)
--   - Anthropic 2026 RCT (productive struggle preserved)
--
-- Import via phpMyAdmin → coder_db → Import.
-- Safe to re-run.
-- =============================================================

USE coder_db;

INSERT IGNORE INTO courses
  (title, description, language, level, duration, lessons, icon, color)
VALUES
  ('AI, ML & LLMs from Scratch',
   'Stop being afraid of AI. Learn what a neural network actually is (just math), train one in 20 lines of Python, see what a "token" really looks like, understand why ChatGPT sometimes lies, and build your own tiny chatbot. No PhD required — every concept arrives with code you can read.',
   'python',
   'Beginner',
   '5 weeks',
   12,
   'fas fa-brain',
   '#a855f7');

SET @ai_id := (SELECT id FROM courses WHERE title = 'AI, ML & LLMs from Scratch' LIMIT 1);
DELETE FROM lessons WHERE course_id = @ai_id;

INSERT INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@ai_id,
 'AI is Just Math (Seriously)',
 'There is no magic inside ChatGPT. There is no tiny brain. There is no thinking. Inside an AI is one thing only: numbers being multiplied and added, billions of times per second. That is it.\r\n\r\nA neural network is a giant pile of numbers called WEIGHTS. When you ask it a question, your question is also turned into numbers. Those numbers get multiplied by the weights, added up, passed through a simple math function, multiplied by more weights, added up again — over and over. At the end, the final numbers are turned back into text and shown to you. That is the entire trick.\r\n\r\nWhat makes one AI smarter than another is not better magic — it is having BETTER NUMBERS. Training an AI is the process of slowly adjusting those billions of numbers until the output usually matches what we want. When people say "GPT-5 has 1.7 trillion parameters," they literally mean it has 1.7 trillion numbers inside. That is all parameters are.\r\n\r\nThe moment this clicks — that AI is multiplication, addition, and a lot of patience — most of the mystery disappears. The rest of this course will show you the math, run it, and let you build one yourself.',
 '# An "AI" in 3 lines. Yes, really.
# This is the math at the heart of every neural network — just smaller.

# Inputs (think: pixels of an image, or word numbers)
inputs = [0.5, 0.2, 0.9]

# Weights — the "numbers" we trained earlier
weights = [0.4, 0.7, -0.3]

# Multiply each input by its weight, add them all up
output = sum(i * w for i, w in zip(inputs, weights))

print(f"AI says: {output:.3f}")
# Output: AI says: 0.073

# That is one "neuron". A real network has billions of these,
# stacked into layers, and the weights were tuned over weeks
# on huge computers. But underneath — same math.',
 'python', 1, 10),

(@ai_id,
 'Your First Neuron',
 'A single artificial neuron does exactly three things. Step one: take its inputs and multiply each one by a weight. Step two: add them all together (plus a small extra number called a "bias" that lets the neuron shift its answer up or down). Step three: pass the result through an "activation function" — a simple math function that decides whether the neuron "fires" (gives a strong signal) or stays quiet.\r\n\r\nThe most famous activation function is called ReLU, and it could not be simpler: if the number is negative, return 0. If the number is positive, return it as-is. That is the whole function. Yet ReLU is what powers most modern deep learning. Sometimes the simplest tools win.\r\n\r\nA single neuron can learn a tiny pattern, like "is this number bigger than 5?". A neuron is to AI what a single Lego brick is to a castle — useless alone, world-changing in quantity.',
 '# A single neuron written out, no libraries.

def relu(x):
    # The activation function — "fire" if positive, else stay quiet
    return max(0, x)

def neuron(inputs, weights, bias):
    # Step 1: multiply each input by its weight
    # Step 2: add them up, plus the bias
    total = sum(i * w for i, w in zip(inputs, weights)) + bias
    # Step 3: pass through activation
    return relu(total)

# Try it: detect if the sum of three numbers is "big"
weights = [1.0, 1.0, 1.0]    # treat all inputs equally
bias    = -5.0               # only fire if total > 5

print(neuron([2, 1, 1], weights, bias))   # 0    (small input — quiet)
print(neuron([3, 2, 4], weights, bias))   # 4.0  (big input — FIRES)
print(neuron([2, 2, 1], weights, bias))   # 0    (just below — quiet)

# Congratulations — you built a neuron. The rest of AI is
# combining millions of these and finding good weights automatically.',
 'python', 2, 15),

(@ai_id,
 'Training — How AI "Learns"',
 'Training is just guessing and correcting, very fast, for a very long time. Here is the loop, in plain English:\r\n\r\n  1. Show the network an example.\r\n  2. See what it predicts.\r\n  3. Measure how wrong it was (this number is called LOSS).\r\n  4. Nudge every weight a tiny bit in the direction that would have made the prediction less wrong.\r\n  5. Repeat with the next example. Millions of times.\r\n\r\nThat is it. The "nudging" step uses a famous algorithm called gradient descent, and computing the right nudges across millions of weights is what GPUs are insanely fast at. But the IDEA is just: guess, see how wrong you are, nudge, guess again.\r\n\r\nThis loop also explains why training is so expensive. Big models do this loop billions of times across mountains of data. It also explains why AIs sometimes have weird biases — they only learn from the examples they saw, and they saw whatever the humans collecting the data chose to show them.',
 '# Train one neuron to predict the number 1 when input is 0.5.
# We start with a random weight, then nudge it until the loss is tiny.

weight = 0.1            # start with a random guess
target = 1.0            # what we WANT the output to be when input is 0.5
input_value = 0.5
learning_rate = 0.1     # how big a nudge per step

for step in range(20):
    # Step 1: predict
    prediction = input_value * weight

    # Step 2 & 3: measure how wrong (loss = how far from target)
    loss = target - prediction

    # Step 4: nudge the weight toward the right answer
    weight = weight + learning_rate * loss * input_value

    # Step 5: report
    print(f"Step {step+1:2d}:  weight={weight:.4f}  prediction={prediction:.4f}  loss={loss:+.4f}")

print(f"\\nFinal weight: {weight:.4f}  (real answer: 2.0)")
# After 20 steps, the weight converges to roughly 2.0,
# because 0.5 * 2.0 = 1.0 = target. The "AI" learned.',
 'python', 3, 20),

(@ai_id,
 'A Perceptron That Learns AND',
 'In 1958, Frank Rosenblatt built a machine called the PERCEPTRON. It had a single neuron and could learn simple logical functions — like "AND" (both inputs are true) — entirely from examples, with no human writing the rule. People at the time thought computers were about to become conscious. They were not, but the idea was a real breakthrough: a machine that finds patterns by adjusting its own numbers.\r\n\r\nA perceptron is literally one neuron plus the training loop you saw in the last lesson. You feed it pairs of inputs and the correct output, and it figures out the weights that make its predictions match. This is the simplest "AI that learns from examples" you can build, and it is the great-grandparent of GPT.\r\n\r\nThe code below is under 25 lines. By the end of it, your computer will have figured out the logical AND rule from scratch, with no IF statements telling it the answer. Watch it learn.',
 '# A perceptron that learns the AND function from 4 examples.

# Training data: [input1, input2, correct_answer]
data = [
    [0, 0, 0],   # 0 AND 0 = 0
    [0, 1, 0],   # 0 AND 1 = 0
    [1, 0, 0],   # 1 AND 0 = 0
    [1, 1, 1],   # 1 AND 1 = 1
]

# Random starting weights and bias
w1, w2, bias = 0.0, 0.0, 0.0
learning_rate = 0.1

# Train for 20 passes through all the examples
for epoch in range(20):
    for x1, x2, target in data:
        # Predict — simple step function (output 1 if total >= 0 else 0)
        total = x1 * w1 + x2 * w2 + bias
        prediction = 1 if total >= 0.5 else 0

        # Nudge weights toward the right answer
        error = target - prediction
        w1   += learning_rate * error * x1
        w2   += learning_rate * error * x2
        bias += learning_rate * error

# Test what it learned
print("After training:")
for x1, x2, _ in data:
    total = x1 * w1 + x2 * w2 + bias
    prediction = 1 if total >= 0.5 else 0
    print(f"  {x1} AND {x2} = {prediction}")

print(f"\\nLearned weights: w1={w1:.2f}  w2={w2:.2f}  bias={bias:.2f}")
# It learned AND without anyone writing "if x1 == 1 and x2 == 1".
# That is machine learning.',
 'python', 4, 20),

(@ai_id,
 'What Even is "Data"?',
 'Every AI is what its data made it. If you train it on novels it writes like a novelist. If you train it on code it writes like a coder. If you train it only on cat pictures, ask it about dogs, and you will get nonsense. The phrase "garbage in, garbage out" is the most important sentence in machine learning.\r\n\r\nFor an AI to learn, every piece of data has to become numbers. Images become grids of pixel-brightness numbers. Audio becomes thousands of numbers per second describing the sound wave. Even text becomes numbers — every word or piece of a word is assigned an ID, and that ID is what the network actually sees. The text you read on your screen is for HUMANS. Inside the model, your sentence "Hello, how are you?" is more like [9906, 11, 1268, 527, 499, 30].\r\n\r\nUnderstanding this fixes a huge amount of confusion later. Why do AIs sometimes give weird responses to weird spellings? Because the spelling changed the numbers. Why do they have biases? Because the data they saw had biases. The data is the model.',
 '# Watch text become numbers — a simplified "tokenizer".
# Real LLM tokenizers are more complex but the idea is the same.

# Build a tiny vocabulary mapping characters to numbers
text = "hello, how are you?"
unique_chars = sorted(set(text))
char_to_id = {ch: i for i, ch in enumerate(unique_chars)}
id_to_char = {i: ch for ch, i in char_to_id.items()}

print("Vocabulary:", char_to_id)

# Encode (text → numbers)
encoded = [char_to_id[c] for c in text]
print(f"\\nText:    {text}")
print(f"Numbers: {encoded}")

# Decode (numbers → text) — the reverse
decoded = "".join(id_to_char[n] for n in encoded)
print(f"Back:    {decoded}")

# This is how every text-based AI sees the world.
# Your "hello" is just [4, 2, 5, 5, 8] (or similar) inside the model.
# The model never sees letters — only the integers and their patterns.',
 'python', 5, 15),

(@ai_id,
 'Tokens — How LLMs Actually Read',
 'A large language model like ChatGPT does not read letter by letter. It reads in chunks called TOKENS. A token is usually a short piece of a word — "hello" might be one token, "antidisestablishmentarianism" is several. Common words are usually one token; rare or weird ones get split into smaller pieces.\r\n\r\nThis matters in real life. When you pay for an LLM API, you pay per token, not per word — usually around 0.75 tokens per English word. When a model has a "100k context window", that is 100,000 tokens of memory, which is roughly a long novel. And when you give an LLM a weird spelling or a made-up word, it gets split into unfamiliar pieces and the model often stumbles.\r\n\r\nWhy chunks instead of whole words? Because there are millions of words but only about 50,000 useful sub-pieces — small enough to memorize, large enough to cover every word that has ever existed and many that have not.',
 '# Simulate token-style chunking — split a sentence into common pieces.
# Real tokenizers (BPE, WordPiece) learn the chunks from data;
# we will fake it with a fixed list of common ones.

common_tokens = ["the", "and", "is", "ing", "tion", "un", "re", " ", ",", "."]

def fake_tokenize(text):
    tokens = []
    i = 0
    while i < len(text):
        # Try to match the longest token first
        matched = False
        for tok in sorted(common_tokens, key=len, reverse=True):
            if text[i:i+len(tok)] == tok:
                tokens.append(tok)
                i += len(tok)
                matched = True
                break
        if not matched:
            # Fall back to single character
            tokens.append(text[i])
            i += 1
    return tokens

sentence = "the unreal nation is reading."
tokens = fake_tokenize(sentence)
print(f"Sentence: {sentence}")
print(f"Tokens  : {tokens}")
print(f"Count   : {len(tokens)} tokens for {len(sentence)} characters")

# Real LLMs do this with tens of thousands of learned tokens.
# When you see ChatGPT "type" word by word, it is actually
# emitting one token at a time, one prediction at a time.',
 'python', 6, 15),

(@ai_id,
 'How an LLM Predicts the Next Word',
 'A large language model is — at its core — a NEXT-TOKEN PREDICTOR. You give it a sequence of tokens, and it outputs a probability for every possible next token. Then it picks one (usually the highest probability, sometimes with a bit of randomness for creativity), adds it to the sequence, and repeats.\r\n\r\nThat is literally what is happening when you watch ChatGPT "type". It is not writing a sentence. It is predicting one token, then predicting the next given the new sequence, then the next, then the next. The illusion of fluent thinking is the cumulative effect of being extremely good at "what comes after this?".\r\n\r\nThis also explains why LLMs sometimes get stuck repeating, why they sometimes confidently invent facts (a high-probability token is not a true token), and why a long conversation can drift — every token added to the context changes what the next prediction looks like.',
 '# Simulate "next token prediction" with a tiny lookup table.
# A real LLM has billions of parameters; this has 8 hand-written rules.

next_token_probs = {
    "the":      {"cat": 0.3, "dog": 0.3, "sun": 0.2, "moon": 0.2},
    "cat":      {"sat": 0.5, "ran": 0.3, "ate": 0.2},
    "dog":      {"barks": 0.4, "ran": 0.4, "ate": 0.2},
    "sat":      {"on": 0.7, "down": 0.3},
    "on":       {"the": 0.9, "a": 0.1},
    "ran":      {"away": 0.5, "fast": 0.5},
    "barks":    {"loudly": 0.6, "at": 0.4},
    "ate":      {"food": 0.7, "fish": 0.3},
}

# Pick the highest-probability next token (greedy generation)
def predict_next(token):
    options = next_token_probs.get(token, {})
    if not options:
        return None
    return max(options, key=options.get)

# Generate a sentence by repeatedly predicting the next token
current = "the"
sentence = [current]
for _ in range(6):
    next_word = predict_next(current)
    if next_word is None:
        break
    sentence.append(next_word)
    current = next_word

print(" ".join(sentence))
# Possible output: the cat sat on the cat sat
# A real LLM uses billions of weights and randomness so it does
# not loop like this — but the loop itself is exactly the same.',
 'python', 7, 20),

(@ai_id,
 'Why LLMs Hallucinate',
 'Hallucination is when an AI confidently makes things up — invents a citation, a function name, a person, a fact. It is not lying (lying needs intent). It is the model picking the most STATISTICALLY PLAUSIBLE next tokens, which sometimes are not the most TRUE next tokens.\r\n\r\nHere is the deeper reason: the model was trained to make text that sounds like the training data. It was never trained to be honest about uncertainty. So when you ask a question whose true answer it does not know, it does not refuse — it produces text that LOOKS like the right answer. A made-up citation is the model emitting tokens that look exactly like citations look, regardless of whether the actual cited paper exists.\r\n\r\nThis is why the most important AI literacy skill is VERIFY. Treat every fact, every function name, every citation an LLM gives you as a claim that has not yet been checked. The skill of programming alongside an AI in 2026 is asking the right questions AND knowing which answers to double-check.',
 '# A miniature "model" that hallucinates because it has no actual facts —
# only patterns. The model below "knows" what citations look like but
# has no real database of papers. Just like a real LLM.

import random

# Patterns the "model" has learned from training data
author_patterns  = ["Smith", "Patel", "Garcia", "Chen", "Almarouf"]
year_patterns    = [2018, 2019, 2020, 2021, 2022, 2023]
journal_patterns = ["Nature", "Science", "Cell", "PNAS", "JMLR"]

def generate_citation(topic):
    # Picks tokens that LOOK like a real citation — but they are random.
    author  = random.choice(author_patterns)
    year    = random.choice(year_patterns)
    journal = random.choice(journal_patterns)
    return f"{author} et al. ({year}). A study on {topic}. {journal}."

# Generate three "citations" — all syntactically perfect, all made up.
for topic in ["sleep", "diet", "memory"]:
    print(generate_citation(topic))

# Output looks legit:
#   Patel et al. (2020). A study on sleep. Nature.
#   Chen et al. (2019). A study on diet. JMLR.
#   ...but none of these papers exist.
#
# This is hallucination in 12 lines. Real LLMs do exactly this,
# just with way more sophisticated patterns. ALWAYS verify.',
 'python', 8, 20),

(@ai_id,
 'Embeddings — Words as Coordinates',
 'How does an LLM "know" that "king" and "queen" are related? It does not, in the way humans do. What it knows is that those words appear in similar contexts, so the model assigns them similar NUMBERS.\r\n\r\nEvery word (or token) is represented inside the model as a long list of numbers called an EMBEDDING — usually around 1,500 numbers long for big models. You can think of each word as a point in a 1,500-dimensional space. Words used in similar ways end up near each other in that space. "King" sits close to "queen", "prince", "throne". "Pizza" sits close to "burger", "pasta", "restaurant". The model literally measures distance between word-points to decide what is similar.\r\n\r\nThis is what powers semantic search ("find documents about X"), recommendation systems ("you might also like..."), and RAG (more on that next lesson). And once you understand embeddings, a huge chunk of modern AI suddenly makes sense.',
 '# A toy embedding space — only 2 dimensions so we can imagine it.
# Real embeddings have hundreds or thousands of dimensions.

embeddings = {
    "cat":     [0.8, 0.1],
    "kitten":  [0.7, 0.2],
    "dog":     [0.6, 0.3],
    "puppy":   [0.5, 0.4],
    "car":     [-0.6, 0.9],
    "truck":   [-0.7, 0.8],
    "pizza":   [0.1, -0.9],
    "burger":  [0.2, -0.8],
}

def distance(a, b):
    # Euclidean distance — straight line between two points
    return sum((x - y) ** 2 for x, y in zip(a, b)) ** 0.5

def closest_words(target, n=3):
    target_vec = embeddings[target]
    distances = []
    for word, vec in embeddings.items():
        if word == target:
            continue
        distances.append((word, distance(target_vec, vec)))
    distances.sort(key=lambda x: x[1])
    return distances[:n]

print("Most similar to ''cat'':")
for word, dist in closest_words("cat"):
    print(f"  {word:<8} (distance {dist:.2f})")

print("\\nMost similar to ''pizza'':")
for word, dist in closest_words("pizza"):
    print(f"  {word:<8} (distance {dist:.2f})")

# Output: cat is closest to kitten and dog (animals).
# Pizza is closest to burger (food).
# That is embeddings — meaning encoded as position in space.',
 'python', 9, 20),

(@ai_id,
 'Calling a Real LLM (Pseudocode)',
 'You do not need to train an LLM to USE one. Anthropic, OpenAI, Google, Mistral and many others let you call their hosted models over the internet — you send some text in a HTTP request, and the LLM sends back its prediction. From a programming perspective, it is just another API call.\r\n\r\nThe pattern is the same everywhere: you prepare a list of MESSAGES (a conversation history), choose a MODEL (like "claude-sonnet-4-6"), set parameters like temperature (0 = deterministic, 1 = creative), and send it. You get back the assistant''s reply plus how many tokens you spent. That is the whole interface.\r\n\r\nThe code below is pseudocode you cannot actually run here — Coder''s in-browser compiler has no internet access for security. But this is exactly what you will write when you build your first AI app. Read it now, run it later in your own environment when you are ready.',
 '# How to call a real LLM (pseudocode — this will not run in the sandbox,
# but it is exactly the shape of code you will write at home).

# Step 1: install the SDK once outside this lesson
#   pip install anthropic

# Step 2: in your real program:
#
#   from anthropic import Anthropic
#   client = Anthropic(api_key="sk-ant-...")          # your secret key
#
#   response = client.messages.create(
#       model="claude-sonnet-4-6",                    # pick a model
#       max_tokens=200,                               # cap the answer length
#       messages=[
#           {"role": "user", "content": "Explain recursion in one sentence."}
#       ],
#   )
#   print(response.content[0].text)

# For now, simulate the same shape — your "AI" just echoes the prompt
# with a fake answer. The point is to see the request/response pattern.

def fake_llm(messages, model="fake-1.0", max_tokens=100):
    user_message = messages[-1]["content"]
    return {
        "model":   model,
        "content": [{"text": f"Pretending to answer: ''{user_message}''"}],
        "usage":   {"input_tokens": len(user_message.split()),
                    "output_tokens": 8}
    }

response = fake_llm(
    messages=[{"role": "user", "content": "Explain recursion in one sentence."}]
)

print(response["content"][0]["text"])
print(f"\\nUsed {response[''usage''][''input_tokens'']} input + " +
      f"{response[''usage''][''output_tokens'']} output tokens.")

# When you do this for real, you pay roughly per million tokens.
# Most short conversations cost less than 1 cent.',
 'python', 10, 20),

(@ai_id,
 'Build a Tiny Chatbot',
 'A chatbot is just a loop: get input from the user, send the conversation history to the LLM, append the reply, repeat. The "intelligence" lives inside the LLM call. Your job as the programmer is everything around it — handling input, formatting the conversation, deciding when to stop.\r\n\r\nThe critical idea is CONVERSATION HISTORY. The LLM has no memory. Every time you call it, you must send the entire conversation so far so it can predict what to say next. This is also why long conversations get expensive — every turn includes all the previous turns.\r\n\r\nIn this lesson we will fake the LLM (no internet in the sandbox) but the LOOP and the HISTORY pattern are exactly what your real chatbot will use. Once this clicks, replacing the fake LLM with a real one is two lines of code.',
 '# A working tiny chatbot — with a fake LLM, but the real shape.

def fake_llm(messages):
    # Look at the last user message and respond predictably.
    last_user = next((m["content"] for m in reversed(messages)
                      if m["role"] == "user"), "")
    if "hello" in last_user.lower():
        return "Hi there! What would you like to talk about?"
    if "?" in last_user:
        return "That is a great question. Let me think..."
    return "Interesting. Tell me more about that."

# THE CONVERSATION HISTORY — sent in full on every turn
conversation = [
    {"role": "system", "content": "You are a friendly coding tutor."}
]

# Simulate 3 turns of a conversation (in a real app these would come from input())
fake_user_messages = [
    "Hello!",
    "What is a variable?",
    "I want to learn Python",
]

for user_msg in fake_user_messages:
    # Append the user message to the history
    conversation.append({"role": "user", "content": user_msg})

    # Send the WHOLE conversation, get a reply
    reply = fake_llm(conversation)

    # Append the AI''s reply so the next turn includes it
    conversation.append({"role": "assistant", "content": reply})

    print(f"You: {user_msg}")
    print(f"AI : {reply}\\n")

# When you replace fake_llm with a real API call, you have a chatbot.
# When you store conversation in a database, you have a chat APP.
# When you do that for thousands of users, you have a product.',
 'python', 11, 25),

(@ai_id,
 'Where AI Falls Down (And What That Means For You)',
 'Now that the magic is gone, here is the honest list of what AI in 2026 cannot do — and what that means for you as a programmer.\r\n\r\nAI cannot KNOW things it was not trained on, including current events past its cutoff, your specific codebase, or facts that did not appear in its training data. AI cannot REASON in the way humans can — it is a probability engine, so multi-step logical problems where each step depends on the last often fall apart. AI cannot VERIFY its own answers — it has no built-in fact-checker. AI cannot REMEMBER between conversations unless you re-feed the history. AI cannot HAVE GOALS — it has no preferences, no intent, no agenda; it predicts the next token.\r\n\r\nWhat this means for the programmer of 2026: AI is a phenomenal junior partner that types faster than you, knows a thousand languages at a shallow level, and is wrong often enough that you must verify. The most valuable skills are now: reading code (you read more AI code than you write), debugging (errors are still your job), system design (AI cannot decide what to build), and judgment (deciding what to trust). The next course in this track teaches exactly those skills.',
 '# A self-test — ask the "AI" three questions where it is likely to fail,
# then notice the failure modes yourself.

import random

class TinyAI:
    """Demonstrates real LLM failure modes in miniature."""

    def __init__(self):
        self.training_year = 2024     # knowledge cutoff
        self.facts = {
            "capital of france": "Paris",
            "speed of light":    "approximately 299,792 km/s",
        }

    def ask(self, question):
        q = question.lower().strip("?")
        # If we have the fact, return it (the model "knew" this)
        for key, val in self.facts.items():
            if key in q:
                return f"{val}"
        # Otherwise — HALLUCINATE a plausible-looking answer
        return f"The answer is {random.choice([''42'', ''roughly 17'', ''always blue'', ''it depends''])}."

ai = TinyAI()

# Question it knew → correct
print("Q: What is the capital of France?")
print("A:", ai.ask("What is the capital of France?"))

# Question past its cutoff → hallucinated nonsense
print("\\nQ: Who won the 2025 World Cup?")
print("A:", ai.ask("Who won the 2025 World Cup?"))

# Question about your own life → hallucinated nonsense
print("\\nQ: What did Ahmed code today?")
print("A:", ai.ask("What did Ahmed code today?"))

# The lesson: when you do not know what the AI knows,
# you must verify every important answer. Always.
#
# Congrats — you finished the AI Foundations course.
# Next up: "AI Pair-Programming Etiquette" — how to work
# WITH an AI without letting it make you worse.',
 'python', 12, 30);

-- Verify
SELECT id, title, language, level, lessons FROM courses WHERE title = 'AI, ML & LLMs from Scratch';
SELECT id, order_num, title, xp_reward FROM lessons WHERE course_id = @ai_id ORDER BY order_num;
