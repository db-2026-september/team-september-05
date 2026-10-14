-- ================================================================
-- FUNCTIONS & STORED PROCEDURES TEMPLATE (TOPIC 12)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
--
-- FUNCTIONS (at least 3):
--   - Each function should encapsulate reusable logic or a
--     calculation relevant to your project domain.
--   - Use CREATE OR REPLACE FUNCTION ... RETURNS ...
--
-- STORED PROCEDURES — SELECT / INSERT (at least 2):
--   - Procedures that retrieve data or insert new records.
--   - Use CREATE OR REPLACE PROCEDURE ...
--
-- STORED PROCEDURES — UPDATE (at least 2):
--   - Procedures that modify existing records.
--
-- FOR EACH FUNCTION / PROCEDURE, ADD COMMENTS EXPLAINING:
--   - Purpose: what it does
--   - Parameters: name, type, meaning
--   - Expected behavior / return value
--
-- TEST CALLS:
--   - Include at least one example call per function/procedure
--     (SELECT my_function(...) or CALL my_procedure(...))
--
-- OPTIONAL:
--   - EXCEPTION blocks for error handling
--   - Transaction management with BEGIN / COMMIT / ROLLBACK
--
-- RECOMMENDED ORDER:
-- 1) Functions
-- 2) SELECT / INSERT procedures
-- 3) UPDATE procedures
-- 4) Test calls
--
-- IMPORTANT:
-- - All routines must execute in PostgreSQL without errors.
-- - Logic must be relevant to your project domain.
-- - Submit everything in this single SQL file.
-- ================================================================

-- Add your functions and procedures below this line

-- 01. FUNCTION: fn_book_average_rating
-- Returns the average rating for a specified book.

create or replace function fn_book_average_rating(p_book_id int)
returns numeric
language sql
stable
as $$
    select round(avg(r.rating)::numeric, 2) from reviews r
    where r.book_id = p_book_id;
$$;

-- 02. FUNCTION: fn_available_copies
-- Returns the number of physical copies of a book that are
-- currently available for borrowing.

create or replace function fn_available_copies(p_book_id int)
returns int
language sql
stable
as $$
    select count(*)::int from book_copies bc
    where bc.book_id = p_book_id and bc.copy_status = 'available';
$$;

-- 03. FUNCTION: fn_member_overdue_borrowings
-- Returns the number of currently overdue borrowings for a member.

create or replace function fn_member_overdue_borrowings(p_member_id int)
returns int
language sql
stable
as $$
    select count(*)::int from borrowings br
    where br.member_id = p_member_id and br.return_date is null and br.due_date < current_date;
$$;

-- 04. INSERT PROCEDURE: sp_add_member
-- Creates a new library member.

create or replace procedure sp_add_member(p_member_name varchar, p_phone bigint, p_email varchar)
language plpgsql
as $$
begin
    if p_member_name is null or btrim(p_member_name) = '' then
        raise exception 'member name cannot be empty';
    end if;

    if p_email is null or btrim(p_email) = '' then
        raise exception 'member email cannot be empty';
    end if;

    insert into members (member_name, member_phone_number, member_email)
    values (p_member_name, p_phone, p_email);
end;
$$;

-- 05. INSERT PROCEDURE: sp_create_reservation
-- Creates a new pending reservation for a member and a book.

create or replace procedure sp_create_reservation(p_member_id int, p_book_id int, p_reservation_date date default current_date)
language plpgsql
as $$
begin
    if not exists (
        select 1 from members
        where member_id = p_member_id
    ) then
        raise exception 'member with id % does not exist', p_member_id;
    end if;

    if not exists (
        select 1 from books
        where book_id = p_book_id
    ) then
        raise exception 'book with id % does not exist', p_book_id;
    end if;

    insert into reservations (book_id, member_id, reservation_date, reservation_status)
    values (p_book_id, p_member_id, p_reservation_date, 'pending');
end;
$$;

-- 06. UPDATE PROCEDURE: sp_return_book
-- Registers the return of an actively borrowed physical copy.

create or replace procedure sp_return_book(p_borrowing_id int, p_return_date date default current_date)
language plpgsql
as $$
declare
    v_copy_id int;
    v_borrowing_date date;
begin
    select br.copy_id, br.borrowing_date
    into v_copy_id, v_borrowing_date from borrowings br
    where br.borrowing_id = p_borrowing_id and br.return_date is null;

    if not found then
        raise exception
            'active borrowing with id % does not exist or has already been returned',
            p_borrowing_id;
    end if;

    if p_return_date < v_borrowing_date then
        raise exception
            'return date % cannot be earlier than borrowing date %',
            p_return_date,
            v_borrowing_date;
    end if;

    update borrowings
    set return_date = p_return_date
    where borrowing_id = p_borrowing_id;

    update book_copies
    set copy_status = 'available'
    where copy_id = v_copy_id;
end;
$$;

-- 07. UPDATE PROCEDURE: sp_update_member_contact
-- Updates the phone number and/or email address of a member.

create or replace procedure sp_update_member_contact(p_member_id int, p_phone bigint default null, p_email varchar default null)
language plpgsql
as $$
begin
    if p_phone is null and p_email is null then
        raise exception 'at least one new contact value must be supplied';
    end if;

    update members
    set
        member_phone_number = coalesce(p_phone, member_phone_number),
        member_email = coalesce(p_email, member_email)
    where member_id = p_member_id;

    if not found then
        raise exception 'member with id % does not exist', p_member_id;
    end if;
end;
$$;

-- 08. FUNCTION TESTS

-- Test fn_book_average_rating:

select b.book_id, b.book_title, fn_book_average_rating(b.book_id) as average_rating from books b
order by b.book_id
limit 10;


-- Test fn_available_copies:

select b.book_id, b.book_title, fn_available_copies(b.book_id) as available_copies from books b
order by b.book_id
limit 10;


-- Test fn_member_overdue_borrowings:

select m.member_id, m.member_name, fn_member_overdue_borrowings(m.member_id) as overdue_borrowings from members m
order by m.member_id
limit 10;

-- 09. PROCEDURE TESTS

begin;

-- Test sp_add_member

call sp_add_member('Procedure Test Member', 380509999991, 'procedure.test.member@example.com');

select member_id, member_name, member_phone_number, member_email from members
where member_email = 'procedure.test.member@example.com';

-- Test sp_update_member_contact

call sp_update_member_contact(
    (
        select member_id from members
        where member_email = 'procedure.test.member@example.com'
    ),
    380509999992,
    'procedure.test.updated@example.com'
);

select member_id, member_name, member_phone_number, member_email from members
where member_email = 'procedure.test.updated@example.com';

-- Prepare a temporary book for reservation/return procedure tests.

insert into books (book_title, book_isbn, publication_year)
values ('Procedure Test Book', '9999999999999', 2026);

-- Test sp_create_reservation

call sp_create_reservation(
    (
        select member_id from members
        where member_email = 'procedure.test.updated@example.com'
    ),
    (
        select book_id from books
        where book_isbn = '9999999999999'
    ),
    current_date
);

select r.reservation_id, r.member_id, r.book_id, r.reservation_date, r.reservation_status from reservations r
where r.member_id = (select member_id from members
    where member_email = 'procedure.test.updated@example.com')
and r.book_id = (select book_id from books
    where book_isbn = '9999999999999');

-- Test sp_return_book

call sp_return_book(
    (
        select br.borrowing_id from borrowings br
        join book_copies bc on bc.copy_id = br.copy_id
        join books b on b.book_id = bc.book_id
        where b.book_isbn = '9999999999999' and bc.copy_number = 1 and br.return_date is null
    ),
    current_date
);

select br.borrowing_id, br.borrowing_date, br.due_date, br.return_date, bc.copy_status from borrowings br
join book_copies bc on bc.copy_id = br.copy_id
join books b on b.book_id = bc.book_id
where b.book_isbn = '9999999999999' and bc.copy_number = 1;

rollback;

-- 10. OPTIONAL ERROR-HANDLING TESTS

-- Empty member name:
call sp_add_member( '', 380509999993, 'invalid.name@example.com');

-- Non-existing member reservation:
call sp_create_reservation( 999999, (select min(book_id) from books), current_date);

-- Updating a non-existing member:
call sp_update_member_contact( 999999, 380509999994, null);






