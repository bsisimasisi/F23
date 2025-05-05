SELECT o.OrderID, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate > '2022-12-31';

SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing');

SELECT d.DepartmentName, MAX(e.Salary) AS MaxSalary
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND YEAR(o.OrderDate) = 2023;

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

SELECT p.ProductName, s.SupplierName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies', 'Clothing Mart');

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.TotalAmount AS OrderTotal
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount > 500;

SELECT p.ProductName, s.SaleDate, s.SaleAmount
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2022 OR s.SaleAmount > 400;

SELECT p.ProductName, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;

SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Human Resources' AND e.Salary > 60000;

SELECT p.ProductName, s.SaleDate, p.StockQuantity
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2023 AND p.StockQuantity > 100;

SELECT e.Name AS EmployeeName, d.DepartmentName, e.HireDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' OR e.HireDate > '2020-12-31';

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.OrderID, c.Address, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';

SELECT p.ProductName, c.CategoryName AS Category, s.SaleAmount
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
INNER JOIN Categories c ON p.Category = c.CategoryID
WHERE c.CategoryName = 'Electronics' OR s.SaleAmount > 350;

SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.Category
GROUP BY c.CategoryName;

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, c.City, o.OrderID, o.TotalAmount AS Amount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City = 'Los Angeles' AND o.TotalAmount > 300;

SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Human Resources', 'Finance')
   OR LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'a', '')) 
      + LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'e', '')) 
      + LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'i', '')) 
      + LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'o', '')) 
      + LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'u', '')) >= 4;

SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing') AND e.Salary > 60000;
