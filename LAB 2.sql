											--PART-A--
-- 1. Update deposit amount of all customers from 3000 to 5000
UPDATE DEPOSIT
SET AMOUNT = 5000
WHERE AMOUNT = 3000;

-- 2. Change branch name of ANIL from VRCE to C.G. ROAD
UPDATE BORROW
SET BNAME = 'C.G. ROAD'
WHERE CNAME = 'ANIL' AND BNAME = 'VRCE';

-- 3. Update Account No of SANDIP to 111 & Amount to 5000
UPDATE DEPOSIT
SET ACTNO = 111, AMOUNT = 5000
WHERE CNAME = 'SANDIP';

-- 4. Update amount of KRANTI to 7000
UPDATE DEPOSIT
SET AMOUNT = 7000
WHERE CNAME = 'KRANTI';

-- 5. Update branch name from ANDHERI to ANDHERI WEST
UPDATE BRANCH
SET BNAME = 'ANDHERI WEST'
WHERE BNAME = 'ANDHERI';

-- 6. Update branch name of MEHUL to NEHRU PALACE
UPDATE DEPOSIT
SET BNAME = 'NEHRU PALACE'
WHERE CNAME = 'MEHUL';

-- 7. Update amount to 5000 where account no between 103 and 107
UPDATE DEPOSIT
SET AMOUNT = 5000
WHERE ACTNO BETWEEN 103 AND 107;

-- 8. Update ADATE of ANIL to 1-4-95
UPDATE DEPOSIT
SET ADATE = '1995-04-01'
WHERE CNAME = 'ANIL';

-- 9. Update amount of MINU to 10000
UPDATE DEPOSIT
SET AMOUNT = 10000
WHERE CNAME = 'MINU';

-- 10. Update PRAMOD amount and date
UPDATE DEPOSIT
SET AMOUNT = 5000, ADATE = '1996-04-01'
WHERE CNAME = 'PRAMOD';


										--PART-B--


-- 1. 10% Increment in Loan Amount
UPDATE BORROW
SET AMOUNT = AMOUNT + (AMOUNT * 0.10);

-- 2. 20% increase in deposit
UPDATE DEPOSIT
SET AMOUNT = AMOUNT + (AMOUNT * 0.20);

-- 3. Increase amount by 1000
UPDATE DEPOSIT
SET AMOUNT = AMOUNT + 1000;

-- 4. Update MEHUL loan (even LOANNO)
UPDATE BORROW
SET AMOUNT = 7000, BNAME = 'CENTRAL'
WHERE CNAME = 'MEHUL' AND LOANNO % 2 = 0;

-- 5. Update VRCE accounts
UPDATE DEPOSIT
SET ADATE = '2022-05-15', AMOUNT = 2500
WHERE BNAME = 'VRCE' AND ACTNO < 105;


										--PART-C--
-- 1. Update amount of loan no 321 to NULL
UPDATE BORROW
SET AMOUNT = NULL
WHERE LOANNO = 321;

-- 2. Update branch name of KRANTI to NULL
UPDATE BORROW
SET BNAME = NULL
WHERE CNAME = 'KRANTI';

-- 3. Display borrowers whose loan no is NULL
SELECT * FROM BORROW
WHERE LOANNO IS NULL;

-- 4. Display borrowers having branch
SELECT * FROM BORROW
WHERE BNAME IS NOT NULL;

-- 5. Update loan no 481 details
UPDATE BORROW
SET AMOUNT = 5000, BNAME = 'VRCE', CNAME = 'DARSHAN'
WHERE LOANNO = 481;

-- 6. Update date where amount < 2000
UPDATE DEPOSIT
SET ADATE = '2021-01-01'
WHERE AMOUNT < 2000;

-- 7. Update account 110
UPDATE DEPOSIT
SET ADATE = NULL, BNAME = 'ANDHERI'
WHERE ACTNO = 110;


---ALTER & RENAME--

--PART-A

-- 1. Add City and Pincode
ALTER TABLE DEPOSIT
ADD CITY VARCHAR(20), PINCODE INT;

-- 2. Add State
ALTER TABLE DEPOSIT
ADD STATE VARCHAR(20);

-- 3. Change size of CNAME
ALTER TABLE DEPOSIT
ALTER COLUMN CNAME VARCHAR(35);

-- 4. Change AMOUNT to INT
ALTER TABLE DEPOSIT
ALTER COLUMN AMOUNT INT;

-- 5. Delete City column
ALTER TABLE DEPOSIT
DROP COLUMN CITY;

-- 6. Rename ACTNO to ANO
EXEC sp_rename 'DEPOSIT.ACTNO', 'ANO', 'COLUMN';

-- 7. Rename table
EXEC sp_rename 'DEPOSIT', 'DEPOSIT_DETAIL';


--PART-B--
-- 1. Rename ADATE to AOPENDATE
EXEC sp_rename 'DEPOSIT_DETAIL.ADATE', 'AOPENDATE', 'COLUMN';

-- 2. Delete AOPENDATE
ALTER TABLE DEPOSIT_DETAIL
DROP COLUMN AOPENDATE;

-- 3. Rename CNAME to CustomerName
EXEC sp_rename 'DEPOSIT_DETAIL.CNAME', 'CustomerName', 'COLUMN';

-- 4. Add Country column
ALTER TABLE DEPOSIT_DETAIL
ADD COUNTRY VARCHAR(50);


--PART-B--

-- Create STUDENT_DETAIL table
CREATE TABLE STUDENT_DETAIL (
    Enrollment_No VARCHAR(20),
    Name VARCHAR(25),
    CPI DECIMAL(5,2),
    Birthdate DATETIME
);

INSERT INTO STUDENT_DETAIL VALUES
('E101', 'Rahul', 8.50, '2002-05-10'),
('E102', 'Priya', 7.80, '2001-08-15'),
('E103', 'Amit', 9.10, '2002-01-20'),
('E104', 'Neha', 6.90, '2003-03-12'),
('E105', 'Karan', 8.00, '2001-11-25');

-- 1. Add City (NOT NULL) and Backlog (NULL)
ALTER TABLE STUDENT_DETAIL
ADD City VARCHAR(20) NOT NULL DEFAULT 'UNKNOWN',
    Backlog INT NULL;

-- 2. Add Department (NOT NULL)
ALTER TABLE STUDENT_DETAIL
ADD Department VARCHAR(20) NOT NULL DEFAULT 'GENERAL';

-- 3. Change size of Name column from VARCHAR(25) to VARCHAR(35)
ALTER TABLE STUDENT_DETAIL
ALTER COLUMN Name VARCHAR(35);

-- 4. Change CPI datatype from DECIMAL to INT
ALTER TABLE STUDENT_DETAIL
ALTER COLUMN CPI INT;

-- 5. Delete City column
ALTER TABLE STUDENT_DETAIL
DROP COLUMN City;

-- 6. Rename Enrollment_No to ENO
EXEC sp_rename 'STUDENT_DETAIL.Enrollment_No', 'ENO', 'COLUMN';

-- 7. Rename table STUDENT_DETAIL to STUDENT_MASTER
EXEC sp_rename 'STUDENT_DETAIL', 'STUDENT_MASTER';




--DELETE / TRUNCATE / DROP


--PART-A--

-- 1. Delete amount <= 4000
DELETE FROM DEPOSIT_DETAIL
WHERE AMOUNT <= 4000;

-- 2. Delete CHANDI branch
DELETE FROM DEPOSIT_DETAIL
WHERE BNAME = 'CHANDI';

-- 3. Delete ANO between 102 and 105
DELETE FROM DEPOSIT_DETAIL
WHERE ANO > 102 AND ANO < 105;

-- 4. Delete AJNI or POWAI
DELETE FROM DEPOSIT_DETAIL
WHERE BNAME IN ('AJNI', 'POWAI');

-- 5. Delete NULL account
DELETE FROM DEPOSIT_DETAIL
WHERE ANO IS NULL;

-- 6. Delete all remaining records
DELETE FROM DEPOSIT_DETAIL;

-- 7. Truncate table
TRUNCATE TABLE DEPOSIT_DETAIL;

-- 8. Drop table
DROP TABLE DEPOSIT_DETAIL;



--PART-B--

-- Create EMPLOYEE_MASTER table
CREATE TABLE EMPLOYEE_MASTER (
    EmpNo INT,
    EmpName VARCHAR(25),
    JoiningDate DATETIME,
    Salary DECIMAL(8,2),
    City VARCHAR(20)
);


INSERT INTO EMPLOYEE_MASTER VALUES
(101, 'Keyur', '2002-01-05', 12000.00, 'Rajkot'),
(102, 'Hardik', '2004-02-15', 14000.00, 'Ahmedabad'),
(103, 'Kajal', '2006-03-14', 15000.00, 'Baroda'),
(104, 'Bhoomi', '2005-06-23', 12500.00, 'Ahmedabad'),
(105, 'Harmit', '2004-02-15', 14000.00, 'Rajkot'),
(106, 'Mitesh', '2001-09-25', 5000.00, 'Jamnagar'),
(107, 'Meera', NULL, 7000.00, 'Morbi'),
(108, 'Kishan', '2003-02-06', 10000.00, NULL);


-- 1. Delete salary >= 14000
DELETE FROM EMPLOYEE_MASTER
WHERE Salary >= 14000;

-- 2. Delete employees from RAJKOT
DELETE FROM EMPLOYEE_MASTER
WHERE City = 'Rajkot';

-- 3. Delete employees joined after 1-1-2007
DELETE FROM EMPLOYEE_MASTER
WHERE JoiningDate > '2007-01-01';

-- 4. Delete where JoiningDate is NULL and Name not NULL
DELETE FROM EMPLOYEE_MASTER
WHERE JoiningDate IS NULL AND EmpName IS NOT NULL;

-- 5. Delete employees whose salary is 50% of 20000 (i.e., 10000)
DELETE FROM EMPLOYEE_MASTER
WHERE Salary = 10000;

-- 6. Delete employees whose City is NOT NULL (not empty)
DELETE FROM EMPLOYEE_MASTER
WHERE City IS NOT NULL;

-- 7. Delete all records using TRUNCATE
TRUNCATE TABLE EMPLOYEE_MASTER;

-- 8. Remove table using DROP
DROP TABLE EMPLOYEE_MASTER;




 --Command   Use    
 
 --DELETE    Deletes specific rows (can use WHERE) 

 --TRUNCATE  Deletes all rows (no WHERE, faster)   

 --DROP      Deletes entire table                  
