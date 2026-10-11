-- ================================================================
-- SQL VIEWS TEMPLATE (TOPIC 10)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) CREATE VIEW scripts for required view types:
--    - Horizontal view (select specific columns)
--    - Vertical view (filter specific rows)
--    - Mixed view (columns + row filters)
--    - Join-based view (multiple tables)
--    - Subquery-based view
--    - UNION-based view
--    - View based on another view
--    - Updatable view with WITH CHECK OPTION
--
-- 2) Comments before each view explaining:
--    - Purpose of the view
--    - How it supports your project design
--
-- 3) Optional demo SELECT statements to show view output.
--
-- RECOMMENDED ORDER:
-- 1) Simple views (horizontal / vertical / mixed)
-- 2) Join and subquery views
-- 3) UNION and layered views
-- 4) CHECK OPTION view
--
-- IMPORTANT:
-- - Script must execute in PostgreSQL without errors.
-- - Keep naming consistent and readable.
-- - Submit all views in this single SQL file.
-- ================================================================

-- Add your CREATE VIEW statements below this line

--01. HORIZONTAL VIEW

create view vw_book_catalog_basic as
select book_title, book_isbn, publication_year from books;

comment on view vw_book_catalog_basic is
'Horizontal view for the assignment: exposes selected book columns only.';

-- 02. VERTICAL VIEW

create view vw_overdue_borrowings as
select borrowing_id, member_id, copy_id, borrowing_date, due_date, return_date from borrowings
where return_date is null and due_date < current_date;

comment on view vw_overdue_borrowings is
'Vertical view for the assignment: contains only overdue borrowing rows.';

-- 03. MIXED VIEW

create view vw_high_rated_reviews as
select review_id, book_id, member_id, rating from reviews
where rating >= 4;

comment on view vw_high_rated_reviews is
'Mixed view: selects specific review columns and keeps only ratings of 4 or 5.';

-- 04. JOIN-BASED VIEW

create view vw_borrowing_details as
select br.borrowing_id, m.member_id, m.member_name, m.member_email, b.book_id, b.book_title, bc.copy_id, bc.copy_number, bc.copy_status, br.borrowing_date,
br.due_date, br.return_date from borrowings br
join members m on m.member_id = br.member_id
join book_copies bc on bc.copy_id = br.copy_id
join books b on b.book_id = bc.book_id;

comment on view vw_borrowing_details is
'Join-based view combining borrowings, members, book copies, and books into one readable report.';

-- 05. SUBQUERY-BASED VIEW

create view vw_books_review_summary as
select b.book_id, b.book_title, b.book_isbn,
    (
        select count(*) from reviews r
        where r.book_id = b.book_id
    ) as review_count,
    (
        select round(avg(r.rating), 2) from reviews r
        where r.book_id = b.book_id
    ) as average_rating from books b;

comment on view vw_books_review_summary is
'Subquery-based view that uses correlated subqueries to calculate review count and average rating for each book.';

-- 06. UNION-BASED VIEW

create view vw_member_activity as
select br.member_id, bc.book_id, br.borrowing_date as activity_date, 'borrowing'::varchar as activity_type from borrowings br
join book_copies bc on bc.copy_id = br.copy_id

union

select r.member_id, r.book_id, r.reservation_date as activity_date, 'reservation'::varchar as activity_type from reservations r;

comment on view vw_member_activity is
'UNION-based view combining borrowing and reservation activity into one compatible result set.';

-- 07. LAYERED VIEW

create view vw_overdue_borrowing_details as
select borrowing_id, member_id, member_name, member_email, book_id, book_title, copy_id, copy_number, copy_status, borrowing_date, due_date
from vw_borrowing_details
where return_date is null and due_date < current_date;

comment on view vw_overdue_borrowing_details is
'Layered view that selects overdue records from the existing vw_borrowing_details view.';

-- 08. UPDATABLE VIEW WITH CHECK OPTION

create view vw_available_book_copies as
select copy_id, book_id, copy_number, copy_status from book_copies
where copy_status = 'available'
with local check option;

comment on view vw_available_book_copies is
'Updatable view of available book copies. WITH CHECK OPTION ensures rows modified through the view remain available.';

-- 9. OPTIONAL OUTPUT DEMO

select * from vw_book_catalog_basic
order by book_title;

select * from vw_overdue_borrowings
order by due_date;

select * from vw_high_rated_reviews
order by rating desc, review_id;

select * from vw_borrowing_details
order by borrowing_date, borrowing_id;

select * from vw_books_review_summary
order by book_title;

select * from vw_member_activity
order by activity_date, member_id;

select * from vw_overdue_borrowing_details
order by due_date, member_name;

select * from vw_available_book_copies
order by book_id, copy_number;



