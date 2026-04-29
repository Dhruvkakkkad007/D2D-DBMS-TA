-- LAB 9: Advanced Joins (Author, Publisher, Book)

CREATE TABLE Author (
    AuthorID   INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL,
    Country    VARCHAR(50)
);

CREATE TABLE Publisher (
    PublisherID   INT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL UNIQUE,
    City          VARCHAR(50)  NOT NULL
);

CREATE TABLE Book (
    BookID          INT PRIMARY KEY,
    Title           VARCHAR(200) NOT NULL,
    AuthorID        INT NOT NULL FOREIGN KEY REFERENCES Author(AuthorID),
    PublisherID     INT NOT NULL FOREIGN KEY REFERENCES Publisher(PublisherID),
    Price           DECIMAL(8,2) NOT NULL,
    PublicationYear INT NOT NULL
);

INSERT INTO Author VALUES
(1, 'Chetan Bhagat',   'India'),
(2, 'Arundhati Roy',   'India'),
(3, 'Amish Tripathi',  'India'),
(4, 'Ruskin Bond',     'India'),
(5, 'Jhumpa Lahiri',   'India'),
(6, 'Paulo Coelho',    'Brazil'),
(7, 'Sudha Murty',     'India');

INSERT INTO Publisher VALUES
(1, 'Rupa Publications',    'New Delhi'),
(2, 'Penguin India',        'Gurugram'),
(3, 'HarperCollins India',  'Noida'),
(4, 'Aleph Book Company',   'New Delhi');

INSERT INTO Book VALUES
(101, 'Five Point Someone',       1, 1, 250.00, 2004),
(102, 'The God of Small Things',  2, 2, 350.00, 1997),
(103, 'Immortals of Meluha',      3, 3, 300.00, 2010),
(104, 'The Blue Umbrella',        4, 1, 180.00, 1980),
(105, 'The Lowland',              5, 2, 400.00, 2013),
(106, 'Revolution 2020',          1, 1, 275.00, 2011),
(107, 'Sita: Warrior of Mithila', 3, 3, 320.00, 2017),
(108, 'The Room on the Roof',     4, 4, 200.00, 1956);


-- LAB 9 - PART A

-- A1. All books with authors
SELECT b.Title, a.AuthorName
FROM Book b INNER JOIN Author a ON b.AuthorID = a.AuthorID;

-- A2. All books with publishers
SELECT b.Title, p.PublisherName
FROM Book b INNER JOIN Publisher p ON b.PublisherID = p.PublisherID;

-- A3. All books with authors and publishers
SELECT b.Title, a.AuthorName, p.PublisherName
FROM Book b
INNER JOIN Author a ON b.AuthorID = a.AuthorID
INNER JOIN Publisher p ON b.PublisherID = p.PublisherID;

-- A4. Books published after 2010 with author, publisher, price
SELECT b.Title, a.AuthorName, p.PublisherName, b.Price
FROM Book b
INNER JOIN Author a ON b.AuthorID = a.AuthorID
INNER JOIN Publisher p ON b.PublisherID = p.PublisherID
WHERE b.PublicationYear > 2010;

-- A5. Authors and number of books written
SELECT a.AuthorName, COUNT(b.BookID) AS BookCount
FROM Author a LEFT JOIN Book b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorName;

-- A6. Publishers with total price of books
SELECT p.PublisherName, SUM(b.Price) AS TotalPrice
FROM Publisher p INNER JOIN Book b ON p.PublisherID = b.PublisherID
GROUP BY p.PublisherName;

-- A7. Authors who have NOT written any books
SELECT a.AuthorName FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
WHERE b.BookID IS NULL;

-- A8. Total books and average price of every author
SELECT a.AuthorName, COUNT(b.BookID) AS TotalBooks, AVG(b.Price) AS AvgPrice
FROM Author a INNER JOIN Book b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorName;

-- A9. Publisher with total books, sorted highest to lowest
SELECT p.PublisherName, COUNT(b.BookID) AS TotalBooks
FROM Publisher p INNER JOIN Book b ON p.PublisherID = b.PublisherID
GROUP BY p.PublisherName ORDER BY TotalBooks DESC;

-- A10. Books published each year
SELECT PublicationYear, COUNT(*) AS BookCount
FROM Book GROUP BY PublicationYear;

-- LAB 9 - PART B

-- B1. Publishers whose total price > 500, ordered by total price
SELECT p.PublisherName, SUM(b.Price) AS TotalPrice
FROM Publisher p INNER JOIN Book b ON p.PublisherID = b.PublisherID
GROUP BY p.PublisherName HAVING SUM(b.Price) > 500
ORDER BY TotalPrice;

-- B2. Most expensive book per author, sorted by highest price
SELECT a.AuthorName, MAX(b.Price) AS MaxPrice
FROM Author a INNER JOIN Book b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorName ORDER BY MaxPrice DESC;

