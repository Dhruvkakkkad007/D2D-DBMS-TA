-- LAB 11: Stored Procedures


--PART - A


CREATE TABLE Department (
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Designation (
    DesignationID   INT PRIMARY KEY,
    DesignationName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Person (
    PersonID       INT PRIMARY KEY IDENTITY(101,1),
    FirstName      VARCHAR(100) NOT NULL,
    LastName       VARCHAR(100) NOT NULL,
    Salary         DECIMAL(8,2) NOT NULL,
    JoiningDate    DATETIME NOT NULL,
    DepartmentID   INT FOREIGN KEY REFERENCES Department(DepartmentID),
    DesignationID  INT FOREIGN KEY REFERENCES Designation(DesignationID)
);

INSERT INTO Department VALUES
(1,'Admin'),(2,'IT'),(3,'HR'),(4,'Account');

INSERT INTO Designation VALUES
(11,'Jobber'),(12,'Welder'),(13,'Clerk'),(14,'Manager'),(15,'CEO');

INSERT INTO Person (FirstName,LastName,Salary,JoiningDate,DepartmentID,DesignationID) VALUES
('Rahul',  'Anshu',   56000, '1990-01-01', 1, 12),
('Hardik', 'Hinsu',   18000, '1990-09-25', 2, 11),
('Bhavin', 'Kamani',  25000, '1991-05-14', NULL, 11),
('Bhoomi', 'Patel',   39000, '2014-02-20', 1, 13),
('Rohit',  'Rajgor',  17000, '1990-07-23', 2, 15),
('Priya',  'Mehta',   25000, '1990-10-18', 2, NULL),
('Neha',   'Trivedi', 18000, '2014-02-20', 3, 15);





--PART - A

-- Department: INSERT
GO
CREATE PROCEDURE sp_Department_Insert
    @DepartmentID   INT,
    @DepartmentName VARCHAR(100)
AS
BEGIN
    INSERT INTO Department VALUES (@DepartmentID, @DepartmentName);
    PRINT 'Department inserted successfully.';
END
GO

-- Department: UPDATE
CREATE PROCEDURE sp_Department_Update
    @DepartmentID   INT,
    @DepartmentName VARCHAR(100)
AS
BEGIN
    UPDATE Department SET DepartmentName = @DepartmentName
    WHERE DepartmentID = @DepartmentID;
    PRINT 'Department updated successfully.';
END
GO

-- Department: DELETE
CREATE PROCEDURE sp_Department_Delete
    @DepartmentID INT
AS
BEGIN
    DELETE FROM Department WHERE DepartmentID = @DepartmentID;
    PRINT 'Department deleted successfully.';
END
GO

-- Department: SELECT BY PRIMARY KEY
CREATE PROCEDURE sp_Department_SelectByPK
    @DepartmentID INT
AS
BEGIN
    SELECT * FROM Department WHERE DepartmentID = @DepartmentID;
END
GO

-- Person: INSERT
CREATE PROCEDURE sp_Person_Insert
    @FirstName     VARCHAR(100),
    @LastName      VARCHAR(100),
    @Salary        DECIMAL(8,2),
    @JoiningDate   DATETIME,
    @DepartmentID  INT,
    @DesignationID INT
AS
BEGIN
    INSERT INTO Person(FirstName,LastName,Salary,JoiningDate,DepartmentID,DesignationID)
    VALUES(@FirstName,@LastName,@Salary,@JoiningDate,@DepartmentID,@DesignationID);
    PRINT 'Person inserted successfully.';
END
GO

-- Person: UPDATE
CREATE PROCEDURE sp_Person_Update
    @PersonID      INT,
    @FirstName     VARCHAR(100),
    @LastName      VARCHAR(100),
    @Salary        DECIMAL(8,2),
    @DepartmentID  INT,
    @DesignationID INT
AS
BEGIN
    UPDATE Person
    SET FirstName=@FirstName, LastName=@LastName, Salary=@Salary,
        DepartmentID=@DepartmentID, DesignationID=@DesignationID
    WHERE PersonID = @PersonID;
    PRINT 'Person updated successfully.';
END
GO

-- Person: DELETE
CREATE PROCEDURE sp_Person_Delete
    @PersonID INT
AS
BEGIN
    DELETE FROM Person WHERE PersonID = @PersonID;
    PRINT 'Person deleted successfully.';
END
GO

-- Person: SELECT BY PRIMARY KEY (with JOIN for dept & designation)
CREATE PROCEDURE sp_Person_SelectByPK
    @PersonID INT
AS
BEGIN
    SELECT p.PersonID, p.FirstName, p.LastName, p.Salary, p.JoiningDate,
           d.DepartmentName, des.DesignationName
    FROM Person p
    LEFT JOIN Department d   ON p.DepartmentID = d.DepartmentID
    LEFT JOIN Designation des ON p.DesignationID = des.DesignationID
    WHERE p.PersonID = @PersonID;
END
GO

-- A4. First 3 persons
CREATE PROCEDURE sp_Person_First3
AS
BEGIN
    SELECT TOP 3 p.PersonID, p.FirstName, p.LastName, p.Salary, p.JoiningDate,
                 d.DepartmentName, des.DesignationName
    FROM Person p
    LEFT JOIN Department d   ON p.DepartmentID = d.DepartmentID
    LEFT JOIN Designation des ON p.DesignationID = des.DesignationID;
END
GO



--PART - B 

-- B1. Get all workers by department name
CREATE PROCEDURE sp_GetByDeptName
    @DeptName VARCHAR(100)
AS
BEGIN
    SELECT p.* FROM Person p
    INNER JOIN Department d ON p.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = @DeptName;
END
GO

-- B2. Get workers by department and designation name
CREATE PROCEDURE sp_GetByDeptAndDesig
    @DeptName  VARCHAR(100),
    @DesigName VARCHAR(100)
AS
BEGIN
    SELECT p.FirstName, p.Salary, p.JoiningDate, d.DepartmentName
    FROM Person p
    INNER JOIN Department d   ON p.DepartmentID = d.DepartmentID
    INNER JOIN Designation des ON p.DesignationID = des.DesignationID
    WHERE d.DepartmentName = @DeptName AND des.DesignationName = @DesigName;
END
GO

-- B3. Get worker details by first name
CREATE PROCEDURE sp_GetByFirstName
    @FirstName VARCHAR(100)
AS
BEGIN
    SELECT p.*, d.DepartmentName, des.DesignationName
    FROM Person p
    LEFT JOIN Department d   ON p.DepartmentID = d.DepartmentID
    LEFT JOIN Designation des ON p.DesignationID = des.DesignationID
    WHERE p.FirstName = @FirstName;
END
GO

-- B4. Department wise max, min, total salary
CREATE PROCEDURE sp_DeptSalaryStats
AS
BEGIN
    SELECT d.DepartmentName,
           MAX(p.Salary) AS MaxSal,
           MIN(p.Salary) AS MinSal,
           SUM(p.Salary) AS TotalSal
    FROM Person p
    INNER JOIN Department d ON p.DepartmentID = d.DepartmentID
    GROUP BY d.DepartmentName;
END
GO

-- B5. Designation wise avg and total salary
CREATE PROCEDURE sp_DesigSalaryStats
AS
BEGIN
    SELECT des.DesignationName,
           AVG(p.Salary) AS AvgSal,
           SUM(p.Salary) AS TotalSal
    FROM Person p
    INNER JOIN Designation des ON p.DesignationID = des.DesignationID
    GROUP BY des.DesignationName;
END
GO


--PART - C


-- C1. Accept Department Name, return person count
CREATE PROCEDURE sp_PersonCount_ByDept
    @DeptName VARCHAR(100)
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) FROM Person p
    INNER JOIN Department d ON p.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = @DeptName;
    PRINT 'Total Persons: ' + CAST(@Count AS VARCHAR);
END
GO

-- C2. Workers with salary > input, with dept and designation
CREATE PROCEDURE sp_GetBySalaryGreater
    @MinSalary DECIMAL(8,2)
AS
BEGIN
    SELECT p.FirstName, p.Salary, d.DepartmentName, des.DesignationName
    FROM Person p
    LEFT JOIN Department d   ON p.DepartmentID = d.DepartmentID
    LEFT JOIN Designation des ON p.DesignationID = des.DesignationID
    WHERE p.Salary > @MinSalary;
END
GO

-- C3. Department with highest total salary
CREATE PROCEDURE sp_DeptHighestTotalSal
AS
BEGIN
    SELECT TOP 1 d.DepartmentName, SUM(p.Salary) AS TotalSalary
    FROM Person p
    INNER JOIN Department d ON p.DepartmentID = d.DepartmentID
    GROUP BY d.DepartmentName
    ORDER BY TotalSalary DESC;
END
GO

-- C4. Workers by designation who joined within last 10 years
CREATE PROCEDURE sp_GetByDesigRecent
    @DesigName VARCHAR(100)
AS
BEGIN
    SELECT p.FirstName, p.JoiningDate, d.DepartmentName
    FROM Person p
    INNER JOIN Designation des ON p.DesignationID = des.DesignationID
    LEFT JOIN Department d ON p.DepartmentID = d.DepartmentID
    WHERE des.DesignationName = @DesigName
      AND p.JoiningDate >= DATEADD(YEAR, -10, GETDATE());
END
GO

-- C5. Count of workers with no designation per dept
CREATE PROCEDURE sp_NoDesigCount_ByDept
AS
BEGIN
    SELECT d.DepartmentName, COUNT(*) AS WorkersWithoutDesig
    FROM Person p
    INNER JOIN Department d ON p.DepartmentID = d.DepartmentID
    WHERE p.DesignationID IS NULL
    GROUP BY d.DepartmentName;
END
GO

-- C6. Workers in depts where avg salary > 12000
CREATE PROCEDURE sp_HighAvgSalDept
AS
BEGIN
    SELECT p.*, d.DepartmentName
    FROM Person p
    INNER JOIN Department d ON p.DepartmentID = d.DepartmentID
    WHERE p.DepartmentID IN (
        SELECT DepartmentID FROM Person
        GROUP BY DepartmentID HAVING AVG(Salary) > 12000
    );
END
GO

