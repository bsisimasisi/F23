-- Task 1: Stored Procedure to Create Temp Table with Employee Bonus
CREATE PROCEDURE sp_EmployeeBonus
AS
BEGIN
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        e.EmployeeID,
        CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
        e.Department,
        e.Salary,
        e.Salary * db.BonusPercentage / 100 AS BonusAmount
    FROM Employees e
    JOIN DepartmentBonus db ON e.Department = db.Department;

    SELECT EmployeeID, FullName, Department, Salary, BonusAmount
    FROM #EmployeeBonus;
END;

-- Task 2: Stored Procedure to Update Salaries by Department
CREATE PROCEDURE sp_UpdateDepartmentSalary
    @Department NVARCHAR(50),
    @IncreasePercentage DECIMAL(5,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary * (1 + @IncreasePercentage / 100)
    WHERE Department = @Department;

    SELECT EmployeeID, FirstName, LastName, Department, Salary
    FROM Employees
    WHERE Department = @Department;
END;

-- Task 3: MERGE Operation for Products
MERGE INTO Products_Current AS target
USING Products_New AS source
ON target.ProductID = source.ProductID
WHEN MATCHED THEN
    UPDATE SET 
        ProductName = source.ProductName,
        Price = source.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
SELECT ProductID, ProductName, Price
FROM Products_Current;

-- Task 4: Tree Node Type Classification
SELECT 
    id,
    CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id NOT IN (SELECT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS type
FROM Tree
ORDER BY id;

-- Task 5: Confirmation Rate Calculation
SELECT 
    s.user_id,
    ROUND(
        ISNULL(
            SUM(CASE WHEN c.action = 'confirmed' THEN 1.0 ELSE 0 END) / 
            NULLIF(COUNT(c.action), 0), 
            0
        ), 
        2
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id;

-- Task 6: Find Employees with Lowest Salary
SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- Task 7: Stored Procedure for Product Sales Summary
CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantitySold,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;
