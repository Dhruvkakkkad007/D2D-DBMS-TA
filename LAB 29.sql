--LAB 29 – MS SQL Server – Revision Lab



-- CUSTOMER table
CREATE TABLE CUSTOMER (
  customer_id   INT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  email         VARCHAR(100) UNIQUE,
  phone         VARCHAR(20),
  location      VARCHAR(100)
);

-- PRODUCT table
CREATE TABLE PRODUCT (
  product_id  INT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  category    VARCHAR(50),
  price       DECIMAL(10,2) NOT NULL
);

-- SALES table
CREATE TABLE SALES (
  sale_id       INT PRIMARY KEY,
  customer_id   INT FOREIGN KEY REFERENCES CUSTOMER(customer_id),
  product_id    INT FOREIGN KEY REFERENCES PRODUCT(product_id),
  sale_date     DATE NOT NULL,
  quantity      INT NOT NULL,
  total_amount  DECIMAL(10,2) NOT NULL
);


-- Insert Customers
INSERT INTO CUSTOMER VALUES
(1, 'Kairavi',  'kairavi@gmail.com',  '9876543210', 'Rajkot'),
(2, 'Raj',      'raj@gmail.com',      '9123456789', 'Surat'),
(3, 'Meena',    'meena@yahoo.com',    '9988776655', 'Ahmedabad'),
(4, 'Amit',     'amit@hotmail.com',   '9090909090', 'Baroda'),
(5, 'Sneha',    'sneha@gmail.com',    '9001234567', 'Rajkot');

-- Insert Products
INSERT INTO PRODUCT VALUES
(101, 'iPhone 13',  'Electronics', 70000),
(102, 'TV',         'Electronics', 20000),
(103, 'T-Shirt',    'Fashion',     500),
(104, 'Laptop',     'Electronics', 65000),
(105, 'Book Set',   'Stationery',  1200);

-- Insert Sales
INSERT INTO SALES VALUES
(1, 1, 101, '2025-01-10', 1, 70000),
(2, 1, 102, '2025-01-15', 1, 20000),
(3, 2, 102, '2025-02-05', 2, 40000),
(4, 3, 103, '2025-02-10', 3, 1500),
(5, 4, 104, '2025-03-01', 1, 65000),
(6, 5, 105, '2025-03-15', 2, 2400),
(7, 2, 101, '2025-04-01', 1, 70000),
(8, 3, 104, '2025-04-10', 1, 65000);


-- Q: 1. Display customers who purchased TV worth price 20000
SELECT C.name, P.name AS product, S.total_amount
FROM SALES S
JOIN CUSTOMER C ON C.customer_id = S.customer_id
JOIN PRODUCT  P ON P.product_id  = S.product_id
WHERE P.name = 'TV' AND P.price = 20000;

-- Q: 2. Display highest selling item (by total revenue)
SELECT TOP 1 P.name AS product,
       SUM(S.total_amount) AS total_revenue
FROM SALES S
JOIN PRODUCT P ON P.product_id = S.product_id
GROUP BY P.name
ORDER BY total_revenue DESC;

-- Q: 3. Stored procedure to update customer's contact info
CREATE PROCEDURE sp_UpdateCustomerContact
  @customer_id INT,
  @new_email   VARCHAR(100),
  @new_phone   VARCHAR(20)
AS
BEGIN
  UPDATE CUSTOMER
  SET email = @new_email, phone = @new_phone
  WHERE customer_id = @customer_id;
  PRINT 'Customer contact updated successfully.';
END;

-- Execute: EXEC sp_UpdateCustomerContact 1, 'new@gmail.com', '9000000001';

-- Q: 4. Stored procedure to retrieve all sales by 'Kairavi'
CREATE PROCEDURE sp_SalesByCustomer
  @cname VARCHAR(100)
AS
BEGIN
  SELECT S.sale_id, S.sale_date, P.name AS product,
         S.quantity, S.total_amount
  FROM SALES S
  JOIN CUSTOMER C ON C.customer_id = S.customer_id
  JOIN PRODUCT  P ON P.product_id  = S.product_id
  WHERE C.name = @cname;
END;

-- Execute: EXEC sp_SalesByCustomer 'Kairavi';

-- Q: 5. UDF to calculate total revenue from television sales
CREATE FUNCTION fn_TvRevenue()
RETURNS DECIMAL(12,2)
AS
BEGIN
  DECLARE @rev DECIMAL(12,2);
  SELECT @rev = SUM(S.total_amount)
  FROM SALES S
  JOIN PRODUCT P ON P.product_id = S.product_id
  WHERE P.name = 'TV';
  RETURN @rev;
END;

-- Call: SELECT dbo.fn_TvRevenue() AS TV_Total_Revenue;

-- Q: 6. Trigger to prevent deleting customer who has purchases
CREATE TRIGGER trg_PreventDeleteCustomer
ON CUSTOMER
INSTEAD OF DELETE
AS
BEGIN
  IF EXISTS (SELECT 1 FROM SALES S
             JOIN DELETED D ON D.customer_id = S.customer_id)
  BEGIN
    RAISERROR('Cannot delete customer who has made purchases.', 16, 1);
    ROLLBACK;
  END
  ELSE
  BEGIN
    DELETE FROM CUSTOMER WHERE customer_id IN (SELECT customer_id FROM DELETED);
  END
END;

-- Q: 7. Cursor to fetch all sales with customer and product details
DECLARE @sale_id   INT,
        @cname     VARCHAR(100),
        @pname     VARCHAR(100),
        @qty       INT,
        @amount    DECIMAL(10,2),
        @sdate     DATE;

DECLARE sale_cursor CURSOR FOR
  SELECT S.sale_id, C.name, P.name, S.quantity, S.total_amount, S.sale_date
  FROM SALES S
  JOIN CUSTOMER C ON C.customer_id = S.customer_id
  JOIN PRODUCT  P ON P.product_id  = S.product_id;

OPEN sale_cursor;
FETCH NEXT FROM sale_cursor INTO @sale_id, @cname, @pname, @qty, @amount, @sdate;

WHILE @@FETCH_STATUS = 0
BEGIN
  PRINT 'Sale#' + CAST(@sale_id AS VARCHAR) + ' | ' + @cname + ' | ' + @pname +
        ' | Qty:' + CAST(@qty AS VARCHAR) + ' | Rs.' + CAST(@amount AS VARCHAR);
  FETCH NEXT FROM sale_cursor INTO @sale_id, @cname, @pname, @qty, @amount, @sdate;
END;

CLOSE sale_cursor;
DEALLOCATE sale_cursor;

-- Q: 8. Update product price with error handling (price cannot be negative)
CREATE PROCEDURE sp_UpdateProductPrice
  @product_id INT,
  @new_price  DECIMAL(10,2)
AS
BEGIN
  BEGIN TRY
    IF @new_price < 0
      THROW 50001, 'Price cannot be negative!', 1;

    UPDATE PRODUCT SET price = @new_price
    WHERE product_id = @product_id;
    PRINT 'Price updated successfully.';
  END TRY
  BEGIN CATCH
    PRINT 'ERROR: ' + ERROR_MESSAGE();
  END CATCH
END;

-- Test: EXEC sp_UpdateProductPrice 101, -5000;  -- Will show error
-- Test: EXEC sp_UpdateProductPrice 101, 72000;  -- Will update

Query 9 – Regex in MongoDB (review format for MongoDB)
📌 NOTE: MongoDB does not use SQL LIKE. Use regex patterns. These run in mongosh.
-- Q: 9.1 Customers whose names start with J
db.CUSTOMER.find({ name: /^J/ })

-- Q: 9.2 Products whose names have minimum 5 characters
db.PRODUCT.find({ name: /^.{5,}$/ })

-- Q: 9.3 Customer names start AND end with vowels
db.CUSTOMER.find({ name: /^[AEIOUaeiou].*[AEIOUaeiou]$/i })

-- Q: 9.4 Emails ending with @gmail.com
db.CUSTOMER.find({ email: /@gmail\.com$/ })

-- Q: 9.5 Product names containing exactly two words
db.PRODUCT.find({ name: /^\S+ \S+$/ })

Query 10 – Aggregation in MongoDB
-- Q: 10.1 Count products with price between 1000 and 5000
db.PRODUCT.aggregate([
  { $match: { price:{ $gte:1000, $lte:5000 } } },
  { $count: 'productCount' }
])

-- Q: 10.2 Category-wise cheapest product
db.PRODUCT.aggregate([
  { $sort: { price:1 } },
  { $group: { _id:'$category', cheapestProduct:{ $first:'$name' }, minPrice:{ $first:'$price' } } }
])

-- Q: 10.3 Display customers having same name
db.CUSTOMER.aggregate([
  { $group: { _id:'$name', count:{ $sum:1 } } },
  { $match: { count:{ $gt:1 } } }
])

-- Q: 10.4 Count products whose name starts with vowel
db.PRODUCT.aggregate([
  { $match: { name: /^[AEIOUaeiou]/ } },
  { $count: 'vowelProductCount' }
])

-- Q: 10.5 Category-wise count of products starting with vowel, sort by category desc
db.PRODUCT.aggregate([
  { $match: { name: /^[AEIOUaeiou]/ } },
  { $group: { _id:'$category', count:{ $sum:1 } } },
  { $sort: { _id:-1 } }
])
