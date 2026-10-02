-- ================================================================
-- SQL DDL TEMPLATE (TOPIC 04)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) Full PostgreSQL DDL for your finalized schema.
-- 2) CREATE TABLE statements for all entities from your ER diagram.
-- 3) Primary keys, foreign keys, NOT NULL, UNIQUE, CHECK constraints.
-- 4) Indexes for important search/join columns.
-- 5) Clean structure and comments (group by tables/constraints/indexes).
--
-- RECOMMENDED ORDER:
-- 1) Tables
-- 2) Constraints (if not inline)
-- 3) Indexes
--
-- TEAM NOTE:
-- Add short attribution comments for who implemented which part.
-- Example:
-- [Name] - users, roles, permissions tables
-- [Name] - orders, payments, invoices tables
--
-- IMPORTANT:
-- The script must run in PostgreSQL and produce a working schema that
-- matches your approved ER diagram and conceptual schema.
-- Submit this as one SQL file.
-- ================================================================

-- Add your DDL below this line

--Tables creation - MVP tables + Borrowings table
create table members (
    member_id int generated always as identity primary key,
    member_name varchar(255) not null,
    member_phone_number varchar(50) unique,
    member_email varchar(255) not null unique
);

create unique index ix_members_email
    on members using btree (member_email);


create table books (
    book_id int generated always as identity primary key,
    book_title varchar(255) not null,
    book_isbn varchar(13) not null unique,
    publication_year int
);

create unique index ix_books_isbn
    on books using btree (book_isbn);

create index ix_books_title
    on books using btree (book_title);


create table book_copies (
    copy_id int generated always as identity primary key,
    book_id int not null,
    copy_number int not null,
    is_available boolean not null default true,

    constraint fk_book_copies_books
        foreign key (book_id)
        references books (book_id)
);

create index ix_book_copies_book_id
    on book_copies using btree (book_id);

create index ix_book_copies_is_available
    on book_copies using btree (is_available);


create table borrowings (
    borrowing_id int generated always as identity primary key,
    member_id int not null,
    copy_id int not null,
    borrowing_date date not null,
    due_date date not null,
    return_date date,

    constraint fk_borrowings_members
        foreign key (member_id)
        references members (member_id),

    constraint fk_borrowings_book_copies
        foreign key (copy_id)
        references book_copies (copy_id)
);

create index ix_borrowings_member_id
    on borrowings using btree (member_id);

create index ix_borrowings_copy_id
    on borrowings using btree (copy_id);

create index ix_borrowings_due_date
    on borrowings using btree (due_date);

-- Data Insertion

insert into members (member_name, member_phone_number, member_email)
values
    ('John Smith', '+380501111111', 'john.smith@example.com'),
    ('Emma Johnson', '+380502222222', 'emma.johnson@example.com'),
    ('Michael Brown', '+380503333333', 'michael.brown@example.com'),
    ('Olivia Davis', '+380504444444', 'olivia.davis@example.com'),
    ('Daniel Wilson', '+380505555555', 'daniel.wilson@example.com'),
    ('Sophia Taylor', '+380506666666', 'sophia.taylor@example.com'),
    ('James Anderson', '+380507777777', 'james.anderson@example.com'),
    ('Emily Thomas', '+380508888888', 'emily.thomas@example.com'),
    ('William Jackson', '+380509999999', 'william.jackson@example.com'),
    ('Charlotte White', '+380501010101', 'charlotte.white@example.com');

insert into books (book_title, book_isbn, publication_year)
values
    ('1984', '9780451524935', 1949),
    ('The Hobbit', '9780547928227', 1937),
    ('Dune', '9780441172719', 1965),
    ('The Great Gatsby', '9780743273565', 1925),
    ('To Kill a Mockingbird', '9780061120084', 1960),
    ('The Catcher in the Rye', '9780316769488', 1951),
    ('Fahrenheit 451', '9781451673319', 1953),
    ('Brave New World', '9780060850524', 1932),
    ('The Lord of the Rings', '9780544003415', 1954),
    ('Crime and Punishment', '9780140449136', 1866);

insert into book_copies (book_id, copy_number, is_available)
values
    (1, 1, false),
    (1, 2, true),
    (2, 1, false),
    (2, 2, true),
    (3, 1, false),
    (3, 2, true),
    (3, 3, true),
    (4, 1, true),
    (5, 1, false),
    (6, 1, true),
    (7, 1, false),
    (8, 1, true),
    (9, 1, false),
    (9, 2, true),
    (10, 1, true);

insert into borrowings (member_id, copy_id, borrowing_date, due_date, return_date)
values
    (1, 1,  '2026-08-01', '2026-08-15', '2026-08-12'),
    (2, 3,  '2026-08-03', '2026-08-17', '2026-08-16'),
    (3, 5,  '2026-08-10', '2026-08-24', '2026-08-22'),
    (4, 9,  '2026-08-15', '2026-08-29', '2026-09-02'),
    (5, 11, '2026-09-01', '2026-09-15', '2026-09-14'),
    (6, 13, '2026-09-05', '2026-09-19', '2026-09-18'),
    (1, 5,  '2026-09-10', '2026-09-24', '2026-09-22'),
    (7, 1,  '2026-09-15', '2026-09-29', null),
    (8, 3,  '2026-09-18', '2026-10-02', null),
    (9, 9,  '2026-09-20', '2026-10-04', null);
