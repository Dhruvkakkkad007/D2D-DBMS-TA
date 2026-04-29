-- LAB 10: Subqueries



CREATE TABLE STUDENT_DATA (
    Rno  INT,
    Name VARCHAR(50),
    City VARCHAR(50),
    DID  INT
);

CREATE TABLE DEPARTMENT (
    DID   INT,
    DName VARCHAR(50)
);

CREATE TABLE ACADEMIC (
    RNO   INT,
    SPI   DECIMAL(4,2),
    BKLOG INT
);

INSERT INTO STUDENT_DATA VALUES
(101, 'Raju',   'Rajkot',    10),
(102, 'Amit',   'Ahmedabad', 20),
(103, 'Sanjay', 'Baroda',    40),
(104, 'Neha',   'Rajkot',    20),
(105, 'Meera',  'Ahmedabad', 30),
(106, 'Mahesh', 'Baroda',    10);

INSERT INTO DEPARTMENT VALUES
(10, 'Computer'),
(20, 'Electrical'),
(30, 'Mechanical'),
(40, 'Civil');

INSERT INTO ACADEMIC VALUES
(101, 8.8, 0),
(102, 9.2, 2),
(103, 7.6, 1),
(104, 8.2, 4),
(105, 7.0, 2),
(106, 8.9, 3);

-- LAB 10 - PART A

-- A1. Students from Computer department
SELECT * FROM STUDENT_DATA
WHERE DID = (SELECT DID FROM DEPARTMENT WHERE DName = 'Computer');

-- A2. Students whose SPI > 8
SELECT Name FROM STUDENT_DATA s
WHERE s.Rno IN (SELECT Rno FROM ACADEMIC WHERE SPI > 8);

-- A3. Students from Computer dept who belong to Rajkot
SELECT * FROM STUDENT_DATA
WHERE City = 'Rajkot'
  AND DID = (SELECT DID FROM DEPARTMENT WHERE DName = 'Computer');

-- A4. Total students in Electrical department
SELECT COUNT(*) AS TotalStudents FROM STUDENT_DATA
WHERE DID = (SELECT DID FROM DEPARTMENT WHERE DName = 'Electrical');

-- A5. Student with maximum SPI
SELECT Name FROM STUDENT_DATA
WHERE Rno = (SELECT RNO FROM ACADEMIC WHERE SPI = (SELECT MAX(SPI) FROM ACADEMIC));

-- A6. Students with more than 1 backlog
SELECT * FROM STUDENT_DATA
WHERE Rno IN (SELECT RNO FROM ACADEMIC WHERE BKLOG > 1);

-- LAB 10 - PART B

-- B1. Students from Computer or Mechanical department
SELECT Name FROM STUDENT_DATA
WHERE DID IN (SELECT DID FROM DEPARTMENT WHERE DName IN ('Computer', 'Mechanical'));

-- B2. Students in same department as Rno 102
SELECT Name FROM STUDENT_DATA
WHERE DID = (SELECT DID FROM STUDENT_DATA WHERE Rno = 102) AND Rno != 102;

-- LAB 10 - PART C

-- C1. Students with SPI > 9 from Electrical dept
SELECT Name FROM STUDENT_DATA
WHERE Rno IN (SELECT RNO FROM ACADEMIC WHERE SPI > 9)
  AND DID = (SELECT DID FROM DEPARTMENT WHERE DName = 'Electrical');

-- C2. Student with second highest SPI
SELECT Name FROM STUDENT_DATA
WHERE Rno = (
    SELECT RNO FROM ACADEMIC
    WHERE SPI = (SELECT MAX(SPI) FROM ACADEMIC WHERE SPI < (SELECT MAX(SPI) FROM ACADEMIC))
);

-- C3. City names where student's SPI is 9.2
SELECT City FROM STUDENT_DATA
WHERE Rno IN (SELECT RNO FROM ACADEMIC WHERE SPI = 9.2);

-- C4. Students with more backlogs than average
SELECT Name FROM STUDENT_DATA
WHERE Rno IN (
    SELECT RNO FROM ACADEMIC WHERE BKLOG > (SELECT AVG(BKLOG) FROM ACADEMIC)
);

-- C5. Students in same department as student with highest SPI
SELECT Name FROM STUDENT_DATA
WHERE DID = (
    SELECT DID FROM STUDENT_DATA WHERE Rno = (
        SELECT RNO FROM ACADEMIC WHERE SPI = (SELECT MAX(SPI) FROM ACADEMIC)
    )
);
