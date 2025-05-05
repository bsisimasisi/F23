-- 1. Assign row number to each sale based on SaleDate
SELECT SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID,
       ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNumber
FROM ProductSales;

-- 2. Rank products based on total quantity sold (same rank for same amounts, no skipping)
SELECT ProductName,
       SUM(Quantity) AS TotalQuantity,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS QuantityRank
FROM ProductSales
GROUP BY ProductName;

-- 3. Identify the top sale for each customer based on SaleAmount
WITH RankedSales AS (
    SELECT SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS SaleRank
    FROM ProductSales
)
SELECT SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID
FROM RankedSales
WHERE SaleRank = 1;

-- 4. Display each sale's amount along with the next sale amount
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

-- 5. Display each sale's amount along with the previous sale amount
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales;

-- 6. Identify sales amounts greater than the previous sale's amount
SELECT SaleID, ProductName, SaleDate, SaleAmount
FROM (
    SELECT SaleID, ProductName, SaleDate, SaleAmount,
           LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
) sub
WHERE SaleAmount > PreviousSaleAmount;

-- 7. Calculate the difference in sale amount from the previous sale for every product
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS SaleAmountDifference
FROM ProductSales;

-- 8. Compare current sale amount with next sale amount in terms of percentage change
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       ROUND(
           ((LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) / SaleAmount * 100),
           2
       ) AS PercentageChange
FROM ProductSales;

-- 9. Calculate the ratio of current sale amount to previous sale amount within the same product
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       ROUND(
           SaleAmount / NULLIF(LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate), 0),
           2
       ) AS SaleAmountRatio
FROM ProductSales;

-- 10. Calculate the difference in sale amount from the very first sale of that product
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DifferenceFromFirst
FROM ProductSales;

-- 11. Find sales with continuously increasing amounts for a product
WITH SalesWithPrevious AS (
    SELECT SaleID, ProductName, SaleDate, SaleAmount,
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount,
           ROW_NUMBER() OVER (PARTITION BY ProductName ORDER BY SaleDate) AS RowNum
    FROM ProductSales
)
SELECT SaleID, ProductName, SaleDate, SaleAmount
FROM SalesWithPrevious
WHERE SaleAmount > PreviousSaleAmount OR PreviousSaleAmount IS NULL;

-- 12. Calculate running total (closing balance) for sales amounts
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS ClosingBalance
FROM ProductSales;

-- 13. Calculate moving average of sales amounts over the last 3 sales
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       AVG(SaleAmount) OVER (
           ORDER BY SaleDate
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAverage
FROM ProductSales;

-- 14. Show difference between each sale amount and the average sale amount
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - (SELECT AVG(SaleAmount) FROM ProductSales) AS DifferenceFromAverage
FROM ProductSales;

-- 15. Find employees who have the same salary rank
WITH SalaryRank AS (
    SELECT EmployeeID, Name, Department, Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
)
SELECT s1.EmployeeID, s1.Name, s1.Department, s1.Salary
FROM SalaryRank s1
JOIN SalaryRank s2 ON s1.SalaryRank = s2.SalaryRank AND s1.EmployeeID != s2.EmployeeID;

-- 16. Identify the top 2 highest salaries in each department
WITH RankedSalaries AS (
    SELECT EmployeeID, Name, Department, Salary,
           ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
)
SELECT EmployeeID, Name, Department, Salary
FROM RankedSalaries
WHERE SalaryRank <= 2;

-- 17. Find the lowest-paid employee in each department
SELECT EmployeeID, Name, Department, Salary
FROM Employees1 e1
WHERE Salary = (
    SELECT MIN(Salary)
    FROM Employees1 e2
    WHERE e2.Department = e1.Department
);

-- 18. Calculate the running total of salaries in each department
SELECT EmployeeID, Name, Department, Salary,
       SUM(Salary) OVER (
           PARTITION BY Department
           ORDER BY EmployeeID
           ROWS UNBOUNDED PRECEDING
       ) AS RunningTotal
FROM Employees1;

-- 19. Find the total salary of each department without GROUP BY
SELECT DISTINCT Department,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalSalary
FROM Employees1;

-- 20. Calculate the average salary in each department without GROUP BY
SELECT DISTINCT Department,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgSalary
FROM Employees1;

-- 21. Find the difference between an employee’s salary and their department’s average
SELECT EmployeeID, Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS SalaryDifference
FROM Employees1;

-- 22. Calculate the moving average salary over 3 employees (current, previous, and next)
SELECT EmployeeID, Name, Department, Salary,
       AVG(Salary) OVER (
           ORDER BY EmployeeID
           ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
       ) AS MovingAverageSalary
FROM Employees1;

-- 23. Find the sum of salaries for the last 3 hired employees
WITH RankedHires AS (
    SELECT EmployeeID, Name, Department, Salary, HireDate,
           ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS HireRank
    FROM Employees1
)
SELECT SUM(Salary) AS TotalSalaryLastThree
FROM RankedHires
WHERE HireRank <= 3;
