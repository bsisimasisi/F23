SELECT p.ProductID, SUM(s.Quantity) AS TotalQuantity, SUM(s.Quantity * p.Price) AS TotalRevenue
INTO #MonthlySales
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = YEAR(GETDATE()) AND MONTH(s.SaleDate) = MONTH(GETDATE())
GROUP BY p.ProductID;
SELECT ProductID, TotalQuantity, TotalRevenue FROM #MonthlySales;

CREATE VIEW vw_ProductSalesSummary AS
SELECT p.ProductID, p.ProductName, p.Category, ISNULL(SUM(s.Quantity), 0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;

CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10,2);
    SELECT @TotalRevenue = ISNULL(SUM(s.Quantity * p.Price), 0)
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID;
    RETURN @TotalRevenue;
END;

CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT p.ProductName, ISNULL(SUM(s.Quantity), 0) AS TotalQuantity, ISNULL(SUM(s.Quantity * p.Price), 0) AS TotalRevenue
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName;

CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @IsPrime VARCHAR(3) = 'No';
    IF @Number > 1
    BEGIN
        DECLARE @Divisor INT = 2;
        DECLARE @IsDivisible BIT = 0;
        WHILE @Divisor <= SQRT(@Number)
        BEGIN
            IF @Number % @Divisor = 0
            BEGIN
                SET @IsDivisible = 1;
                BREAK;
            END
            SET @Divisor = @Divisor + 1;
        END
        IF @IsDivisible = 0
            SET @IsPrime = 'Yes';
    END
    RETURN @IsPrime;
END;

CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    WITH NumbersCTE AS (
        SELECT @Start AS Number
        UNION ALL
        SELECT Number + 1
        FROM NumbersCTE
        WHERE Number < @End
    )
    INSERT INTO @Numbers
    SELECT Number FROM NumbersCTE;
    RETURN;
END;

CREATE FUNCTION getNthHighestSalary (@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;
    SELECT @Result = salary
    FROM (
        SELECT DISTINCT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM Employee
    ) ranked
    WHERE rnk = @N;
    RETURN @Result;
END;

WITH FriendCounts AS (
    SELECT requester_id AS id, COUNT(*) AS friend_count
    FROM RequestAccepted
    GROUP BY requester_id
    UNION ALL
    SELECT accepter_id AS id, COUNT(*) AS friend_count
    FROM RequestAccepted
    GROUP BY accepter_id
)
SELECT TOP 1 id, SUM(friend_count) AS num
FROM FriendCounts
GROUP BY id
ORDER BY num DESC;

CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    ISNULL(SUM(o.amount), 0) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

SELECT RowNumber, 
       ISNULL((
           SELECT TOP 1 TestCase
           FROM Gaps g2
           WHERE-г2.RowNumber <= g1.RowNumber
           AND g2.TestCase IS NOT NULL
           ORDER BY g2.RowNumber DESC
       ), '') AS Workflow
FROM Gaps g1;
