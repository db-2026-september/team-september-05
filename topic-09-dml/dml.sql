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

