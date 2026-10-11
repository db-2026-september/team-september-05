INSERT INTO members (member_name, member_phone_number, member_email) VALUES
('Sofiia Voitkiv', '380987896789', 's.voitkiv@gmail.com'),
('Hanna Datsenko', '380992717166', 'h.datsenkogemail.com'),
('Inna Petryshyn', '380956785534', 'petryshyn@gmail.com'),
('Rostyslav Chukhnii', '380965432345', 'skorpion.rost@gmail.com'),
('Olha Shutylieva', '380507890978', 'olha.shutylieva@gmail.com'),
('Ihor Kapatsila', '380938961256', 'ih.kara@gmail.com'),
('Andrii Martynchuk', '30637650912', 'and.mart@gmail.com'),
('Donald Trump', '380975620012', 'donna.tr@gmail.com'),
('Volodymyr Klichko', '380992785634', 'vova.box@gmail.com'),
('Andrii Shevchenko', '380674560912', 'and.sheva@gmail.com');

INSERT INTO categories (category_name) VALUES
('Fiction'),
('Science Fiction'),
('Fantasy'),
('History'),
('Computer Science'),
('Psychology'),
('Philosophy'),
('Business & Economics'),
('Biography & Memoir'),
('Science & Technology');

INSERT INTO authors (author_name, bio) VALUES
('Taras Shevchenko', 'Ukrainian poet, writer, artist, and public figure, founder of modern Ukrainian literature.'),
('Lesya Ukrainka', 'Prominent Ukrainian writer, poet, and dramatist, best known for Forest Song.'),
('Ivan Franko', 'Ukrainian poet, writer, social and literary critic, journalist, and political activist.'),
('Serhiy Zhadan', 'Contemporary Ukrainian poet, novelist, essayist, and musician from Kharkiv.'),
('Oksana Zabuzhko', 'Leading Ukrainian novelist, poet, and essayist, author of Fieldwork in Ukrainian Sex.'),
('George Orwell', 'English novelist and essayist, famous for 1984 and Animal Farm.'),
('J.R.R. Tolkien', 'English writer and academic, best known for The Lord of the Rings.'),
('Stephen King', 'American author of horror, supernatural fiction, suspense, and fantasy novels.'),
('Yuval Noah Harari', 'Israeli public intellectual, historian, and author of Sapiens.'),
('Robert C. Martin', 'American software engineer and author known for Clean Code.');

INSERT INTO books (book_title, book_isbn, publication_year) VALUES
('Kobzar', '9789660381234', 1840),
('Forest Song', '9789660385678', 1911),
('Zakhar Berkut', '9789660389012', 1883),
('Anarchy in the UKR', '9789663591234', 2005),
('Fieldwork in Ukrainian Sex', '9789663595678', 1996),
('1984', '9780451524935', 1949),
('The Fellowship of the Ring', '9780618346257', 1954),
('The Shining', '9780307743657', 1977),
('Sapiens: A Brief History of Humankind', '9780062316097', 2011),
('Clean Code: A Handbook of Agile Software Craftsmanship', '9780132350884', 2008);

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1),  -- Kobzar - Taras Shevchenko
(2, 2),  -- Forest Song - Lesya Ukrainka
(3, 3),  -- Zakhar Berkut - Ivan Franko
(4, 4),  -- Anarchy in the UKR - Serhiy Zhadan
(5, 5),  -- Fieldwork in Ukrainian Sex - Oksana Zabuzhko
(6, 6),  -- 1984 - George Orwell
(7, 7),  -- The Fellowship of the Ring - J.R.R. Tolkien
(8, 8),  -- The Shining - Stephen King
(9, 9),  -- Sapiens - Yuval Noah Harari
(10, 10); -- Clean Code - Robert C. Martin

INSERT INTO books_categories (book_id, category_id) VALUES
(1, 1),  -- Kobzar - Fiction
(2, 3),  -- Forest Song - Fantasy
(3, 4),  -- Zakhar Berkut - History
(4, 1),  -- Anarchy in the UKR - Fiction
(5, 1),  -- Fieldwork in Ukrainian Sex - Fiction
(6, 2),  -- 1984 - Science Fiction
(7, 3),  -- The Fellowship of the Ring - Fantasy
(8, 1),  -- The Shining - Fiction
(9, 4),  -- Sapiens - History
(10, 5); -- Clean Code - Computer Science
      
INSERT INTO reservations (book_id, member_id, reservation_date, reservation_status) VALUES
(1, 3, '2026-10-01', 'Completed'),
(2, 5, '2026-10-02', 'Completed'),
(3, 1, '2026-10-03', 'Cancelled'),
(4, 7, '2026-10-05', 'Active'),
(5, 2, '2026-10-06', 'Active'),
(6, 9, '2026-10-07', 'Active'),
(7, 4, '2026-10-08', 'Cancelled'),
(8, 8, '2026-10-09', 'Active'),
(9, 6, '2026-10-10', 'Active'),
(10, 10, '2026-10-11', 'Active');

INSERT INTO borrowings (member_id, copy_id, borrowing_date, due_date, return_date) VALUES
(1, 1, '2026-09-01', '2026-09-15', '2026-09-14'), 
(2, 2, '2026-09-03', '2026-09-17', '2026-09-17'), 
(3, 3, '2026-09-05', '2026-09-19', '2026-09-22'),
(4, 4, '2026-09-10', '2026-09-24', '2026-09-20'), 
(5, 5, '2026-09-15', '2026-09-29', '2026-09-28'), 
(6, 6, '2026-09-20', '2026-10-04', NULL),         
(7, 7, '2026-09-22', '2026-10-06', NULL),         
(8, 1, '2026-09-25', '2026-10-09', NULL),         
(9, 2, '2026-09-28', '2026-10-12', NULL),         
(10, 3, '2026-10-01', '2026-10-15', NULL);

INSERT INTO book_copies (book_id, copy_number, is_available) VALUES
(1, 101, true),  -- Книга 1, копия 1 (доступна)
(1, 102, false), -- Книга 1, копия 2 (выдана)
(2, 201, true),  -- Книга 2, копия 1 (доступна)
(2, 202, true),  -- Книга 2, копия 2 (доступна)
(3, 301, false), -- Книга 3, копия 1 (выдана)
(3, 302, true),  -- Книга 3, копия 2 (доступна)
(4, 401, true),  -- Книга 4, копия 1 (доступна)
(4, 402, false), -- Книга 4, копия 2 (выдана)
(5, 501, true),  -- Книга 5, копия 1 (доступна)
(5, 502, true);  -- Книга 5, копия 2 (доступна)

