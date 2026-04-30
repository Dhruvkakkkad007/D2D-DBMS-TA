-- LAB 14: Cursors



GO
CREATE TABLE Products (
    Product_id   INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price        DECIMAL(10,2) NOT NULL
);

INSERT INTO Products VALUES
(1, 'Smartphone',     35000),
(2, 'Laptop',         65000),
(3, 'Headphones',     5500),
(4, 'Television',     85000),
(5, 'Gaming Console', 32000);

-- PART A

-- A1. Cursor to fetch all rows
GO
DECLARE @Product_id INT, @Product_Name VARCHAR(250), @Price DECIMAL(10,2);

DECLARE Product_Cursor CURSOR FOR
    SELECT Product_id, Product_Name, Price FROM Products;

OPEN Product_Cursor;
FETCH NEXT FROM Product_Cursor INTO @Product_id, @Product_Name, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ID: ' + CAST(@Product_id AS VARCHAR) +
          ' | Name: ' + @Product_Name +
          ' | Price: ' + CAST(@Price AS VARCHAR);
    FETCH NEXT FROM Product_Cursor INTO @Product_id, @Product_Name, @Price;
END

CLOSE Product_Cursor;
DEALLOCATE Product_Cursor;

-- A2. Cursor to fetch records as ProductID_ProductName
GO
DECLARE @pid INT, @pname VARCHAR(250);

DECLARE Product_Cursor_Fetch CURSOR FOR
    SELECT Product_id, Product_Name FROM Products;

OPEN Product_Cursor_Fetch;
FETCH NEXT FROM Product_Cursor_Fetch INTO @pid, @pname;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CAST(@pid AS VARCHAR) + '_' + @pname;
    FETCH NEXT FROM Product_Cursor_Fetch INTO @pid, @pname;
END

CLOSE Product_Cursor_Fetch;
DEALLOCATE Product_Cursor_Fetch;

-- A3. Cursor to find products above price 30,000
GO
DECLARE @pid3 INT, @pname3 VARCHAR(250), @price3 DECIMAL(10,2);

DECLARE Cursor_Above30K CURSOR FOR
    SELECT Product_id, Product_Name, Price FROM Products WHERE Price > 30000;

OPEN Cursor_Above30K;
FETCH NEXT FROM Cursor_Above30K INTO @pid3, @pname3, @price3;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @pname3 + ' - Rs.' + CAST(@price3 AS VARCHAR);
    FETCH NEXT FROM Cursor_Above30K INTO @pid3, @pname3, @price3;
END

CLOSE Cursor_Above30K;
DEALLOCATE Cursor_Above30K;

-- A4. Cursor to delete all data from Products
GO
DECLARE @pid4 INT;

DECLARE Product_CursorDelete CURSOR FOR
    SELECT Product_id FROM Products;

OPEN Product_CursorDelete;
FETCH NEXT FROM Product_CursorDelete INTO @pid4;

WHILE @@FETCH_STATUS = 0
BEGIN
    DELETE FROM Products WHERE Product_id = @pid4;
    FETCH NEXT FROM Product_CursorDelete INTO @pid4;
END

CLOSE Product_CursorDelete;
DEALLOCATE Product_CursorDelete;

-- PART B

-- B1. Cursor to increase price by 10%
-- (Re-insert data first if deleted above)
GO
DECLARE @pid5 INT;

DECLARE Product_CursorUpdate CURSOR FOR
    SELECT Product_id FROM Products;

OPEN Product_CursorUpdate;
FETCH NEXT FROM Product_CursorUpdate INTO @pid5;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Products SET Price = Price * 1.10 WHERE Product_id = @pid5;
    FETCH NEXT FROM Product_CursorUpdate INTO @pid5;
END

CLOSE Product_CursorUpdate;
DEALLOCATE Product_CursorUpdate;

-- B2. Cursor to round prices to nearest whole number
GO
DECLARE @pid6 INT, @price6 DECIMAL(10,2);

DECLARE Cursor_Round CURSOR FOR
    SELECT Product_id, Price FROM Products;

OPEN Cursor_Round;
FETCH NEXT FROM Cursor_Round INTO @pid6, @price6;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Products SET Price = ROUND(@price6, 0) WHERE Product_id = @pid6;
    FETCH NEXT FROM Cursor_Round INTO @pid6, @price6;
END

CLOSE Cursor_Round;
DEALLOCATE Cursor_Round;

-- PART C

-- C1. Insert Laptop into NewProducts table
GO
CREATE TABLE NewProducts (
    Product_id   INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price        DECIMAL(10,2) NOT NULL
);

DECLARE @pid7 INT, @pname7 VARCHAR(250), @price7 DECIMAL(10,2);

DECLARE Cursor_Laptop CURSOR FOR
    SELECT Product_id, Product_Name, Price FROM Products WHERE Product_Name = 'Laptop';

OPEN Cursor_Laptop;
FETCH NEXT FROM Cursor_Laptop INTO @pid7, @pname7, @price7;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO NewProducts VALUES(@pid7, @pname7, @price7);
    FETCH NEXT FROM Cursor_Laptop INTO @pid7, @pname7, @price7;
END

CLOSE Cursor_Laptop;
DEALLOCATE Cursor_Laptop;

-- C2. Archive products with price > 50000
GO
CREATE TABLE ArchivedProducts (
    Product_id   INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price        DECIMAL(10,2) NOT NULL
);

DECLARE @pid8 INT, @pname8 VARCHAR(250), @price8 DECIMAL(10,2);

DECLARE Cursor_Archive CURSOR FOR
    SELECT Product_id, Product_Name, Price FROM Products WHERE Price > 50000;

OPEN Cursor_Archive;
FETCH NEXT FROM Cursor_Archive INTO @pid8, @pname8, @price8;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO ArchivedProducts VALUES(@pid8, @pname8, @price8);
    DELETE FROM Products WHERE Product_id = @pid8;
    FETCH NEXT FROM Cursor_Archive INTO @pid8, @pname8, @price8;
END

CLOSE Cursor_Archive;
DEALLOCATE Cursor_Archive;