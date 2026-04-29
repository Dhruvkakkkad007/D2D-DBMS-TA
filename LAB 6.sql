-- LAB 6: Math, String, and Date Functions

-- MATH FUNCTIONS - PART A

-- A1. 5 * 30
SELECT 5 * 30 AS Result;

-- A2. Absolute values
SELECT ABS(-25) AS Abs1, ABS(25) AS Abs2, ABS(-50) AS Abs3, ABS(50) AS Abs4;

-- A3. Smallest integer >= value (CEILING)
SELECT CEILING(25.2), CEILING(25.7), CEILING(-25.2);

-- A4. Largest integer <= value (FLOOR)
SELECT FLOOR(25.2), FLOOR(25.7), FLOOR(-25.2);

-- A5. Remainder (MOD)
SELECT 5 % 2 AS Rem1, 5 % 3 AS Rem2;

-- A6. Power
SELECT POWER(3,2) AS Pow1, POWER(4,3) AS Pow2;

-- A7. Square Root
SELECT SQRT(25) AS SR1, SQRT(30) AS SR2, SQRT(50) AS SR3;

-- A8. Square (POWER with 2)
SELECT POWER(5,2) AS Sq1, POWER(15,2) AS Sq2, POWER(25,2) AS Sq3;

-- A9. Value of PI
SELECT PI() AS PIValue;

-- A10. Round values
SELECT ROUND(157.732, 2), ROUND(157.732, 0), ROUND(157.732, -2);

-- A11. Exponential values
SELECT EXP(2), EXP(3);

-- A12. Logarithm base e (LN)
SELECT LOG(10) AS LogE_10, LOG(2) AS LogE_2;

-- A13. Logarithm base 10
SELECT LOG10(5) AS Log10_5, LOG10(100) AS Log10_100;

-- A14. Sine, Cosine, Tangent
SELECT SIN(3.1415) AS SineVal, COS(3.1415) AS CosVal, TAN(3.1415) AS TanVal;

-- A15. Sign of numbers
SELECT SIGN(-25) AS Sign1, SIGN(0) AS Sign2, SIGN(25) AS Sign3;

-- A16. Random number
SELECT RAND() AS RandomNum;




-- Math Part B, String, Date


CREATE TABLE EMP_MASTER (
    EmpNo       INT,
    EmpName     VARCHAR(50),
    JoiningDate DATETIME,
    Salary      DECIMAL(8,2),
    Commission  DECIMAL(8,2),
    City        VARCHAR(50),
    DeptCode    VARCHAR(20)
);



INSERT INTO EMP_MASTER VALUES
(101, 'Keyur',  '2002-01-05', 12000.00, 4500, 'Rajkot',    '3@g'),
(102, 'Hardik', '2004-02-15', 14000.00, 2500, 'Ahmedabad', '3@'),
(103, 'Kajal',  '2006-03-14', 15000.00, 3000, 'Baroda',    '3-GD'),
(104, 'Bhoomi', '2005-06-23', 12500.00, 1000, 'Ahmedabad', '1A3D'),
(105, 'Harmit', '2004-02-15', 14000.00, 2000, 'Rajkot',    '312A');



-- B1. Salary + Commission
SELECT EmpName, Salary + Commission AS TotalEarning FROM EMP_MASTER;

-- B2. Ceiling values
SELECT CEILING(55.2), CEILING(35.7), CEILING(-55.2);

-- B3. Floor values
SELECT FLOOR(55.2), FLOOR(35.7), FLOOR(-55.2);

-- B4. Remainder of 55 / 2 and 55 / 3
SELECT 55 % 2 AS Rem1, 55 % 3 AS Rem2;

-- B5. Power
SELECT POWER(23,2) AS Pow1, POWER(14,3) AS Pow2;

-- MATH PART C

-- C1. Employees with total earnings > 15000
SELECT * FROM EMP_MASTER WHERE (Salary + Commission) > 15000;

-- C2. Employees where commission > 25% of salary
SELECT * FROM EMP_MASTER WHERE Commission > (Salary * 0.25);

-- C3. Joined before 2005 and total earnings > 15000
SELECT * FROM EMP_MASTER
WHERE JoiningDate < '2005-01-01' AND (Salary + Commission) > 15000;

-- C4. Total earnings >= double their salary (Commission >= Salary)
SELECT * FROM EMP_MASTER WHERE (Salary + Commission) >= 2 * Salary;







-- STRING FUNCTIONS - PART A


-- S1. Length of NULL, ' hello ', Blank
SELECT LEN(NULL) AS Len1, LEN(' hello ') AS Len2, LEN('') AS Len3;
-- Note: LEN trims trailing spaces; use DATALENGTH for exact bytes

-- S2. Lower and Upper case
SELECT LOWER('Darshan') AS LowerName, UPPER('Darshan') AS UpperName;

-- S3. First 3 characters of a name
SELECT LEFT('Darshan', 3) AS FirstThree;

-- S4. 3rd to 10th character
SELECT SUBSTRING('Darshan University', 3, 8) AS SubStr;
-- SUBSTRING(string, start_position, length)

-- S5. Replace
SELECT REPLACE('abc123efg', '123', 'XYZ') AS Replaced1;
SELECT REPLACE('abcabcabc', 'bc', '5b') AS Replaced2;

-- S6. ASCII codes
SELECT ASCII('a') AS A1, ASCII('A') AS A2, ASCII('z') AS A3,
       ASCII('Z') AS A4, ASCII('0') AS A5, ASCII('9') AS A6;

-- S7. Characters from ASCII codes
SELECT CHAR(97) AS C1, CHAR(65) AS C2, CHAR(122) AS C3,
       CHAR(90) AS C4, CHAR(48) AS C5, CHAR(57) AS C6;

-- S8. Remove left spaces (LTRIM)
SELECT LTRIM('   hello world ') AS LeftTrimmed;

-- S9. Remove right spaces (RTRIM)
SELECT RTRIM(' hello world   ') AS RightTrimmed;

-- S10. First 4 and last 5 characters of 'SQL Server'
SELECT LEFT('SQL Server', 4) AS First4, RIGHT('SQL Server', 5) AS Last5;

-- S11. Convert string '1234.56' to number
SELECT CAST('1234.56' AS DECIMAL(10,2)) AS CastResult;
SELECT CONVERT(DECIMAL(10,2), '1234.56') AS ConvertResult;

-- S12. Convert float 10.58 to integer
SELECT CAST(10.58 AS INT) AS CastInt;
SELECT CONVERT(INT, 10.58) AS ConvertInt;

-- S13. 10 spaces before name
SELECT SPACE(10) + 'Darshan' AS NameWithSpaces;

-- S14. Combine strings using + and CONCAT
SELECT 'Hello' + ' ' + 'World' AS Combined;
SELECT CONCAT('Hello', ' ', 'World') AS ConcatResult;

-- S15. Reverse of "Darshan"
SELECT REVERSE('Darshan') AS Reversed;

-- S16. Repeat name 3 times (REPLICATE in SQL Server)
SELECT REPLICATE('Darshan', 3) AS Repeated;




-- STRING PART B (on EMP_MASTER)

-- B1. Length of EmpName and City
SELECT LEN(EmpName) AS NameLen, LEN(City) AS CityLen FROM EMP_MASTER;

-- B2. Lower and Upper case of EmpName and City
SELECT LOWER(EmpName) AS LowerName, UPPER(EmpName) AS UpperName,
       LOWER(City) AS LowerCity, UPPER(City) AS UpperCity FROM EMP_MASTER;

-- B3. First 3 characters of EmpName
SELECT LEFT(EmpName, 3) AS First3 FROM EMP_MASTER;

-- B4. 3rd to 10th character of City
SELECT SUBSTRING(City, 3, 8) AS SubCity FROM EMP_MASTER;

-- B5. First 4 and last 5 characters of EmpName
SELECT LEFT(EmpName, 4) AS First4, RIGHT(EmpName, 5) AS Last5 FROM EMP_MASTER;

-- STRING PART C (on EMP_MASTER)

-- C1. 10 spaces before EmpName
SELECT SPACE(10) + EmpName AS NameWithSpaces FROM EMP_MASTER;

-- C2. Combine EmpName and City using + and CONCAT
SELECT EmpName + ' ' + City AS Combined FROM EMP_MASTER;
SELECT CONCAT(EmpName, ' ', City) AS ConcatResult FROM EMP_MASTER;

-- C3. Combine all columns
SELECT CONCAT(CAST(EmpNo AS VARCHAR), ', ', EmpName, ', ',
              CAST(JoiningDate AS VARCHAR), ', ',
              CAST(Salary AS VARCHAR), ', ', City, ', ', DeptCode) AS AllCols
FROM EMP_MASTER;

-- C4. Format: <EmpName> Lives in <City>
SELECT EmpName + ' Lives in ' + City AS Output FROM EMP_MASTER;

-- C5. Format: EMP no of <EmpName> is <EmpNo>
SELECT 'EMP no of ' + EmpName + ' is ' + CAST(EmpNo AS VARCHAR) AS Output
FROM EMP_MASTER;

-- C6. Employees where 3rd character of name is vowel
SELECT EmpName FROM EMP_MASTER WHERE SUBSTRING(EmpName, 3, 1) LIKE '[aeiouAEIOU]';

-- C7. Concatenate name and city where name ends 'r' and city starts 'R'
SELECT CONCAT(EmpName, ' ', City) AS Result
FROM EMP_MASTER WHERE EmpName LIKE '%r' AND City LIKE 'R%';








-- DATE FUNCTIONS - PART A


-- D1. Current date and time
SELECT GETDATE() AS Today_Date;

-- D2. New date after 365 days
SELECT DATEADD(DAY, 365, GETDATE()) AS After365Days;

-- D3. Format: May 5 1994 12:00AM style
SELECT CONVERT(VARCHAR, GETDATE(), 100) AS DateFormat100;

-- D4. Format: 03 Jan 1995
SELECT CONVERT(VARCHAR, GETDATE(), 106) AS DateFormat106;

-- D5. Format: Jan 04, 96
SELECT CONVERT(VARCHAR, GETDATE(), 7) AS DateFormat7;

-- D6. Total months between 31-Dec-08 and 31-Mar-09
SELECT DATEDIFF(MONTH, '2008-12-31', '2009-03-31') AS TotalMonths;

-- D7. Total hours between two datetime values
SELECT DATEDIFF(HOUR, '2012-01-25 07:00', '2012-01-26 10:30') AS TotalHours;

-- D8. Extract Day, Month, Year from 12-May-16
SELECT DAY('2016-05-12') AS DayVal, MONTH('2016-05-12') AS MonthVal, YEAR('2016-05-12') AS YearVal;

-- D9. Add 5 years to current date
SELECT DATEADD(YEAR, 5, GETDATE()) AS After5Years;

-- D10. Subtract 2 months from current date
SELECT DATEADD(MONTH, -2, GETDATE()) AS Before2Months;

-- D11. Extract month using DATENAME and DATEPART
SELECT DATENAME(MONTH, GETDATE()) AS MonthName;
SELECT DATEPART(MONTH, GETDATE()) AS MonthNum;

-- D12. Last date of current month
SELECT EOMONTH(GETDATE()) AS LastDateOfMonth;

-- D13. Age in years and months
DECLARE @DOB DATE = '2000-01-15';
SELECT
    DATEDIFF(YEAR, @DOB, GETDATE()) AS AgeYears,
    DATEDIFF(MONTH, @DOB, GETDATE()) % 12 AS AgeMonths;







-- DATE PART B (on EMP_MASTER)

-- B1. New date after 365 days from JoiningDate
SELECT EmpName, DATEADD(DAY, 365, JoiningDate) AS After365Days FROM EMP_MASTER;

-- B2. Total months between JoiningDate and 31-Mar-09
SELECT EmpName, DATEDIFF(MONTH, JoiningDate, '2009-03-31') AS TotalMonths FROM EMP_MASTER;

-- B3. Total years between JoiningDate and 14-Sep-10
SELECT EmpName, DATEDIFF(YEAR, JoiningDate, '2010-09-14') AS TotalYears FROM EMP_MASTER;






-- DATE PART C (on EMP_MASTER)

-- C1. Extract Day, Month, Year from JoiningDate
SELECT EmpName,
       DAY(JoiningDate) AS DayVal,
       MONTH(JoiningDate) AS MonthVal,
       YEAR(JoiningDate) AS YearVal
FROM EMP_MASTER;

-- C2. Add 5 years to JoiningDate
SELECT EmpName, DATEADD(YEAR, 5, JoiningDate) AS After5Years FROM EMP_MASTER;

-- C3. Subtract 2 months from JoiningDate
SELECT EmpName, DATEADD(MONTH, -2, JoiningDate) AS Before2Months FROM EMP_MASTER;

-- C4. Extract month using datename and datepart
SELECT EmpName, DATENAME(MONTH, JoiningDate) AS MonthName,
       DATEPART(MONTH, JoiningDate) AS MonthNum FROM EMP_MASTER;

-- C5. Employees who joined between 1st and 15th of any month
SELECT * FROM EMP_MASTER WHERE DAY(JoiningDate) BETWEEN 1 AND 15;

-- C6. Employees whose JoiningDate is last day of month
SELECT * FROM EMP_MASTER WHERE JoiningDate = EOMONTH(JoiningDate);

-- C7. Employees who joined in a leap year
SELECT * FROM EMP_MASTER
WHERE (YEAR(JoiningDate) % 4 = 0 AND YEAR(JoiningDate) % 100 != 0)
   OR (YEAR(JoiningDate) % 400 = 0);







