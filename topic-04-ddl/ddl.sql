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

create table reviews (
    review_id int generated always as identity primary key,
    book_id int not null,
    member_id int not null,
    review_text varchar(2000),
    rating int not null,

    constraint uq_reviews_member_book
        unique (member_id, book_id),

    constraint fk_reviews_books
        foreign key (book_id)
        references books (book_id),

    constraint fk_reviews_members
        foreign key (member_id)
        references members (member_id),

    constraint chk_reviews_rating
        check (rating between 1 and 5)
);

create index ix_reviews_book_id
    on reviews using btree (book_id);

create index ix_reviews_member_id
    on reviews using btree (member_id);

create table reservations (
    reservation_id int generated always as identity primary key,
    book_id int not null,
    member_id int not null,
    reservation_date date not null,
    reservation_status varchar(50) not null,

    constraint fk_reservations_books
        foreign key (book_id)
        references books (book_id),

    constraint fk_reservations_members
        foreign key (member_id)
        references members (member_id)
);

create index ix_reservations_book_id
    on reservations using btree (book_id);

create index ix_reservations_member_id
    on reservations using btree (member_id);

create table authors (
    author_id int generated always as identity primary key,
    author_name varchar(255) not null,
    bio varchar(2000)
);

create index ix_authors_name
    on authors using btree (author_name);

create table book_authors (
    book_id int not null,
    author_id int not null,

    constraint pk_book_authors
        primary key (book_id, author_id),

    constraint fk_book_authors_books
        foreign key (book_id)
        references books (book_id),

    constraint fk_book_authors_authors
        foreign key (author_id)
        references authors (author_id)
);

create index ix_book_authors_book_id
    on book_authors using btree (book_id);

create index ix_book_authors_author_id
    on book_authors using btree (author_id);

create table categories (
    category_id int generated always as identity primary key,
    category_name varchar(100) not null unique
);

create unique index ix_categories_name
    on categories using btree (category_name);

create table books_categories (
    book_id int not null,
    category_id int not null,

    constraint pk_books_categories
        primary key (book_id, category_id),

    constraint fk_books_categories_books
        foreign key (book_id)
        references books (book_id),

    constraint fk_books_categories_categories
        foreign key (category_id)
        references categories (category_id)
);

create index ix_books_categories_book_id
    on books_categories using btree (book_id);

create index ix_books_categories_category_id
    on books_categories using btree (category_id);
