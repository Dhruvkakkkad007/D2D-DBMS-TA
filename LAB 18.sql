-- LAB 18: Constraints


-- STU_MASTER table with constraints
GO
CREATE TABLE STU_MASTER (
    Rno    INT PRIMARY KEY,
    Name   VARCHAR(50),
    Branch VARCHAR(20) DEFAULT 'General',
    SPI    DECIMAL(4,2) CHECK (SPI <= 10),
    Bklog  INT          CHECK (Bklog >= 0)
);

INSERT INTO STU_MASTER VALUES (101, 'Raju',   'CE', 8.80, 0);
INSERT INTO STU_MASTER VALUES (102, 'Amit',   'CE', 2.20, 3);
INSERT INTO STU_MASTER VALUES (103, 'Sanjay', 'ME', 1.50, 6);
INSERT INTO STU_MASTER VALUES (104, 'Neha',   'EC', 7.65, 0);
INSERT INTO STU_MASTER VALUES (105, 'Meera',  'EE', 5.52, 2);
INSERT INTO STU_MASTER VALUES (106, 'Mahesh', DEFAULT, 4.50, 3); -- Branch defaults to 'General'

-- Test constraint violations

-- A4. Try to update SPI to 12 (violates CHECK SPI <= 10)
BEGIN TRY
    UPDATE STU_MASTER SET SPI = 12 WHERE Name = 'Raju';
END TRY
BEGIN CATCH
    PRINT 'Cannot set SPI > 10. Error: ' + ERROR_MESSAGE();
END CATCH

-- A5. Try to update Bklog to -1 (violates CHECK Bklog >= 0)
BEGIN TRY
    UPDATE STU_MASTER SET Bklog = -1 WHERE Name = 'Neha';
END TRY
BEGIN CATCH
    PRINT 'Cannot set Bklog < 0. Error: ' + ERROR_MESSAGE();
END CATCH
