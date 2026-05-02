-- LAB 15: Triggers

GO
CREATE TABLE PersonInfo (
    PersonID   INT PRIMARY KEY,
    PersonName VARCHAR(100) NOT NULL,
    Salary     DECIMAL(8,2) NOT NULL,
    JoiningDate DATETIME,
    City       VARCHAR(100) NOT NULL,
    Age        INT,
    BirthDate  DATETIME NOT NULL
);

CREATE TABLE PersonLog (
    PLogID     INT IDENTITY(1,1) PRIMARY KEY,
    PersonID   INT NOT NULL,
    PersonName VARCHAR(250) NOT NULL,
    Operation  VARCHAR(50) NOT NULL,
    UpdateDate DATETIME NOT NULL
);

-- PART A

-- A1. Trigger that shows message on INSERT, UPDATE, DELETE
GO
CREATE TRIGGER trg_PersonInfo_Message
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    PRINT 'Record is Affected.';
END
GO

-- A2. Trigger to log all operations into PersonLog
GO
CREATE TRIGGER trg_PersonInfo_Log
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Log INSERT
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO PersonLog(PersonID, PersonName, Operation, UpdateDate)
        SELECT PersonID, PersonName, 'INSERT', GETDATE() FROM inserted;
    END

    -- Log DELETE
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO PersonLog(PersonID, PersonName, Operation, UpdateDate)
        SELECT PersonID, PersonName, 'DELETE', GETDATE() FROM deleted;
    END

    -- Log UPDATE
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO PersonLog(PersonID, PersonName, Operation, UpdateDate)
        SELECT PersonID, PersonName, 'UPDATE', GETDATE() FROM inserted;
    END
END
GO

-- A4. Trigger to convert name to UPPERCASE on INSERT
GO
CREATE TRIGGER trg_PersonInfo_UpperCase
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET PersonName = UPPER(PersonName)
    WHERE PersonID IN (SELECT PersonID FROM inserted);
END
GO

-- A5. Trigger to prevent duplicate PersonName
GO
CREATE TRIGGER trg_PreventDuplicateName
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM PersonInfo
        WHERE PersonName IN (SELECT PersonName FROM inserted)
    )
    BEGIN
        PRINT 'Error: Duplicate PersonName is not allowed.';
        ROLLBACK;
    END
    ELSE
    BEGIN
        INSERT INTO PersonInfo
        SELECT * FROM inserted;
    END
END
GO

-- A6. Trigger to prevent Age below 18
GO
CREATE TRIGGER trg_PreventAgeBelow18
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Age < 18)
    BEGIN
        PRINT 'Error: Age cannot be below 18.';
        ROLLBACK;
    END
    ELSE
    BEGIN
        INSERT INTO PersonInfo SELECT * FROM inserted;
    END
END
GO

-- PART B

-- B1. Calculate age on INSERT and update Age field
GO
CREATE TRIGGER trg_CalcAge
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET Age = DATEDIFF(YEAR, i.BirthDate, GETDATE())
    FROM PersonInfo p
    INNER JOIN inserted i ON p.PersonID = i.PersonID;
END
GO

-- B2. Trigger to limit salary decrease by 10%
GO
CREATE TRIGGER trg_LimitSalaryDecrease
ON PersonInfo
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN deleted d ON i.PersonID = d.PersonID
        WHERE i.Salary < d.Salary * 0.90
    )
    BEGIN
        PRINT 'Error: Salary cannot be decreased by more than 10%.';
        ROLLBACK;
    END
END
GO

-- PART C

-- C1. Set JoiningDate to current date if NULL on INSERT
GO
CREATE TRIGGER trg_DefaultJoiningDate
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET JoiningDate = GETDATE()
    WHERE PersonID IN (SELECT PersonID FROM inserted WHERE JoiningDate IS NULL);
END
GO

-- C2. DELETE trigger on PersonLog prints message
GO
CREATE TRIGGER trg_PersonLog_Delete
ON PersonLog
AFTER DELETE
AS
BEGIN
    PRINT 'Record deleted successfully from PersonLog';
END
GO
