--Q1: How many products can you find in the Production.Product table?
Answer:
USE AdventureWorks2019
GO
SELECT count(*)
FROM Production.Product
 --There are 504 products in the Production.Product.

--Q3: How many Products reside in each SubCategory? Write a query to display the results with the following titles.
Answer:
SELECT ProductSubcategoryID, COUNT(*) [CountedProduct]
FROM Production.Product
GROUP BY ProductSubcategoryID;

--Q4: How many products that do not have a product subcategory.
Answer:
SELECT count(*) [Number of Product]
FROM Production.Product
GROUP BY ProductSubcategoryID
having ProductSubcategoryID is NULL;
 --There are 409 products that do not have a product subcategory.

--Q5: Write a query to list the sum of products quantity in the Production.ProductInventory table
Answer:
SELECT ProductID ,SUM(Quantity) [sum of products quantity]
FROM Production.ProductInventory
GROUP BY ProductID;

--Q6: Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
Answer:
SELECT ProductID, SUM(Quantity) AS 'TheSum'
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100;

--Q10: Write query to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
Answer:
SELECT ProductID, shelf, AVG(Quantity) [TheAvg]
FROM Production.ProductInventory
WHERE shelf <> 'N/A'
GROUP BY shelf, ProductID;

--Q11: List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
Answer:
SELECT Color, Class, COUNT(ProductID) [TheCount], AVG(ListPrice) [AvgPrice]
FROM Production.Product
GROUP BY Color, Class
HAVING Color IS NOT NULL
AND Class IS NOT NULL;

--Q12: Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
Answer:
SELECT cr.Name [Country], sp.Name [Province]
FROM Person.CountryRegion cr
INNER JOIN Person.StateProvince sp ON sp.CountryRegionCode = cr.CountryRegionCode;

--Q13: Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
Answer:
SELECT cr.Name [Country], sp.Name [Province]
FROM Person.CountryRegion cr 
INNER JOIN Person.StateProvince sp ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name in ('Germany','Canada');

--Q15: List top 5 locations (Zip Code) where the products sold most.
Answer:
USE Northwind
GO
SELECT TOP 5 c.PostalCode
FROM Customers c 
INNER JOIN (
    SELECT o.CustomerID, od.ProductID, od.Quantity
    FROM Orders o 
    INNER JOIN [Order Details] od 
    ON o.OrderID = od.OrderID
) a
ON c.CustomerID = a.Customerid
WHERE PostalCode IS NOT NULL
GROUP BY c.PostalCode;

--Q17: List all city names and number of customers in that city
Answer:
SELECT City, COUNT(*) [number of customers]
FROM Customers
GROUP BY City;

--Q18: List city names which have more than 2 customers, and number of customers in that city
Answer:
SELECT City, COUNT(*) [number of customers]
FROM Customers
GROUP BY City
Having COUNT(*) > 2;

--Q19: List the names of customers who placed orders after 1/1/98 with order date.
Answer:
SELECT c.ContactName
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate < '1/1/98';

--Q20: List the names of all customers with most recent order dates
Answer:
SELECT c.ContactName, MAX(o.OrderDate) [most recent order date]
FROM Customers c 
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.ContactName;

--Q23: List all of the possible ways that suppliers can ship their products. Display the results as below
Answer:
SELECT su.CompanyName [Supplier Company], sh.CompanyName [Shipping Company Name]
FROM Suppliers su
CROSS JOIN shippers sh;

--Q26: Display all the Managers who have more than 2 employees reporting to them.
Answer:
SELECT e1.FirstName + ' ' + e1.LastName [Managers]
FROM Employees e1
INNER JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.FirstName, e1.LastName
Having Count(e1.EmployeeID) > 2;



