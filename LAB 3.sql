								--LAB 3 – LIKE OPERATOR--



-- Create STUDENT table as per given definition
CREATE TABLE STUDENT (
    StuID INT,
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    Website VARCHAR(50),
    City VARCHAR(25),
    Address VARCHAR(100)
);

-- Insert records into STUDENT table
INSERT INTO STUDENT VALUES
(1011, 'Keyur', 'Patel', 'techonthenet.com', 'Rajkot', 'A-303 Vasant Kunj, Rajkot'),
(1022, 'Hardik', 'Shah', 'digminecraft.com', 'Ahmedabad', 'Ram Krupa, Raiya Road'),
(1033, 'Kajal', 'Trivedi', 'bigactivities.com', 'Baroda', 'Raj bhavan plot, near garden'),
(1044, 'Bhoomi', 'Gajera', 'checkyourmath.com', 'Ahmedabad', 'Jigs Home, Narol'),
(1055, 'Harmit', 'Mitel', '@me.darshan.com', 'Rajkot', 'B-55 Raj Residency'),
(1066, 'Ashok', 'Jani', NULL, 'Baroda', 'A502 Club House Building');



-- 1. Name starts with 'k'
SELECT FirstName 
FROM STUDENT
WHERE FirstName LIKE 'K%';


-- 2. Name consists of exactly 5 characters
SELECT FirstName 
FROM STUDENT
WHERE FirstName LIKE '_____';


-- 3. First & Last name where city ends with 'a' and has 6 characters
SELECT FirstName, LastName 
FROM STUDENT
WHERE City LIKE '_____a';


-- 4. Last name ends with 'tel'
SELECT * 
FROM STUDENT
WHERE LastName LIKE '%tel';


-- 5. First name starts with 'ha' and ends with 't'
SELECT * 
FROM STUDENT
WHERE FirstName LIKE 'ha%t';


-- 6. First name starts with 'k' and third character is 'y'
SELECT * 
FROM STUDENT
WHERE FirstName LIKE 'k_y%';


-- 7. No website and name has 5 characters
SELECT FirstName 
FROM STUDENT
WHERE Website IS NULL
AND FirstName LIKE '_____';


-- 8. Last name contains 'jer'
SELECT * 
FROM STUDENT
WHERE LastName LIKE '%jer%';


-- 9. City starts with 'r' or 'b'
SELECT * 
FROM STUDENT
WHERE City LIKE 'r%' OR City LIKE 'b%';


-- 10. Students having websites
SELECT FirstName 
FROM STUDENT
WHERE Website IS NOT NULL;


-- 11. Name starts from alphabet A to H
SELECT * 
FROM STUDENT
WHERE FirstName LIKE '[A-H]%';


-- 12. Second character is vowel
SELECT * 
FROM STUDENT
WHERE FirstName LIKE '_[AEIOU]%';


-- 13. No website and name minimum 5 characters
SELECT FirstName 
FROM STUDENT
WHERE Website IS NULL
AND LEN(FirstName) >= 5;


-- 14. Last name starts with 'Pat'
SELECT * 
FROM STUDENT
WHERE LastName LIKE 'Pat%';


-- 15. City does not start with 'b'
SELECT * 
FROM STUDENT
WHERE City NOT LIKE 'b%';


-- 16. Student ID ends with digit (always true but pattern)
SELECT * 
FROM STUDENT
WHERE CAST(StuID AS VARCHAR) LIKE '%[0-9]';


-- 17. Address does not contain any digit
SELECT * 
FROM STUDENT
WHERE Address NOT LIKE '%[0-9]%';


-- 18. Complex condition
SELECT * 
FROM STUDENT
WHERE FirstName LIKE 'B%'
AND LastName LIKE '%A'
AND (Website LIKE '%math%' OR Website LIKE '%science%')
AND City NOT LIKE 'B%';


-- 19. Last name contains 'Sha', city ends with 'd', website null or contains 'com'
SELECT * 
FROM STUDENT
WHERE LastName LIKE '%Sha%'
AND City LIKE '%d'
AND (Website IS NULL OR Website LIKE '%com%');


-- 20. First & second character vowel, city starts with 'R', website contains 'com'
SELECT * 
FROM STUDENT
WHERE FirstName LIKE '[AEIOU][AEIOU]%'
AND City LIKE 'R%'
AND Website LIKE '%com%';



 --Pattern        Meaning              

 --`'A%'`         Starts with A        
 --`'%A'`         Ends with A          
 --`'%A%'`        Contains A           
 --`'_____'`      Exactly 5 characters 
 --`'_[AEIOU]%'`  2nd letter vowel     
 --`'[A-H]%'`     Range                
 --`'%[0-9]%'`    Contains digit       




                                        --PART - B--


-- 1. Second character is vowel and starts with 'H'
SELECT *
FROM STUDENT
WHERE FirstName LIKE 'H[AEIOU]%';


-- 2. Last name does not end with 'a'
SELECT *
FROM STUDENT
WHERE LastName NOT LIKE '%a';


-- 3. First name starts with consonant
SELECT *
FROM STUDENT
WHERE FirstName LIKE '[^AEIOU]%';


-- 4. Complex condition
SELECT *
FROM STUDENT
WHERE FirstName LIKE 'K%'
AND LastName LIKE '%tel'
AND (Website LIKE '%tech%' OR City LIKE 'R%');


-- 5. Address contains '-' and city starts with 'R' or 'B'
-- Website ends with '.com' and first name NOT start with 'A'
SELECT *
FROM STUDENT
WHERE Address LIKE '%-%'
AND (City LIKE 'R%' OR City LIKE 'B%')
AND Website LIKE '%.com'
AND FirstName NOT LIKE 'A%';



--PART-C--


-- 1. Address contains single quote or double quote
SELECT *
FROM STUDENT
WHERE Address LIKE '%''%' OR Address LIKE '%"%';


-- 2. Complex condition
-- City does not contain 'S'
-- Address has quotes
-- Last name starts with 'P'
-- Website contains 'on'
SELECT *
FROM STUDENT
WHERE City NOT LIKE '%S%'
AND (Address LIKE '%''%' OR Address LIKE '%"%')
AND LastName LIKE 'P%'
AND Website LIKE '%on%';



-- Pattern Meaning
-- [AEIOU]  → Any vowel
-- [^AEIOU] → NOT vowel (consonant)
-- '%''%'   → Contains single quote (')
-- '%"%'    → Contains double quote (")
-- '%.com'  → Ends with .com


