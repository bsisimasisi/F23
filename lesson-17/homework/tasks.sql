SELECT r.Region, d.Distributor, ISNULL(rs.Sales, 0) AS Sales
FROM (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN #RegionSales rs ON r.Region = rs.Region AND d.Distributor = rs.Distributor
ORDER BY r.Region, d.Distributor;

SELECT e.name
FROM Employee e
JOIN (
    SELECT managerId, COUNT(*) AS report_count
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
) m ON e.id = m.managerId;

SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE YEAR(o.order_date) = 2020 AND MONTH(o.order_date) = 2
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

WITH OrderCounts AS (
    SELECT CustomerID, Vendor, COUNT(*) AS order_count,
           RANK() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC) AS rnk
    FROM Orders
    GROUP BY CustomerID, Vendor
)
SELECT CustomerID, Vendor
FROM OrderCounts
WHERE rnk = 1;

DECLARE @Check_Prime INT = 91;
DECLARE @is_prime BIT = 1;
DECLARE @divisor INT = 2;
WHILE @divisor <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @divisor = 0
    BEGIN
        SET @is_prime = 0;
        BREAK;
    END
    SET @divisor = @divisor + 1;
END
SELECT CASE WHEN @Check_Prime < 2 THEN 'This number is not prime'
            WHEN @is_prime = 1 THEN 'This number is prime'
            ELSE 'This number is not prime' END AS Result;

SELECT 
    Device_id,
    COUNT(DISTINCT Locations) AS no_of_location,
    (SELECT TOP 1 Locations
     FROM Device d2
     WHERE d2.Device_id = d1.Device_id
     GROUP BY Locations
     ORDER BY COUNT(*) DESC) AS max_signal_location,
    COUNT(*) AS no_of_signals
FROM Device d1
GROUP BY Device_id;

SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employee e2
    WHERE e2.DeptID = e.DeptID
);

WITH WinningNumbers AS (
    SELECT Number
    FROM (SELECT 25 AS Number UNION SELECT 45 UNION SELECT 78) AS wn
),
TicketCounts AS (
    SELECT TicketID, COUNT(*) AS matched_numbers
    FROM Tickets t
    JOIN WinningNumbers wn ON t.Number = wn.Number
    GROUP BY TicketID
),
Winnings AS (
    SELECT 
        CASE 
            WHEN matched_numbers = 3 THEN 100
            WHEN matched_numbers > 0 THEN 10
            ELSE 0
        END AS prize
    FROM TicketCounts
)
SELECT SUM(prize) AS TotalWinnings
FROM Winnings;

WITH UserPlatforms AS (
    SELECT Spend_date, User_id, 
           COUNT(DISTINCT Platform) AS platform_count,
           STRING_AGG(Platform, ',') AS platforms,
           SUM(Amount) AS total_amount
    FROM Spending
    GROUP BY Spend_date, User_id
),
PlatformSummary AS (
    SELECT Spend_date, 
           CASE 
               WHEN platform_count = 1 THEN platforms
               WHEN platform_count = 2 THEN 'Both'
           END AS Platform,
           COUNT(*) AS Total_users,
           SUM(total_amount) AS Total_Amount
    FROM UserPlatforms
    GROUP BY Spend_date, 
             CASE 
                 WHEN platform_count = 1 THEN platforms
                 WHEN platform_count = 2 THEN 'Both'
             END
    UNION ALL
    SELECT Spend_date, 'Both', 0, 0
    FROM Spending
    WHERE Spend_date NOT IN (
        SELECT Spend_date 
        FROM UserPlatforms 
        WHERE platform_count = 2
    )
    GROUP BY Spend_date
)
SELECT Spend_date, Platform, Total_Amount, Total_users
FROM PlatformSummary
WHERE Platform IS NOT NULL
ORDER BY Spend_date, 
         CASE Platform 
             WHEN 'Mobile' THEN 1 
             WHEN 'Desktop' THEN 2 
             WHEN 'Both' THEN 3 
         END;

WITH NumberSequence AS (
    SELECT Product, 1 AS seq
    FROM Grouped
    WHERE Quantity >= 1
    UNION ALL
    SELECT Product, seq + 1
    FROM NumberSequence
    WHERE seq < (SELECT Quantity FROM Grouped g WHERE g.Product = NumberSequence.Product)
)
SELECT Product, 1 AS Quantity
FROM NumberSequence
ORDER BY Product, seq;
