WITH NumbersCTE AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM NumbersCTE
    WHERE Number < 1000
)
SELECT Number FROM NumbersCTE;

SELECT e.EmployeeID, e.FirstName, e.LastName, d.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) d ON e.EmployeeID = d.EmployeeID;

WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT AvgSalary FROM AvgSalaryCTE;

SELECT p.ProductID, p.ProductName, d.MaxSales
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSales
    FROM Sales
    GROUP BY ProductID
) d ON p.ProductID = d.ProductID;

WITH DoublingCTE AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number * 2
    FROM DoublingCTE
    WHERE Number * 2 < 1000000
)
SELECT Number FROM DoublingCTE;

WITH SalesCountCTE AS (
    SELECT EmployeeID, COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(*) > 5
)
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
JOIN SalesCountCTE s ON e.EmployeeID = s.EmployeeID;

WITH HighSalesCTE AS (
    SELECT ProductID, SalesAmount
    FROM Sales
    WHERE SalesAmount > 500
)
SELECT p.ProductID, p.ProductName, h.SalesAmount
FROM Products p
JOIN HighSalesCTE h ON p.ProductID = h.ProductID;

WITH AboveAvgSalaryCTE AS (
    SELECT EmployeeID, FirstName, LastName, Salary
    FROM Employees
    WHERE Salary > (SELECT AVG(Salary) FROM Employees)
)
SELECT EmployeeID, FirstName, LastName, Salary
FROM AboveAvgSalaryCTE;

SELECT e.EmployeeID, e.FirstName, e.LastName, d.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) d ON e.EmployeeID = d.EmployeeID
ORDER BY d.OrderCount DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

SELECT p.CategoryID, p.ProductName, d.TotalSales
FROM Products p
JOIN (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
) d ON p.ProductID = d.ProductID;

WITH FactorialCTE AS (
    SELECT Number, CAST(1 AS BIGINT) AS Factorial
    FROM Numbers1
    WHERE Number = 0
    UNION ALL
    SELECT n.Number, CAST(n.Number * f.Factorial AS BIGINT)
    FROM Numbers1 n
    JOIN FactorialCTE f ON n.Number = f.Number + 1
    WHERE n.Number <= (SELECT MAX(Number) FROM Numbers1)
)
SELECT Number, ISNULL((
    SELECT Factorial
    FROM FactorialCTE f
    WHERE f.Number = n.Number
), 1) AS Factorial
FROM Numbers1 n
ORDER BY Number;

WITH SplitStringCTE AS (
    SELECT Id, String, 1 AS Pos, SUBSTRING(String, 1, 1) AS Char
    FROM Example
    UNION ALL
    SELECT Id, String, Pos + 1, SUBSTRING(String, Pos + 1, 1)
    FROM SplitStringCTE
    WHERE Pos < LEN(String)
)
SELECT Id, String, Pos, Char
FROM SplitStringCTE
ORDER BY Id, Pos;

WITH MonthlySales AS (
    SELECT 
        EmployeeID,
        YEAR(SaleDate) AS SaleYear,
        MONTH(SaleDate) AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, YEAR(SaleDate), MONTH(SaleDate)
)
SELECT 
    m1.EmployeeID,
    m1.SaleYear,
    m1.SaleMonth,
    m1.TotalSales,
    m1.TotalSales - LAG(m1.TotalSales) OVER (PARTITION BY m1.EmployeeID ORDER BY m1.SaleYear, m1.SaleMonth) AS SalesDifference
FROM MonthlySales m1;

SELECT e.EmployeeID, e.FirstName, e.LastName, d.Quarter, d.TotalSales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        DATEPART(QUARTER, SaleDate) AS Quarter,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) d ON e.EmployeeID = d.EmployeeID;

WITH FibonacciCTE AS (
    SELECT 0 AS Number, 0 AS Fibonacci
    UNION ALL
    SELECT 1, 1
    UNION ALL
    SELECT Number + 1, Fibonacci + LAG(Fibonacci) OVER (ORDER BY Number)
    FROM FibonacciCTE
    WHERE Number < 10
)
SELECT Number, Fibonacci
FROM FibonacciCTE;

SELECT Id, Vals
FROM FindSameCharacters
WHERE LEN(Vals) > 1
AND Vals NOT LIKE '%[^' + LEFT(Vals, 1) + ']%';

WITH NumberSequenceCTE AS (
    SELECT 1 AS Number, CAST('1' AS VARCHAR(100)) AS Sequence
    UNION ALL
    SELECT Number + 1, CAST(CONCAT(Sequence, Number + 1) AS VARCHAR(100))
    FROM NumberSequenceCTE
    WHERE Number < 5
)
SELECT Number, Sequence
FROM NumberSequenceCTE;

SELECT e.EmployeeID, e.FirstName, e.LastName, d.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) d ON e.EmployeeID = d.EmployeeID
WHERE d.TotalSales = (
    SELECT MAX(TotalSales)
    FROM (
        SELECT SUM(SalesAmount) AS TotalSales
        FROM Sales
        WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY EmployeeID
    ) sub
);

WITH CleanedNames AS (
    SELECT 
        PawanName,
        Pawan_slug_name,
        PATINDEX('%[0-9]%', Pawan_slug_name) AS FirstDigitPos
    FROM RemoveDuplicateIntsFromNames
),
UniqueDigits AS (
    SELECT 
        PawanName,
        Pawan_slug_name,
        STRING_AGG(CASE 
            WHEN SUBSTRING(Pawan_slug_name, n, 1) LIKE '[0-9]' 
            AND LEN(SUBSTRING(Pawan_slug_name, n, 1)) > 1 
            THEN SUBSTRING(Pawan_slug_name, n, 1)
            ELSE NULL 
        END, '') AS UniqueDigits,
        STRING_AGG(CASE 
            WHEN SUBSTRING(Pawan_slug_name, n, 1) NOT LIKE '[0-9]' 
            THEN SUBSTRING(Pawan_slug_name, n, 1) 
            ELSE '' 
        END, '') AS NonDigits
    FROM CleanedNames
    CROSS APPLY (
        SELECT TOP (LEN(Pawan_slug_name)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.all_objects
    ) AS Numbers
    WHERE n <= LEN(Pawan_slug_name)
    GROUP BY PawanName, Pawan_slug_name
)
SELECT 
    PawanName,
    CONCAT(NonDigits, '-', UniqueDigits) AS CleanedName
FROM UniqueDigits;
