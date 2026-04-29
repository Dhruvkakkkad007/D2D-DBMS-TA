-- LAB 7: SQL JOINS


CREATE TABLE STU_INFO (
    Rno    INT PRIMARY KEY,
    Name   VARCHAR(50),
    Branch VARCHAR(10)
);


INSERT INTO STU_INFO VALUES
(101, 'Raju',   'CE'),
(102, 'Amit',   'CE'),
(103, 'Sanjay', 'ME'),
(104, 'Neha',   'EC'),
(105, 'Meera',  'EE'),
(106, 'Mahesh', 'ME');


CREATE TABLE RESULT (
    Rno INT,   -- FK referencing STU_INFO
    SPI DECIMAL(4,2)
);


INSERT INTO RESULT VALUES
(101, 8.8),
(102, 9.2),
(103, 7.6),
(104, 8.2),
(105, 7.0),
(107, 8.9);   -- Rno 107 has no match in STU_INFO


CREATE TABLE EMPLOYEE_MASTER (
    EmployeeNo VARCHAR(10),
    Name       VARCHAR(50),
    ManagerNo  VARCHAR(10)
);


INSERT INTO EMPLOYEE_MASTER VALUES
('E01', 'Tarun',  NULL),
('E02', 'Rohan',  'E02'),
('E03', 'Priya',  'E01'),
('E04', 'Milan',  'E03'),
('E05', 'Jay',    'E01'),
('E06', 'Anjana', 'E04');


--PART-A--

-- J1. CROSS JOIN (Cartesian Product)
SELECT * FROM STU_INFO CROSS JOIN RESULT;

-- J2. INNER JOIN
SELECT s.Rno, s.Name, s.Branch, r.SPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno;

-- J3. LEFT OUTER JOIN (all students, even those without result)
SELECT s.Rno, s.Name, s.Branch, r.SPI
FROM STU_INFO s LEFT JOIN RESULT r ON s.Rno = r.Rno;

-- J4. RIGHT OUTER JOIN (all results, even unmatched ones)
SELECT s.Rno, s.Name, s.Branch, r.SPI
FROM STU_INFO s RIGHT JOIN RESULT r ON s.Rno = r.Rno;

-- J5. FULL OUTER JOIN
SELECT s.Rno, s.Name, s.Branch, r.SPI
FROM STU_INFO s FULL OUTER JOIN RESULT r ON s.Rno = r.Rno;

-- J6. Rno, Name, Branch and SPI of all students
SELECT s.Rno, s.Name, s.Branch, r.SPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno;

-- J7. CE branch students only
SELECT s.Rno, s.Name, s.Branch, r.SPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno
WHERE s.Branch = 'CE';

-- J8. Other than EC branch
SELECT s.Rno, s.Name, s.Branch, r.SPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno
WHERE s.Branch != 'EC';

-- J9. Average result of each branch
SELECT s.Branch, AVG(r.SPI) AS AvgSPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno
GROUP BY s.Branch;

-- J10. Average result of CE and ME branch
SELECT s.Branch, AVG(r.SPI) AS AvgSPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno
WHERE s.Branch IN ('CE', 'ME')
GROUP BY s.Branch;

-- J11. Max and Min SPI of each branch
SELECT s.Branch, MAX(r.SPI) AS MaxSPI, MIN(r.SPI) AS MinSPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno
GROUP BY s.Branch;

-- J12. Branch wise student count in descending order
SELECT s.Branch, COUNT(*) AS StudentCount
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno
GROUP BY s.Branch ORDER BY StudentCount DESC;



-- LAB 7 - PART B

-- B1. Average result of each branch sorted ascending by SPI
SELECT s.Branch, AVG(r.SPI) AS AvgSPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno
GROUP BY s.Branch ORDER BY AvgSPI ASC;

-- B2. Highest SPI from each branch, sorted descending
SELECT s.Branch, MAX(r.SPI) AS MaxSPI
FROM STU_INFO s INNER JOIN RESULT r ON s.Rno = r.Rno
GROUP BY s.Branch ORDER BY MaxSPI DESC;



-- LAB 7 - PART C

-- C1. Employee name with their manager's name (SELF JOIN)
SELECT e.Name AS EmployeeName, m.Name AS ManagerName
FROM EMPLOYEE_MASTER e
LEFT JOIN EMPLOYEE_MASTER m ON e.ManagerNo = m.EmployeeNo;

