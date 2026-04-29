-- LAB 4: Aggregate Functions & GROUP BY (without HAVING)


CREATE TABLE EMP (
    EID         INT,
    EName       VARCHAR(50),
    Department  VARCHAR(50),
    Salary      INT,
    JoiningDate DATETIME,
    City        VARCHAR(50),
    Gender      VARCHAR(10)
);

INSERT INTO EMP VALUES
(101, 'Rahul',  'Admin', 56000, '1990-01-01', 'Rajkot',    'Male'),
(102, 'Hardik', 'IT',    18000, '1990-09-25', 'Ahmedabad', 'Male'),
(103, 'Bhavin', 'HR',    25000, '1991-05-14', 'Baroda',    'Male'),
(104, 'Bhoomi', 'Admin', 39000, '1991-02-08', 'Rajkot',    'Female'),
(105, 'Rohit',  'IT',    17000, '1990-07-23', 'Jamnagar',  'Male'),
(106, 'Priya',  'IT',    9000,  '1990-10-18', 'Ahmedabad', 'Female'),
(107, 'Bhoomi', 'HR',    34000, '1991-12-25', 'Rajkot',    'Female');


                                    
                                    --PART A--

-- A1. Highest and Lowest salary
SELECT MAX(Salary) AS Maximum, MIN(Salary) AS Minimum FROM EMP;

-- A2. Total and Average salary
SELECT SUM(Salary) AS Total_Sal, AVG(Salary) AS Average_Sal FROM EMP;

-- A3. Total number of employees
SELECT COUNT(*) AS TotalEmployees FROM EMP;

-- A4. Highest salary from Rajkot
SELECT MAX(Salary) FROM EMP WHERE City = 'Rajkot';

-- A5. Maximum salary from IT department
SELECT MAX(Salary) FROM EMP WHERE Department = 'IT';

-- A6. Count employees who joined after 8-Feb-91
SELECT COUNT(*) FROM EMP WHERE JoiningDate > '1991-02-08';

-- A7. Average salary of Admin department
SELECT AVG(Salary) FROM EMP WHERE Department = 'Admin';

-- A8. Total salary of HR department
SELECT SUM(Salary) FROM EMP WHERE Department = 'HR';

-- A9. Count of cities without duplication
SELECT COUNT(DISTINCT City) FROM EMP;

-- A10. Count unique departments
SELECT COUNT(DISTINCT Department) FROM EMP;

-- A11. Minimum salary of Ahmedabad employee
SELECT MIN(Salary) FROM EMP WHERE City = 'Ahmedabad';

-- A12. City wise highest salary
SELECT City, MAX(Salary) AS MaxSalary FROM EMP GROUP BY City;

-- A13. Department wise lowest salary
SELECT Department, MIN(Salary) AS MinSalary FROM EMP GROUP BY Department;

-- A14. City with total number of employees
SELECT City, COUNT(*) AS EmpCount FROM EMP GROUP BY City;

-- A15. Total salary of each department
SELECT Department, SUM(Salary) AS TotalSalary FROM EMP GROUP BY Department;

-- A16. Average salary of each department WITHOUT department name
SELECT AVG(Salary) AS AvgSalary FROM EMP GROUP BY Department;

-- A17. Count employees for each department in every city
SELECT Department, City, COUNT(*) AS EmpCount FROM EMP GROUP BY Department, City;

-- A18. Total salary of male and female employees
SELECT Gender, SUM(Salary) AS TotalSalary FROM EMP GROUP BY Gender;

-- A19. City wise max and min salary of female employees
SELECT City, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM EMP WHERE Gender = 'Female' GROUP BY City;

-- A20. Department, City, Gender wise average salary
SELECT Department, City, Gender, AVG(Salary) AS AvgSalary
FROM EMP GROUP BY Department, City, Gender;



--PART-B

-- B1. Count employees in Rajkot
SELECT COUNT(*) AS RajkotCount FROM EMP WHERE City = 'Rajkot';

-- B2. Difference between highest and lowest salary
SELECT MAX(Salary) - MIN(Salary) AS DIFFERENCE FROM EMP;

-- B3. Total employees hired before 1st Jan 1991
SELECT COUNT(*) AS HiredBefore1991 FROM EMP WHERE JoiningDate < '1991-01-01';


--PART-C

-- C1. Count employees in Rajkot or Baroda
SELECT COUNT(*) FROM EMP WHERE City IN ('Rajkot', 'Baroda');

-- C2. Total employees hired before 1st Jan 1991 in IT
SELECT COUNT(*) FROM EMP WHERE JoiningDate < '1991-01-01' AND Department = 'IT';

-- C3. JoiningDate wise total salaries
SELECT JoiningDate, SUM(Salary) AS TotalSalary FROM EMP GROUP BY JoiningDate;

-- C4. Max salary department & city wise where city starts with 'R'
SELECT Department, City, MAX(Salary) AS MaxSalary
FROM EMP WHERE City LIKE 'R%' GROUP BY Department, City;



