-- Use Northwind database. All questions are based on assumptions described by the Database Diagram sent to you yesterday. 
-- When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.

-- 1. Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW View_product_order_GUO
AS 
SELECT p.ProductName, COUNT(od.Quantity) [total ordered quantity]
FROM Products p
INNER JOIN [Order Details] od
ON od.ProductID = p.ProductID
GROUP BY p.ProductName;

-- 2. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id 
-- as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_GUO(
    @product_ID INT,
    @total_quantity FLOAT OUTPUT
)
AS
BEGIN
    SELECT @product_ID = p.ProductID
    FROM Products p 
    JOIN [Order Details] od 
    ON od.ProductID = p.ProductID
    GROUP BY p.ProductID
    HAVING SUM(od.Quantity) = @total_quantity
END;
-- 3. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name 
-- as an input and top 5 cities that ordered most that product combined with the total quantity of 
-- that product ordered from that city as output.
CREATE PROC sp_product_order_city_quantity_GUO
(
    @product_name VARCHAR(30),
    @order_city VARCHAR(30) OUTPUT
)
AS
BEGIN
    SELECT @product_name = DB2.Productname
    FROM (
        SELECT TOP 5 DB1.ProductID, DB1.ProductName
        FROM (
            SELECT p.ProductID, p.ProductName, SUM(od.quantity) oq1
            FROM Products p 
            INNER JOIN [Order Details] od 
            ON od.ProductID = p.ProductID
            GROUP BY p.ProductID, p.ProductName
        ) [DB1]
        ORDER BY DB1.oq1 DESC 
    ) [DB2]
    LEFT JOIN (
        SELECT *
        FROM (
            SELECT DB3.productid, DB3.city, rank() OVER(partition by productid ORDER BY oq2 DESC) [rk]
            FROM (
                SELECT p.ProductID, c.city, SUM(od.quantity) oq2
                FROM Customers c 
                INNER JOIN Orders o
                ON o.CustomerID = c.CustomerID
                LEFT JOIN [Order Details] od 
                ON od.OrderID = o.OrderID
                LEFT JOIN Products p 
                ON p.ProductID = od.ProductID
                GROUP BY p.ProductID, c.City
            ) [DB3]
        ) [DB4] 
        WHERE DB4.rk = 1
    ) DB5
    ON DB2.productid = DB5.productid
    WHERE DB5.city = @order_city
END;
-- 4. Create 2 new tables “people_your_last_name” “city_your_last_name”. 
-- City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
-- People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
-- Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. 
-- Create a view “Packers_your_name” lists all people from Green Bay. 
-- If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE city_GUO (
    Id INT,
    City VARCHAR(30)
);
INSERT INTO city_GUO (Id, City)
VALUES 
    (1, 'Seattle'), 
    (2, 'Green Bay');

CREATE TABLE people_GUO (
    id INT,
    Name VARCHAR(30),
    City INT
);
INSERT INTO people_GUO (id, Name, City)
VALUES 
    (1, 'aaron Rodgers', 2), 
    (2, 'Russell Wilson', 1), 
    (3, 'Jody Nelson', 2);

DELETE c 
FROM city_GUO c 
INNER JOIN people_GUO p 
ON p.City = c.Id
WHERE c.City = 'Seattle';

UPDATE c
SET c.City = 'Madison'
FROM people_GUO p 
INNER JOIN city_GUO c 
ON c.Id = p.City
WHERE p.City = 1;

CREATE VIEW Packers_ZIRUI_GUO 
AS
SELECT *
FROM (
    SELECT c.City, p.id, p.Name
    FROM city_GUO c 
    RIGHT JOIN people_GUO p 
    ON c.Id = p.City
) DB1
WHERE DB1.City = 'Green Bay';

BEGIN TRAN;

ROLLBACK;

DROP TABLE people_GUO;
DROP TABLE city_GUO;
DROP VIEW Packers_ZIRUI_GUO;
-- 5. Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” 
-- and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_GUO
AS
BEGIN
    SELECT EmployeeID, FirstName + ' ' + LastName [Name], Title, TitleOfCourtesy, BirthDate
    INTO birthday_employees_GUO
    FROM Employees 
    WHERE MONTH(BirthDate) = 2
END;

EXEC sp_birthday_employees_GUO;

Select * FROM birthday_employees_GUO;

DROP TABLE birthday_employees_GUO;

-- 6. How do you make sure two tables have the same data?
-- Answer: Suppose we need to determine Table1 and Table2 whether have the same data,
-- we can use UNION statement to check.
SELECT * FROM Table1
UNION
SELECT * FROM Table2;
-- If after the upon query, we get records which is larger than the max number of the Table1 and Table2,
-- it means Table1 and Table2 do not have the same data.
-- If the records which is equal to the records of Table1 and Table2,
-- it means Table1 and Table2 have the same data.