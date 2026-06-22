-- =============================================================
-- CODER — patch_company_v2.sql
-- Replaces founders, team leadership, and timeline with the
-- real founding story: 3 UOWD students, first company, 2026.
-- Import via phpMyAdmin: coder_db → Import → choose this file → Go
-- Safe to re-run — uses DELETE + INSERT (idempotent).
-- =============================================================

USE coder_db;

-- ── 1. Replace founders ──────────────────────────────────────
DELETE FROM founders;
ALTER TABLE founders AUTO_INCREMENT = 1;

INSERT INTO founders (name, title, bio, image, linkedin, founded_year) VALUES
('Ahmed Almarouf',
 'Co-Founder & CEO',
 'Computer Science student at the University of Wollongong in Dubai. Built Coder because he believes most beginners memorise code instead of truly understanding it. Drives the platform''s vision: teach people how code actually runs, not just how to type it.',
 'images/founder1.png', '#', 2026),

('Ted Lokolo',
 'Co-Founder & CTO',
 'Computer Science student at the University of Wollongong in Dubai. Leads the engineering behind Coder''s in-browser compiler, lessons engine, and progress system. Believes hands-on practice — not lectures — is what makes a programmer.',
 'images/founder2.png', '#', 2026),

('Midhlaj Abubacker',
 'Co-Founder & Head of Curriculum',
 'Computer Science student at the University of Wollongong in Dubai. Designs Coder''s lesson paths from absolute zero to fluent developer. Obsessed with explaining WHY code works the way it does — from CPU instructions all the way up to modern frameworks.',
 'images/founder3.png', '#', 2026);

-- ── 2. Replace company history with the real story ──────────
DELETE FROM company_history;
ALTER TABLE company_history AUTO_INCREMENT = 1;

INSERT INTO company_history (year_val, milestone, description) VALUES
(2026, 'Coder Founded at UOWD',
 'Ahmed Almarouf, Ted Lokolo, and Midhlaj Abubacker — three Computer Science students at the University of Wollongong in Dubai — launched Coder as their first company. The mission: help beginners truly understand coding from scratch, not just memorise syntax.'),
(2026, 'First Foundations Course Released',
 'Published the "Programming Foundations" course — a from-zero path that explains how computers actually run code, what memory is, and how programs go from text to running instructions.'),
(2026, 'Live In-Browser Compiler',
 'Launched the integrated compiler supporting Python, JavaScript, TypeScript, Java, C, and C++ — so learners can experiment with every lesson without installing anything.'),
(2026, 'Multi-Language Curriculum',
 'Expanded to 9 tracks (Python, JavaScript, Java, C++, HTML & CSS, SQL, TypeScript, React, Git & GitHub) with 250+ hands-on lessons.');

-- ── 3. Update team / leadership to feature the 3 founders ───
-- Keeps the existing instructor list but puts the founders at the top of the team page.
DELETE FROM team;
ALTER TABLE team AUTO_INCREMENT = 1;

INSERT INTO team (name, role, bio, image, linkedin, github) VALUES
('Ahmed Almarouf',
 'Co-Founder & CEO — UOWD',
 'Co-founder of Coder. Computer Science student at the University of Wollongong in Dubai. Leads vision and product.',
 'images/team1.png', '#', '#'),
('Ted Lokolo',
 'Co-Founder & CTO — UOWD',
 'Co-founder of Coder. Computer Science student at the University of Wollongong in Dubai. Leads engineering and platform infrastructure.',
 'images/team2.png', '#', '#'),
('Midhlaj Abubacker',
 'Co-Founder & Head of Curriculum — UOWD',
 'Co-founder of Coder. Computer Science student at the University of Wollongong in Dubai. Designs and writes the lessons.',
 'images/team3.png', '#', '#');

-- ── 4. Verify ───────────────────────────────────────────────
SELECT id, name, title, founded_year FROM founders;
SELECT id, year_val, milestone FROM company_history ORDER BY year_val, id;
SELECT id, name, role FROM team;
