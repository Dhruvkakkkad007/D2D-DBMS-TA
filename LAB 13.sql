-- LAB 13: User Defined Functions (UDF)
-- PART A

-- A1. Print Hello World
GO
CREATE FUNCTION fn_HelloWorld()
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN 'Hello World';
END
GO
-- Usage:
-- SELECT dbo.fn_HelloWorld();

-- A2. Addition of two numbers
GO
CREATE FUNCTION fn_Add(@a INT, @b INT)
RETURNS INT
AS
BEGIN
    RETURN @a + @b;
END
GO
-- Usage: SELECT dbo.fn_Add(10, 20);

-- A3. Check ODD or EVEN
GO
CREATE FUNCTION fn_OddEven(@n INT)
RETURNS VARCHAR(10)
AS
BEGIN
    IF @n % 2 = 0
        RETURN 'EVEN';
    RETURN 'ODD';
END
GO
-- Usage: SELECT dbo.fn_OddEven(5);

-- A4. Table valued: persons whose first name starts with 'B'
-- (Uses Person table from Lab 11)
GO
CREATE FUNCTION fn_PersonStartsWithB()
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Person WHERE FirstName LIKE 'B%'
);
GO
-- Usage: SELECT * FROM dbo.fn_PersonStartsWithB();

-- A5. Table valued: unique first names from Person
GO
CREATE FUNCTION fn_UniqueFirstNames()
RETURNS TABLE
AS
RETURN (
    SELECT DISTINCT FirstName FROM Person
);
GO

-- A6. Print numbers 1 to N (scalar using WHILE loop - returns result as string)
GO
CREATE FUNCTION fn_PrintNumbers(@n INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @result VARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    WHILE @i <= @n
    BEGIN
        SET @result = @result + CAST(@i AS VARCHAR) + ' ';
        SET @i = @i + 1;
    END
    RETURN LTRIM(RTRIM(@result));
END
GO
-- Usage: SELECT dbo.fn_PrintNumbers(10);

-- A7. Factorial
GO
CREATE FUNCTION fn_Factorial(@n INT)
RETURNS BIGINT
AS
BEGIN
    DECLARE @result BIGINT = 1;
    DECLARE @i INT = 1;
    WHILE @i <= @n
    BEGIN
        SET @result = @result * @i;
        SET @i = @i + 1;
    END
    RETURN @result;
END
GO
-- Usage: SELECT dbo.fn_Factorial(5);

-- PART B

-- B1. Compare two integers using CASE
GO
CREATE FUNCTION fn_CompareIntegers(@a INT, @b INT)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN CASE
        WHEN @a > @b THEN 'First is Greater'
        WHEN @a < @b THEN 'Second is Greater'
        ELSE 'Both are Equal'
    END;
END
GO

-- B2. Sum of even numbers 1 to 20
GO
CREATE FUNCTION fn_SumOfEvens()
RETURNS INT
AS
BEGIN
    DECLARE @sum INT = 0, @i INT = 2;
    WHILE @i <= 20
    BEGIN
        SET @sum = @sum + @i;
        SET @i = @i + 2;
    END
    RETURN @sum;
END
GO
-- Usage: SELECT dbo.fn_SumOfEvens();  -- Returns 110

-- B3. Check Palindrome
GO
CREATE FUNCTION fn_IsPalindrome(@str VARCHAR(100))
RETURNS VARCHAR(20)
AS
BEGIN
    IF @str = REVERSE(@str)
        RETURN 'Palindrome';
    RETURN 'Not Palindrome';
END
GO
-- Usage: SELECT dbo.fn_IsPalindrome('madam');

-- PART C

-- C1. Check Prime
GO
CREATE FUNCTION fn_IsPrime(@n INT)
RETURNS VARCHAR(20)
AS
BEGIN
    IF @n <= 1 RETURN 'Not Prime';
    DECLARE @i INT = 2;
    WHILE @i <= SQRT(@n)
    BEGIN
        IF @n % @i = 0 RETURN 'Not Prime';
        SET @i = @i + 1;
    END
    RETURN 'Prime';
END
GO
-- Usage: SELECT dbo.fn_IsPrime(7);

-- C2. Difference in days between two dates
GO
CREATE FUNCTION fn_DaysDiff(@startDate DATE, @endDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @startDate, @endDate);
END
GO
-- Usage: SELECT dbo.fn_DaysDiff('2024-01-01', '2024-12-31');

-- C3. Total days in a given month and year
GO
CREATE FUNCTION fn_DaysInMonth(@year INT, @month INT)
RETURNS INT
AS
BEGIN
    RETURN DAY(EOMONTH(DATEFROMPARTS(@year, @month, 1)));
END
GO
-- Usage: SELECT dbo.fn_DaysInMonth(2024, 2);  -- Returns 29 (leap year)

-- C4. Table valued: persons by department ID
GO
CREATE FUNCTION fn_PersonByDept(@DeptID INT)
RETURNS TABLE
AS
RETURN (
    SELECT p.*, d.DepartmentName
    FROM Person p
    LEFT JOIN Department d ON p.DepartmentID = d.DepartmentID
    WHERE p.DepartmentID = @DeptID
);
GO
-- Usage: SELECT * FROM dbo.fn_PersonByDept(2);

-- C5. Table valued: persons who joined after 1-1-1991
GO
CREATE FUNCTION fn_PersonJoinedAfter1991()
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Person WHERE JoiningDate > '1991-01-01'
);
GO
-- Usage: SELECT * FROM dbo.fn_PersonJoinedAfter1991();

