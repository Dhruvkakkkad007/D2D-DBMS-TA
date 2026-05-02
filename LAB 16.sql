-- EmployeeDetails Table Creation
CREATE TABLE EmployeeDetails (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    ContactNo VARCHAR(10) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    JoiningDate DATETIME NULL
);



-- EmployeeLogs Table Creation
CREATE TABLE EmployeeLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);


-- Sample Insert
INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES 
(1, 'Dhruv', '9876543210', 'IT', 50000, NULL),
(2, 'Raj', '9123456780', 'HR', 40000, GETDATE());




--PART - A

-- Q1: AFTER trigger to display message 
GO
CREATE TRIGGER trg_DisplayMessage
ON EmployeeDetails
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    PRINT 'Employee record affected.';
END;
GO

--Q2: AFTER trigger to log INSERT, UPDATE, DELETE 

CREATE TRIGGER trg_LogOperations
ON EmployeeDetails
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- INSERT
    INSERT INTO EmployeeLogs (EmployeeID, EmployeeName, ActionPerformed, ActionDate)
    SELECT EmployeeID, EmployeeName, 'INSERT', GETDATE()
    FROM inserted;

    -- DELETE
    INSERT INTO EmployeeLogs (EmployeeID, EmployeeName, ActionPerformed, ActionDate)
    SELECT EmployeeID, EmployeeName, 'DELETE', GETDATE()
    FROM deleted;

    -- UPDATE
    INSERT INTO EmployeeLogs (EmployeeID, EmployeeName, ActionPerformed, ActionDate)
    SELECT i.EmployeeID, i.EmployeeName, 'UPDATE', GETDATE()
    FROM inserted i
    INNER JOIN deleted d ON i.EmployeeID = d.EmployeeID;
END;


-- Q3: AFTER INSERT trigger to calculate bonus (10%) 
GO
CREATE TRIGGER trg_CalculateBonus
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
    UPDATE e
    SET Salary = Salary + (Salary * 0.10)
    FROM EmployeeDetails e
    INNER JOIN inserted i ON e.EmployeeID = i.EmployeeID;
END;
GO

--PART - B  

-- Q1: Set JoiningDate automatically if NULL 
GO
CREATE TRIGGER trg_SetJoiningDate
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
    UPDATE e
    SET JoiningDate = GETDATE()
    FROM EmployeeDetails e
    INNER JOIN inserted i ON e.EmployeeID = i.EmployeeID
    WHERE i.JoiningDate IS NULL;
END;
GO

 --PART – C

-- Q1: Validate ContactNo (must be 10 digits) 
GO
CREATE TRIGGER trg_ValidateContact
ON EmployeeDetails
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT * FROM inserted
        WHERE LEN(ContactNo) <> 10 OR ContactNo LIKE '%[^0-9]%'
    )
    BEGIN
        PRINT 'Invalid Contact Number. Must be exactly 10 digits.';
        RETURN;
    END;

    INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
    SELECT EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate
    FROM inserted;
END;
GO


 --TEST DATA
  

-- Valid Insert
INSERT INTO EmployeeDetails VALUES (1, 'Dhruv', '9876543210', 'IT', 50000, NULL);

-- Invalid Insert (will fail)
INSERT INTO EmployeeDetails VALUES (2, 'Raj', '12345', 'HR', 40000, NULL);

-- Update Test
UPDATE EmployeeDetails SET Salary = 60000 WHERE EmployeeID = 1;

-- Delete Test
DELETE FROM EmployeeDetails WHERE EmployeeID = 1;


--VIEW LOG TABLE

SELECT * FROM EmployeeLogs;

    

                                            --INSTEAD OF TRIGGER--



                                     
-- LAB – INSTEAD OF TRIGGERS (MOVIES)



CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3,1) NOT NULL,
    Duration INT NOT NULL   -- Duration in minutes
);


CREATE TABLE MoviesLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MovieID INT NOT NULL,
    MovieTitle VARCHAR(255) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);


--PART-A
-- Q1: INSTEAD OF trigger for INSERT, UPDATE, DELETE with logging
GO
CREATE TRIGGER trg_Movies_AllOperations
ON Movies
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    -- Handle INSERT
    INSERT INTO Movies
    SELECT * FROM inserted
    WHERE NOT EXISTS (SELECT * FROM deleted);

    INSERT INTO MoviesLog
    SELECT MovieID, MovieTitle, 'INSERT', GETDATE()
    FROM inserted
    WHERE NOT EXISTS (SELECT * FROM deleted);

    -- Handle DELETE
    DELETE FROM Movies
    WHERE MovieID IN (SELECT MovieID FROM deleted);

    INSERT INTO MoviesLog
    SELECT MovieID, MovieTitle, 'DELETE', GETDATE()
    FROM deleted;

    -- Handle UPDATE
    UPDATE m
    SET 
        m.MovieTitle = i.MovieTitle,
        m.ReleaseYear = i.ReleaseYear,
        m.Genre = i.Genre,
        m.Rating = i.Rating,
        m.Duration = i.Duration
    FROM Movies m
    INNER JOIN inserted i ON m.MovieID = i.MovieID
    INNER JOIN deleted d ON i.MovieID = d.MovieID;

    INSERT INTO MoviesLog
    SELECT i.MovieID, i.MovieTitle, 'UPDATE', GETDATE()
    FROM inserted i
    INNER JOIN deleted d ON i.MovieID = d.MovieID;
END;
GO



-- Q2: Allow only movies with Rating > 5.5
GO
CREATE TRIGGER trg_CheckRating
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Rating <= 5.5)
    BEGIN
        PRINT 'Movie rating must be greater than 5.5';
        RETURN;
    END;

    INSERT INTO Movies
    SELECT * FROM inserted;
END;
GO
-- Q3: Prevent duplicate MovieTitle and log it
GO
CREATE TRIGGER trg_PreventDuplicateTitle
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT i.MovieTitle
        FROM inserted i
        JOIN Movies m ON i.MovieTitle = m.MovieTitle
    )
    BEGIN
        PRINT 'Duplicate Movie Title not allowed';

        -- Log duplicate attempt
        INSERT INTO MoviesLog
        SELECT MovieID, MovieTitle, 'DUPLICATE BLOCKED', GETDATE()
        FROM inserted;

        RETURN;
    END;

    INSERT INTO Movies
    SELECT * FROM inserted;
END;
GO

-- PART – B

-- Q1: Prevent inserting pre-release movies
GO
CREATE TRIGGER trg_PreventPreRelease
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE ReleaseYear > YEAR(GETDATE()))
    BEGIN
        PRINT 'Cannot insert pre-release movies';
        RETURN;
    END;

    INSERT INTO Movies
    SELECT * FROM inserted;
END;
GO

-- PART – C

-- Q1: Prevent updating Duration > 120 minutes
GO
CREATE TRIGGER trg_CheckDuration
ON Movies
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Duration > 120)
    BEGIN
        PRINT 'Duration cannot exceed 120 minutes';
        RETURN;
    END;

    UPDATE m
    SET 
        m.MovieTitle = i.MovieTitle,
        m.ReleaseYear = i.ReleaseYear,
        m.Genre = i.Genre,
        m.Rating = i.Rating,
        m.Duration = i.Duration
    FROM Movies m
    INNER JOIN inserted i ON m.MovieID = i.MovieID;
END;
GO

-- TEST QUERIES

-- Valid Insert
INSERT INTO Movies VALUES (1, 'Inception', 2010, 'Sci-Fi', 8.8, 120);

-- Invalid Rating (will fail)
INSERT INTO Movies VALUES (2, 'Low Movie', 2020, 'Drama', 4.0, 100);

-- Duplicate Title (will fail)
INSERT INTO Movies VALUES (3, 'Inception', 2015, 'Action', 7.0, 110);

-- Pre-release movie (will fail)
INSERT INTO Movies VALUES (4, 'Future Movie', 2030, 'Sci-Fi', 7.5, 110);

-- Invalid Duration update (will fail)
UPDATE Movies SET Duration = 150 WHERE MovieID = 1;


-- VIEW LOGS
SELECT * FROM MoviesLog;