USE Northwind;
-- 3.List all products and their total order quantities throughout all orders.
select dt.ProductName, sum(dt.quantity) as "TotalOrderQuantity"
from (
    select p.ProductID,p.ProductName, d.quantity  
    from Products p 
    inner join [Order Details] d 
    on p.ProductID = d.ProductID
) dt
group by dt.ProductID,dt.ProductName;

-- 4.List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) [Total products]
FROM Customers c
LEFT JOIN Orders o 
ON o.CustomerID = c.CustomerID
LEFT JOIN [Order Details] od
ON od.OrderID = o.OrderID
GROUP BY c.City
ORDER BY c.City ASC;

-- 5.List all Customer Cities that have at least two customers.
-- a.Use union
SELECT c1.City
FROM Customers c1
GROUP BY c1.City
HAVING COUNT(c1.CustomerID) > 2
UNION
SELECT c1.City
FROM Customers c1
GROUP BY c1.City
HAVING COUNT(c1.CustomerID) = 2;
-- b.Use sub-query and no union
SELECT DISTINCT c1.City
FROM Customers c1
WHERE c1.City IN (
    SELECT c2.City
    FROM Customers c2
    GROUP BY c2.City
    HAVING COUNT(c2.City) >= 2
);

-- 8.List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 od.ProductID, o.ShipCity [customer city], AVG(od.UnitPrice) [average price]
FROM Orders o 
INNER JOIN [Order Details] od 
ON od.OrderID = o.OrderID
GROUP BY o.ShipCity, od.ProductID
ORDER BY SUM(od.Quantity) DESC;
-- 9.List all cities that have never ordered something but we have employees there.
--a.Use sub-query
SELECT e.City
FROM Employees e
WHERE e.City NOT IN (
    SELECT c.City
    FROM Customers c 
    INNER JOIN Orders o  
    ON o.CustomerID = c.CustomerID
);
--b.Do not use sub-query
SELECT e.City
FROM Employees e
LEFT JOIN Customers c  
ON c.City = e.City
WHERE c.City IS NULL;

-- 10.List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
-- and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT *
FROM (
    SELECT TOP 1 e.City, COUNT(o.OrderId) [count Order]
    FROM Employees e 
    INNER JOIN Orders o 
    ON o.EmployeeID = e.EmployeeID
    GROUP BY e.City
) DB1
INNER JOIN (
    SELECT TOP 1 c.City, COUNT(od.Quantity) [count Quantity]
    FROM Customers c
    INNER JOIN Orders o 
    ON o.CustomerID = c.CustomerID
    INNER JOIN [Order Details] od 
    ON od.OrderID = o.OrderID
    GROUP BY c.City
) DB2
ON DB1.City = DB2.City;

-- 11.How do you remove the duplicates record of a table?
-- Answer: We can use GROUP BY clause first. Then use DELETE 
-- clause to remove the duplicates rows (which COUNT() is at least 2).