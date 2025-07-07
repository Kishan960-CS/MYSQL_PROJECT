/* Project Title --
Library Management System (Basic) */

CREATE DATABASE LIBRARY_MANAGEMENT_SYSTEM;
USE LIBRARY_MANAGEMENT_SYSTEM;

/* Project Description --
Design and query a MySQL database for a simple library management system. 
The system will track books, members, and borrow records.

Skills demonstrated:- 
 Creating tables with foreign keys
 Inserting data
 Simple and JOIN queries
 Aggregate functions
 Filtering 
 
 ER Diagram (Text Description) --
Tables and relationships:-

Member (member_id PK)
Book (book_id PK)
Borrow (borrow_id PK, FK to member_id, FK to book_id)

One member can borrow many books.
One book can be borrowed many times.

Database Schema--
1️. Member-
Column	Type	Constraint
member_id	INT	PRIMARY KEY
first_name	VARCHAR(50)	NOT NULL
last_name	VARCHAR(50)	NOT NULL
email	VARCHAR(100)	UNIQUE

2️. Book-
Column	Type	Constraint
book_id	INT	PRIMARY KEY
title	VARCHAR(100)	NOT NULL
author	VARCHAR(100)	NOT NULL
genre	VARCHAR(50)	

3️. Borrow-
Column	Type	Constraint
borrow_id	INT	PRIMARY KEY
member_id	INT	FOREIGN KEY -> Member
book_id	INT	FOREIGN KEY -> Book
borrow_date	DATE	
return_date	DATE
 */
 
 -- CREATE TABLE
 
 CREATE TABLE Member (member_id INT PRIMARY KEY, first_name VARCHAR(50) NOT NULL, last_name VARCHAR(50) NOT NULL, email VARCHAR(100) UNIQUE);
 
 CREATE TABLE Book (book_id INT PRIMARY KEY, title VARCHAR(100) NOT NULL, author VARCHAR(100) NOT NULL, genre VARCHAR(50));

CREATE TABLE Borrow (borrow_id INT PRIMARY KEY, member_id INT, book_id INT, borrow_date DATE, return_date DATE,
  FOREIGN KEY (member_id) REFERENCES Member(member_id), FOREIGN KEY (book_id) REFERENCES Book(book_id));

-- INSERT DATA

INSERT INTO Member VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Brown', 'alice.brown@example.com');

INSERT INTO Book VALUES
(1, '1984', 'George Orwell', 'Dystopian'),
(2, 'To Kill a Mockingbird', 'Harper Lee', 'Classic'),
(3, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic'),
(4, 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy');

INSERT INTO Borrow VALUES
(1, 1, 2, '2024-03-01', '2024-03-10'),
(2, 2, 3, '2024-03-05', '2024-03-15'),
(3, 1, 4, '2024-04-01', NULL),
(4, 3, 1, '2024-04-02', NULL);

-- 1./ View all members
SELECT * FROM Member;

-- 2./ List all books in "Classic" genre
SELECT * FROM Book WHERE genre = 'Classic';

-- 3./ Show all borrow records
SELECT * FROM Borrow;

-- 4./ Show all borrow records with member and book details
SELECT b.borrow_id, m.first_name, m.last_name, bk.title, bk.author, b.borrow_date, b.return_date
FROM Borrow b
JOIN Member m ON b.member_id = m.member_id
JOIN Book bk ON b.book_id = bk.book_id;

-- 5./ Find all currently borrowed books (not yet returned)
SELECT b.borrow_id, m.first_name, bk.title, b.borrow_date
FROM Borrow b
JOIN Member m ON b.member_id = m.member_id
JOIN Book bk ON b.book_id = bk.book_id
WHERE b.return_date IS NULL;

-- 6./ Count total books borrowed by each member
SELECT m.member_id, m.first_name, m.last_name,
  COUNT(b.borrow_id) AS total_borrowed
FROM Member m
LEFT JOIN Borrow b ON m.member_id = b.member_id
GROUP BY m.member_id, m.first_name, m.last_name;

-- 7./ Find most borrowed books
SELECT bk.book_id, bk.title,
  COUNT(b.borrow_id) AS times_borrowed
FROM Book bk
LEFT JOIN Borrow b ON bk.book_id = b.book_id
GROUP BY bk.book_id, bk.title
ORDER BY times_borrowed DESC;

-- 8./ List members with no borrow records
SELECT m.* FROM Member m
LEFT JOIN Borrow b ON m.member_id = b.member_id
WHERE b.borrow_id IS NULL;

-- 9./ Count total borrows
SELECT COUNT(*) AS total_borrows FROM Borrow;

-- 10./ List all books never borrowed
SELECT bk.* FROM Book bk
LEFT JOIN Borrow b ON bk.book_id = b.book_id
WHERE b.borrow_id IS NULL;

-- 11./ Find the members who have borrowed more than one book
SELECT m.member_id, m.first_name, m.last_name, COUNT(b.borrow_id) AS borrow_count
FROM Member m
JOIN Borrow b ON m.member_id = b.member_id
GROUP BY m.member_id, m.first_name, m.last_name
HAVING COUNT(b.borrow_id) > 1;

-- 12./ List all books along with the number of times they were borrowed, even if zero
SELECT bk.book_id, bk.title, COUNT(b.borrow_id) AS times_borrowed
FROM Book bk
LEFT JOIN Borrow b ON bk.book_id = b.book_id
GROUP BY bk.book_id, bk.title;

-- 13./ Show overdue borrowed books assuming the return period is 14 days
SELECT b.borrow_id, m.first_name, bk.title, b.borrow_date
FROM Borrow b
JOIN Member m ON b.member_id = m.member_id
JOIN Book bk ON b.book_id = bk.book_id
WHERE b.return_date IS NULL
AND DATEDIFF(CURDATE(), b.borrow_date) > 14;

-- 14./ Find all borrowing records sorted by borrow date (most recent first)
SELECT b.borrow_id, m.first_name, m.last_name, bk.title, b.borrow_date, b.return_date
FROM Borrow b
JOIN Member m ON b.member_id = m.member_id
JOIN Book bk ON b.book_id = bk.book_id
ORDER BY b.borrow_date DESC;

-- 15./ Show the most active members (top 2 by number of borrows)
SELECT m.member_id, m.first_name, m.last_name, COUNT(b.borrow_id) AS total_borrows
FROM Member m
JOIN Borrow b ON m.member_id = b.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY total_borrows DESC
LIMIT 2;
