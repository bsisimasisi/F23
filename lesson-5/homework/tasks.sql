SELECT ProductName AS Name FROM Products;

SELECT * FROM Customers AS Client;

SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discontinued;

SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discontinued;

SELECT * FROM Products
UNION ALL
SELECT * FROM Orders;

SELECT DISTINCT CustomerName, Country FROM Customers;

SELECT ProductName, Price, 
       CASE WHEN Price > 100 THEN 'High' ELSE 'Low' END AS PriceCategory
FROM Products;

SELECT Country, COUNT(*) AS EmployeeCount
FROM Employees
WHERE Department = 'Sales'
GROUP BY Country;

SELECT CategoryID, COUNT(ProductID) AS ProductCount
FROM Products
GROUP BY CategoryID;

SELECT ProductName, Stock, 
       IIF(Stock > 100, 'Yes', 'No') AS InStock
FROM Products;

SELECT o.OrderID, c.CustomerName AS ClientName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

SELECT ProductName FROM Products
UNION
SELECT ProductName FROM OutOfStock;

SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM DiscontinuedProducts;

SELECT CustomerID, 
       CASE WHEN COUNT(OrderID) > 5 THEN 'Eligible' ELSE 'Not Eligible' END AS Status
FROM Orders
GROUP BY CustomerID;

SELECT ProductName, Price, 
       IIF(Price > 100, 'Expensive', 'Affordable') AS PriceCategory
FROM Products;

SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY CustomerID;

SELECT * FROM Employees
WHERE Age < 25 OR Salary > 6000;

SELECT Region, SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY Region;

SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate AS Order_Date
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

UPDATE Employees
SET Salary = Salary * 1.10
WHERE Department = 'HR';
