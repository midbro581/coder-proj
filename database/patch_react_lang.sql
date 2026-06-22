-- ============================================================
-- CODER — patch_react_lang.sql
-- Fixes React lessons saved with language='javascript' to 'react'
-- Safe to run even if lessons haven't been imported yet (no rows updated = no harm)
-- Import via phpMyAdmin: coder_db → Import → choose this file → Go
-- ============================================================

USE coder_db;

-- Update all lessons inside the React course to use language='react'
-- so the lesson page shows the React icon and correct file extension (App.jsx)
-- and the "Try in Compiler" button shows "Copy (Needs Browser)" instead of trying to run JSX in Node
UPDATE lessons
SET language = 'react'
WHERE course_id = (
    SELECT id FROM courses WHERE language = 'react' LIMIT 1
);

-- Verify: should show 5 or 10 rows with language='react'
SELECT id, title, language, order_num
FROM lessons
WHERE course_id = (SELECT id FROM courses WHERE language = 'react' LIMIT 1)
ORDER BY order_num;
