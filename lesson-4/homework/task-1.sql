
SELECT * FROM Employees
ORDER BY Salary DESC
LIMIT 5;

SELECT DISTINCT ProductName FROM Products;

SELECT * FROM Products
WHERE Price > 100;

SELECT CustomerName FROM Customers
WHERE CustomerName LIKE 'A%';

SELECT * FROM Products
ORDER BY Price ASC;

SELECT * FROM Employees
WHERE Salary >= 5000 AND Department = 'HR';

SELECT EmployeeID, Name, COALESCE(Email, 'noemail@example.com') AS Email
FROM Employees;

SELECT * FROM Products
WHERE Price BETWEEN 50 AND 100;

SELECT DISTINCT Category, ProductName FROM Products;

SELECT DISTINCT Category, ProductName FROM Products
ORDER BY ProductName DESC;
