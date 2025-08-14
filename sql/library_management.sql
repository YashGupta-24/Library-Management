CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    category VARCHAR(100),
    published_year INT,
    available_copies INT DEFAULT 0
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(15),
    join_date DATE
);

CREATE TABLE BorrowRecords (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

INSERT INTO Books 
(title, author, category, published_year, available_copies) 
VALUES
('Atomic Habits', 'James Clear', 'Self-help', 2018, 5),
('The Alchemist', 'Paulo Coelho', 'Fiction', 1988, 3),
('Clean Code', 'Robert C. Martin', 'Programming', 2008, 2),
('Deep Work', 'Cal Newport', 'Productivity', 2016, 4);

INSERT INTO Members 
(name, email, phone, join_date) 
VALUES
('Johnson', 'johnson@example.com', '9870000000', '2022-01-15'),
('Smith', 'smith@example.com', '9876000000', '2022-02-20'),
('Charlie', 'charlie@example.com', '9876500000', '2022-03-10');

INSERT INTO BorrowRecords 
(book_id, member_id, borrow_date, return_date) 
VALUES
(1, 1, '2023-07-01', '2023-07-10'),
(2, 1, '2023-07-15', NULL),
(3, 2, '2023-07-05', '2023-07-20'),
(1, 3, '2023-07-18', NULL);

-- 1. Get all books by a specific author
SELECT * FROM Books WHERE author = 'Paulo Coelho';

-- 2. Count total available books in each category
SELECT category, SUM(available_copies) AS total_available
FROM Books
GROUP BY category;

-- 3. List members who have borrowed more than 1 book
SELECT m.name, COUNT(br.record_id) AS books_borrowed
FROM Members m
JOIN BorrowRecords br ON m.member_id = br.member_id
GROUP BY m.member_id
HAVING COUNT(br.record_id) > 1;

-- 4. Find overdue books (more than 15 days and not returned)
SELECT m.name, b.title, br.borrow_date
FROM BorrowRecords br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE br.return_date IS NULL AND DATEDIFF(CURDATE(), br.borrow_date) > 15;

-- 5. Join tables to show member names with the books they borrowed
SELECT m.name, b.title, br.borrow_date, br.return_date
FROM BorrowRecords br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id;
