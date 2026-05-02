-- LAB 17: Exception Handling


CREATE TABLE Customers (
    Customer_id   INT PRIMARY KEY,
    Customer_Name VARCHAR(250) NOT NULL,
    Email         VARCHAR(50) UNIQUE
);

CREATE TABLE Orders (
    Order_id    INT PRIMARY KEY,
    Customer_id INT FOREIGN KEY REFERENCES Customers(Customer_id),
    Order_date  DATE NOT NULL
);

-- PART A

-- A1. Handle Divide by Zero
GO
BEGIN TRY
    SELECT 10 / 0 AS Result;
END TRY
BEGIN CATCH
    PRINT 'Error occurs that is - ' + ERROR_MESSAGE();
END CATCH

-- A2. Convert string to integer (will fail)
GO
BEGIN TRY
    DECLARE @val INT = CAST('Hello' AS INT);
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH

-- A3. Procedure to add two numbers with exception handling
GO
CREATE PROCEDURE sp_AddNumbers
    @a VARCHAR(20),
    @b VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        DECLARE @num1 INT = CAST(@a AS INT);
        DECLARE @num2 INT = CAST(@b AS INT);
        PRINT 'Sum = ' + CAST(@num1 + @num2 AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: '  + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Severity: '      + CAST(ERROR_SEVERITY() AS VARCHAR);
        PRINT 'State: '         + CAST(ERROR_STATE() AS VARCHAR);
    END CATCH
END
GO
-- Usage: EXEC sp_AddNumbers '10', '20';  -- Works
-- Usage: EXEC sp_AddNumbers '10', 'abc'; -- Error

-- A4. Handle Primary Key Violation
GO
BEGIN TRY
    INSERT INTO Customers VALUES (1, 'Raj', 'raj@gmail.com');
    INSERT INTO Customers VALUES (1, 'Raj2', 'raj2@gmail.com'); -- PK violation
END TRY
BEGIN CATCH
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Number: '  + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Severity: '      + CAST(ERROR_SEVERITY() AS VARCHAR);
    PRINT 'State: '         + CAST(ERROR_STATE() AS VARCHAR);
END CATCH

-- A5. Custom exception: check if Customer_id exists
GO
CREATE PROCEDURE sp_CheckCustomer
    @Customer_id INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
    BEGIN
        THROW 50001, 'No Customer_id is available in database', 1;
    END
    ELSE
    BEGIN
        SELECT * FROM Customers WHERE Customer_id = @Customer_id;
    END
END
GO

-- Usage: EXEC sp_CheckCustomer 999;

-- PART B

-- B1. Foreign Key Violation
GO
BEGIN TRY
    INSERT INTO Orders VALUES (1, 9999, '2024-01-01'); -- customer 9999 doesn't exist
END TRY
BEGIN CATCH
    PRINT 'Foreign Key Error: ' + ERROR_MESSAGE();
END CATCH

-- B2. Custom exception for invalid data
GO
CREATE PROCEDURE sp_ValidateData
    @Salary INT
AS
BEGIN
    BEGIN TRY
        IF @Salary < 0
            THROW 50002, 'Invalid Data: Salary cannot be negative', 1;
        PRINT 'Salary is valid: ' + CAST(@Salary AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- B3. Update email with error handling
GO
CREATE PROCEDURE sp_UpdateEmail
    @Customer_id INT,
    @NewEmail    VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        UPDATE Customers SET Email = @NewEmail WHERE Customer_id = @Customer_id;
        PRINT 'Email updated successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error updating email: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- PART C

-- C1. Customer_id already taken
GO
CREATE PROCEDURE sp_InsertCustomer_Safe
    @Customer_id   INT,
    @Customer_Name VARCHAR(250),
    @Email         VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
        BEGIN
            THROW 50003, 'The Customer_id is already taken. Try another one', 1;
        END
        INSERT INTO Customers VALUES (@Customer_id, @Customer_Name, @Email);
        PRINT 'Customer inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- C2. Handle duplicate email
GO
BEGIN TRY
    INSERT INTO Customers VALUES (2, 'Meena', 'raj@gmail.com'); -- duplicate email
END TRY
BEGIN CATCH
    PRINT 'Duplicate Email Error: ' + ERROR_MESSAGE();
END CATCH



