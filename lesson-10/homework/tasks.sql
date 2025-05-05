SELECT e.Name AS EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 50000;

SELECT c.FirstName, c.LastName, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2023;

SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

SELECT s.SupplierName, p.ProductName
FROM Suppliers s
LEFT JOIN Products p ON s.SupplierID = p.SupplierID;

SELECT o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID;

SELECT e.Name AS EmployeeName, m.Name AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;

SELECT s.Name AS StudentName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Math 101';

SELECT c.FirstName, c.LastName, o.Quantity
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Quantity > 3;

SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Human Resources';

SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(e.EmployeeID) > 5;

SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SaleID IS NULL;

SELECT c.FirstName, c.LastName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

SELECT e1.Name AS Employee1, e2.Name AS Employee2, e1.ManagerID
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID < e2.EmployeeID;

SELECT o.OrderID, o.OrderDate, c.FirstName, c.LastName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2022;

SELECT e.Name AS EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' AND e.Salary > 60000;

SELECT o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
FROM Orders o
INNER JOIN Payments p ON o.OrderID = p.OrderID;

SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;

SELECT e.Name AS EmployeeName, e.Salary
FROM Employees e
INNER JOIN (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
) dept_avg ON e.DepartmentID = dept_avg.DepartmentID
WHERE e.Salary > dept_avg.AvgSalary;

SELECT o.OrderID, o.OrderDate
FROM Orders o
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE YEAR(o.OrderDate) < 2020 AND p.PaymentID IS NULL;

SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Categories c ON p.Category = c.CategoryID
WHERE c.CategoryID IS NULL;

SELECT e1.Name AS Employee1, e2.Name AS Employee2, e1.ManagerID, e1.Salary
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID < e2.EmployeeID AND e1.Salary > 60000 AND e2.Salary > 60000;

SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName LIKE 'M%';

SELECT s.SaleID, p.ProductName, s.SaleAmount
FROM Sales s
INNER JOIN Products p ON s.ProductID = p.ProductID
WHERE s.SaleAmount > 500;

SELECT s.StudentID, s.Name AS StudentName
FROM Students s
LEFT JOIN (
    SELECT e.StudentID
    FROM Enrollments e
    INNER JOIN Courses c ON e.CourseID = c.CourseID
    WHERE c.CourseName = 'Math 101'
) enrolled ON s.StudentID = enrolled.StudentID
WHERE enrolled.StudentID IS NULL;

SELECT o.OrderID, o.OrderDate, p.PaymentID
FROM Orders o
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL;

SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.Category = c.CategoryID
WHERE c.CategoryName IN ('Electronics', 'Furniture');
