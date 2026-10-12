-- ================================================================
-- DATABASE ADMINISTRATION TEMPLATE (TOPIC 11)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) CREATE ROLE statements for at least 2 distinct roles.
--    Example roles: read-only analyst, read-write editor.
--
-- 2) GRANT statements assigning appropriate permissions to each role:
--    - Read-only role: GRANT SELECT ON ALL TABLES IN SCHEMA ...
--    - Read-write role: GRANT SELECT, INSERT, UPDATE, DELETE ...
--
-- 3) CREATE USER statements for at least 2 users.
--    Each user must be assigned to one of the defined roles.
--
-- 4) Comments before each section explaining the rationale:
--    - Why this role exists
--    - What access it should and should not have
--
-- RECOMMENDED ORDER:
-- 1) Roles + their GRANTs
-- 2) Users + GRANT ROLE TO USER
-- 3) Optional: REVOKE statements for fine-grained restrictions
-- 4) Optional cleanup block (commented out by default):
--    -- DROP USER ...; DROP ROLE ...;
--
-- IMPORTANT:
-- - Use explicit GRANT / REVOKE statements — do not rely on defaults.
-- - Roles must have meaningfully different permission levels.
-- - Script must execute in PostgreSQL without errors.
-- ================================================================

-- Add your script below this line

- ==========================================
-- 1. СТВОРЕННЯ РОЛЕЙ
-- ==========================================

-- Створюємо роль «Тільки читання»
CREATE ROLE readonly_role;

-- Створюємо роль «Читання та запис»
CREATE ROLE readwrite_role;

==========================================
-- 2. СТВОРЕННЯ КОРИСТУВАЧІВ
-- ==========================================

-- Користувачі для читання
CREATE USER inna_petryshyn WITH PASSWORD 'SecurePass123!';
CREATE USER sofiia_voitkiv WITH PASSWORD 'SecurePass456!';

-- Користувачі для читання та запису
CREATE USER hanna_datsenko WITH PASSWORD 'StrongPass789!';
CREATE USER rostyslav_chukhnii WITH PASSWORD 'StrongPass012!';

 ==========================================
-- 3. ПРИЗНАЧЕННЯ РОЛЕЙ КОРИСТУВАЧАМ
-- ==========================================

-- Додаємо користувачів до ролі readonly
GRANT readonly_role TO inna_petryshyn;
GRANT readonly_role TO sofiia_voitkiv;

-- Додаємо користувачів до ролі readwrite
GRANT readwrite_role TO hanna_datsenko;
GRANT readwrite_role TO rostyslav_chukhnii;

==========================================
-- 4: ПРИЗНАЧЕННЯ ПРАВ
-- ==========================================

-- Базове підключення до БД та схеми для всіх користувачів
GRANT CONNECT ON DATABASE Library_Management_System TO inna_petryshyn, sofiia_voitkiv;
GRANT CONNECT ON DATABASE Library_Management_System TO hanna_datsenko, rostyslav_chukhnii;

GRANT USAGE ON SCHEMA public TO  inna_petryshyn, sofiia_voitkiv;
GRANT USAGE ON SCHEMA public TO hanna_datsenko, rostyslav_chukhnii;

-- ------------------------------------------
-- ГРУПА 1: Виконавець 1 (Працює з 3 таблицями)
-- Таблиці: books, book_copies, reviews
-- ------------------------------------------

-- Права для Writer 1 (Читання та коригування 3 таблиць)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE books, book_copies, reviews TO rostyslav_chukhnii;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rostyslav_chukhnii; -- для автоінкременту ID

-- Права для Reader 1 (Тільки перегляд цих 3 таблиць)
GRANT SELECT ON TABLE books, book_copies, reviews TO inna_petryshyn;


-- ------------------------------------------
-- ГРУПА 2: Виконавець 2 (Працює з 3 таблицями)
-- Таблиці: borrowings, reservations, members
-- ------------------------------------------

-- Права для Writer 2 (Читання та коригування)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE borrowings, reservations, members TO hanna_datsenko;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hanna_datsenko;

-- Права для Reader 2 (Тільки перегляд)
GRANT SELECT ON TABLE borrowings, reservations, members TO sofiia_voitkiv;

 ------------------------------------------
-- ГРУПА 3: Виконавець 3 (Працює з 4 таблицями)
-- Таблиці: authors, book_authors, books_categories, categories
-- ------------------------------------------

-- Права для Writer 3 (Читання та коригування)
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE authors, book_authors, books_categories, categories TO hanna_datsenko;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hanna_datsenko;

-- Права для Reader 3 (Тільки перегляд)
GRANT SELECT ON TABLE authors, book_authors, books_categories, categories TO sofiia_voitkiv;

