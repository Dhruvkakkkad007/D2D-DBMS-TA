-- LAB 8: Complex Joins 

CREATE TABLE DEPT (
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    DepartmentCode VARCHAR(50)  NOT NULL UNIQUE,
    Location       VARCHAR(50)  NOT NULL
);

INSERT INTO DEPT VALUES
(1, 'Admin',      'Adm', 'A-Block'),
(2, 'Computer',   'CE',  'C-Block'),
(3, 'Civil',      'CI',  'G-Block'),
(4, 'Electrical', 'EE',  'E-Block'),
(5, 'Mechanical', 'ME',  'B-Block');


CREATE TABLE PERSON (
    PersonID     INT PRIMARY KEY,
    PersonName   VARCHAR(100) NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES DEPT(DepartmentID),
    Salary       DECIMAL(8,2) NOT NULL,
    JoiningDate  DATETIME     NOT NULL,
    City         VARCHAR(100) NOT NULL
);

INSERT INTO PERSON VALUES
(101, 'Rahul Tripathi',  2,    56000, '2000-01-01', 'Rajkot'),
(102, 'Hardik Pandya',   3,    18000, '2001-09-25', 'Ahmedabad'),
(103, 'Bhavin Kanani',   4,    25000, '2000-05-14', 'Baroda'),
(104, 'Bhoomi Vaishnav', 1,    39000, '2005-02-08', 'Rajkot'),
(105, 'Rohit Topiya',    2,    17000, '2001-07-23', 'Jamnagar'),
(106, 'Priya Menpara',   NULL, 9000,  '2000-10-18', 'Ahmedabad'),
(107, 'Neha Sharma',     2,    34000, '2002-12-25', 'Rajkot'),
(108, 'Nayan Goswami',   3,    25000, '2001-07-01', 'Rajkot'),
(109, 'Mehul Bhundiya',  4,    13500, '2005-01-09', 'Baroda'),
(110, 'Mohit Maru',      5,    14000, '2000-05-25', 'Jamnagar');





-- LAB 8 - PART A

-- A1. Cross join
SELECT * FROM PERSON CROSS JOIN DEPT;

-- A2. All persons with department name
SELECT p.PersonName, d.DepartmentName
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID;

-- A3. With department name and code
SELECT p.PersonName, d.DepartmentName, d.DepartmentCode
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID;

-- A4. With department code and location
SELECT p.PersonName, d.DepartmentCode, d.Location
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID;

-- A5. Person in Mechanical department
SELECT p.*
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mechanical';

-- A6. Person name, dept code, salary from Ahmedabad
SELECT p.PersonName, d.DepartmentCode, p.Salary
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
WHERE p.City = 'Ahmedabad';

-- A7. Person whose department is in C-Block
SELECT p.PersonName
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
WHERE d.Location = 'C-Block';

-- A8. Person name, salary, dept name from Jamnagar
SELECT p.PersonName, p.Salary, d.DepartmentName
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
WHERE p.City = 'Jamnagar';

-- A9. Person who joined Civil after 1-Aug-2001
SELECT p.*
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Civil' AND p.JoiningDate > '2001-08-01';

-- A10. Persons whose joining diff > 365 days from today
SELECT p.PersonName, d.DepartmentName
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
WHERE DATEDIFF(DAY, p.JoiningDate, GETDATE()) > 365;

-- A11. Department wise person counts
SELECT d.DepartmentName, COUNT(p.PersonID) AS PersonCount
FROM DEPT d LEFT JOIN PERSON p ON d.DepartmentID = p.DepartmentID
GROUP BY d.DepartmentName;

-- A12. Department wise max and min salary with dept name
SELECT d.DepartmentName, MAX(p.Salary) AS MaxSal, MIN(p.Salary) AS MinSal
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

-- A13. City wise total, average, max, min salary
SELECT City, SUM(Salary) AS Total, AVG(Salary) AS Avg,
       MAX(Salary) AS MaxSal, MIN(Salary) AS MinSal
FROM PERSON GROUP BY City;

-- A14. Average salary of person from Ahmedabad
SELECT AVG(Salary) AS AvgSalary FROM PERSON WHERE City = 'Ahmedabad';

-- A15. Output: <PersonName> lives in <City> and works in <DepartmentName> Department
SELECT p.PersonName + ' lives in ' + p.City + ' and works in ' +
       d.DepartmentName + ' Department' AS Output
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID;




-- LAB 8 - PART B

-- B1. <PersonName> earns <Salary> from <DepartmentName> department monthly
SELECT p.PersonName + ' earns ' + CAST(p.Salary AS VARCHAR) +
       ' from ' + d.DepartmentName + ' department monthly' AS Output
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID;

-- B2. City and department wise total, avg, max salaries
SELECT p.City, d.DepartmentName,
       SUM(p.Salary) AS Total, AVG(p.Salary) AS Avg, MAX(p.Salary) AS MaxSal
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
GROUP BY p.City, d.DepartmentName;

-- B3. Persons who don't belong to any department
SELECT * FROM PERSON WHERE DepartmentID IS NULL;

-- B4. Departments whose total salary exceeds 100000
SELECT d.DepartmentName, SUM(p.Salary) AS TotalSalary
FROM PERSON p INNER JOIN DEPT d ON p.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName HAVING SUM(p.Salary) > 100000;




-- LAB 8 - PART C


-- C1. Departments with no person
SELECT d.DepartmentName FROM DEPT d
LEFT JOIN PERSON p ON d.DepartmentID = p.DepartmentID
WHERE p.PersonID IS NULL;

-- C2. Departments with more than 2 persons
SELECT d.DepartmentName, COUNT(p.PersonID) AS PersonCount
FROM DEPT d INNER JOIN PERSON p ON d.DepartmentID = p.DepartmentID
GROUP BY d.DepartmentName HAVING COUNT(p.PersonID) > 2;

-- C3. 10% increment for Computer department employees
UPDATE PERSON
SET Salary = Salary * 1.10
WHERE DepartmentID = (SELECT DepartmentID FROM DEPT WHERE DepartmentName = 'Computer');
