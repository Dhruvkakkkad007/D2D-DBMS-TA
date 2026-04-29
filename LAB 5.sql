-- LAB 5: GROUP BY with HAVING and ORDER BY

CREATE TABLE SALES_DATA (
    Region       VARCHAR(50),
    Product      VARCHAR(50),
    Sales_Amount INT,
    Year         INT
);


INSERT INTO SALES_DATA VALUES
('North America', 'Watch',  1500, 2023),
('Europe',        'Mobile', 1200, 2023),
('Asia',          'Watch',  1800, 2023),
('North America', 'TV',     900,  2024),
('Europe',        'Watch',  2000, 2024),
('Asia',          'Mobile', 1000, 2024),
('North America', 'Mobile', 1600, 2023),
('Europe',        'TV',     1500, 2023),
('Asia',          'TV',     1100, 2024),
('North America', 'Watch',  1700, 2024);


--PART-A--

-- A1. Total Sales by Region
SELECT Region, SUM(Sales_Amount) AS TotalSales FROM SALES_DATA GROUP BY Region;

-- A2. Average Sales by Product
SELECT Product, AVG(Sales_Amount) AS AvgSales FROM SALES_DATA GROUP BY Product;

-- A3. Maximum Sales by Year
SELECT Year, MAX(Sales_Amount) AS MaxSales FROM SALES_DATA GROUP BY Year;

-- A4. Minimum Sales by Region and Year
SELECT Region, Year, MIN(Sales_Amount) AS MinSales FROM SALES_DATA GROUP BY Region, Year;

-- A5. Count of Products Sold by Region
SELECT Region, COUNT(Product) AS ProductCount FROM SALES_DATA GROUP BY Region;

-- A6. Sales by Year and Product
SELECT Year, Product, SUM(Sales_Amount) AS TotalSales FROM SALES_DATA GROUP BY Year, Product;

-- A7. Regions with Total Sales > 5000
SELECT Region, SUM(Sales_Amount) AS TotalSales
FROM SALES_DATA GROUP BY Region HAVING SUM(Sales_Amount) > 5000;

-- A8. Products with Average Sales < 10000
SELECT Product, AVG(Sales_Amount) AS AvgSales
FROM SALES_DATA GROUP BY Product HAVING AVG(Sales_Amount) < 10000;

-- A9. Years with Maximum Sales > 500
SELECT Year, MAX(Sales_Amount) AS MaxSales
FROM SALES_DATA GROUP BY Year HAVING MAX(Sales_Amount) > 500;

-- A10. Regions with at least 3 distinct products
SELECT Region FROM SALES_DATA
GROUP BY Region HAVING COUNT(DISTINCT Product) >= 3;

-- A11. Years with Minimum Sales < 1000
SELECT Year, MIN(Sales_Amount) AS MinSales
FROM SALES_DATA GROUP BY Year HAVING MIN(Sales_Amount) < 1000;

-- A12. Total Sales by Region for Year 2023, sorted by Total
SELECT Region, SUM(Sales_Amount) AS TotalSales
FROM SALES_DATA WHERE Year = 2023
GROUP BY Region ORDER BY TotalSales;

-- A13. Region where 'Mobile' had lowest total sales
SELECT TOP 1 Region, SUM(Sales_Amount) AS TotalSales
FROM SALES_DATA WHERE Product = 'Mobile'
GROUP BY Region ORDER BY TotalSales ASC;

-- A14. Product with highest sales across all regions in 2023
SELECT TOP 1 Product, SUM(Sales_Amount) AS TotalSales
FROM SALES_DATA WHERE Year = 2023
GROUP BY Product ORDER BY TotalSales DESC;

-- A15. Regions where TV sales in 2023 > 1000
SELECT Region FROM SALES_DATA
WHERE Product = 'TV' AND Year = 2023
GROUP BY Region HAVING SUM(Sales_Amount) > 1000;



--PART-B

-- B1. Count of Orders by Year and Region, sorted by Year and Region
SELECT Year, Region, COUNT(*) AS OrderCount
FROM SALES_DATA GROUP BY Year, Region ORDER BY Year, Region;

-- B2. Regions with Max Sales > 1000 in any year, sorted by Region
SELECT Region FROM SALES_DATA
GROUP BY Region HAVING MAX(Sales_Amount) > 1000 ORDER BY Region;

-- B3. Years with Total Sales < 10000, sorted by Year DESC
SELECT Year, SUM(Sales_Amount) AS TotalSales
FROM SALES_DATA GROUP BY Year
HAVING SUM(Sales_Amount) < 10000 ORDER BY Year DESC;

-- B4. Top 3 Regions by Total Sales in 2024
SELECT TOP 3 Region, SUM(Sales_Amount) AS TotalSales
FROM SALES_DATA WHERE Year = 2024
GROUP BY Region ORDER BY TotalSales DESC;

-- B5. Year with lowest total sales across all regions
SELECT TOP 1 Year, SUM(Sales_Amount) AS TotalSales
FROM SALES_DATA GROUP BY Year ORDER BY TotalSales ASC;


--PART-C


-- C1. Products with Avg Sales between 1000 and 2000, ordered by Product Name
SELECT Product, AVG(Sales_Amount) AS AvgSales
FROM SALES_DATA GROUP BY Product
HAVING AVG(Sales_Amount) BETWEEN 1000 AND 2000
ORDER BY Product;

-- C2. Years with more than 1 order from each region
SELECT Year, Region, COUNT(*) AS OrderCount
FROM SALES_DATA GROUP BY Year, Region HAVING COUNT(*) > 1;

-- C3. Regions with Avg Sales > 1500 in Year 2023, descending by amount
SELECT Region, AVG(Sales_Amount) AS AvgSales
FROM SALES_DATA WHERE Year = 2023
GROUP BY Region HAVING AVG(Sales_Amount) > 1500
ORDER BY AvgSales DESC;

-- C4. Region wise duplicate product
SELECT Region, Product, COUNT(*) AS Count
FROM SALES_DATA GROUP BY Region, Product HAVING COUNT(*) > 1;

-- C5. Year wise duplicate product
SELECT Year, Product, COUNT(*) AS Count
FROM SALES_DATA GROUP BY Year, Product HAVING COUNT(*) > 1;



