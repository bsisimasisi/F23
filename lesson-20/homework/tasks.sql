-- 1. Find customers who purchased at least one item in March 2024 using EXISTS
SELECT DISTINCT CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
    AND YEAR(s2.SaleDate) = 2024
    AND MONTH(s2.SaleDate) = 3
);

-- 2. Find the product with the highest total sales revenue using a subquery
SELECT Product
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRevenue
        FROM #Sales
        GROUP BY Product
    ) sub
);

-- 3. Find the second highest sale amount using a subquery
SELECT MAX(Quantity * Price) AS SecondHighestSale
FROM #Sales
WHERE Quantity * Price < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);

-- 4. Find the total quantity of products sold per month using a subquery
SELECT 
    MONTH(SaleDate) AS SaleMonth,
    YEAR(SaleDate) AS SaleYear,
    (
        SELECT SUM(Quantity)
        FROM #Sales s2
        WHERE MONTH(s2.SaleDate) = MONTH(s1.SaleDate)
        AND YEAR(s2.SaleDate) = YEAR(s1.SaleDate)
    ) AS TotalQuantity
FROM #Sales s1
GROUP BY MONTH(SaleDate), YEAR(SaleDate);

-- 5. Find customers who bought same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName != s1.CustomerName
    AND s2.Product = s1.Product
);

-- 6. Return how many fruits does each person have in individual fruit level
SELECT 
    Name,
    SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

-- 7. Return older people in the family with younger ones
WITH FamilyHierarchy AS (
    SELECT ParentId AS PID, ChildID AS CHID
    FROM Family
    UNION
    SELECT f1.ParentId, f2.ChildID
    FROM Family f1
    JOIN Family f2 ON f1.ChildID = f2.ParentId
    UNION
    SELECT f1.ParentId, f3.ChildID
    FROM Family f1
    JOIN Family f2 ON f1.ChildID = f2.ParentId
    JOIN Family f3 ON f2.ChildID = f3.ParentId
)
SELECT PID, CHID
FROM FamilyHierarchy
ORDER BY PID, CHID;

-- 8. Provide customer orders delivered to Texas for customers with California deliveries
SELECT CustomerID, OrderID, DeliveryState, Amount
FROM #Orders o1
WHERE DeliveryState = 'TX'
AND EXISTS (
    SELECT 1
    FROM #Orders o2
    WHERE o2.CustomerID = o1.CustomerID
    AND o2.DeliveryState = 'CA'
);

-- 9. Insert missing resident names
UPDATE #residents
SET fullname = SUBSTRING(address, CHARINDEX('name=', address) + 5, 
    CHARINDEX(' ', address, CHARINDEX('name=', address)) - CHARINDEX('name=', address) - 5)
WHERE fullname IS NULL
OR fullname NOT LIKE SUBSTRING(address, CHARINDEX('name=', address) + 5, 
    CHARINDEX(' ', address, CHARINDEX('name=', address)) - CHARINDEX('name=', address) - 5);

-- 10. Find cheapest and most expensive routes from Tashkent to Khorezm
WITH RoutesCTE AS (
    SELECT 
        CAST(CONCAT(DepartureCity, ' - ', ArrivalCity) AS VARCHAR(MAX)) AS Route,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent' AND ArrivalCity = 'Khorezm'
    UNION ALL
    SELECT 
        CAST(CONCAT(r1.DepartureCity, ' - ', r1.ArrivalCity, ' - ', r2.ArrivalCity) AS VARCHAR(MAX)),
        r1.Cost + r2.Cost
    FROM #Routes r1
    JOIN #Routes r2 ON r1.ArrivalCity = r2.DepartureCity
    WHERE r1.DepartureCity = 'Tashkent' AND r2.ArrivalCity = 'Khorezm'
    UNION ALL
    SELECT 
        CAST(CONCAT(r1.DepartureCity, ' - ', r1.ArrivalCity, ' - ', r2.ArrivalCity, ' - ', r3.ArrivalCity) AS VARCHAR(MAX)),
        r1.Cost + r2.Cost + r3.Cost
    FROM #Routes r1
    JOIN #Routes r2 ON r1.ArrivalCity = r2.DepartureCity
    JOIN #Routes r3 ON r2.ArrivalCity = r3.DepartureCity
    WHERE r1.DepartureCity = 'Tashkent' AND r3.ArrivalCity = 'Khorezm'
    UNION ALL
    SELECT 
        CAST(CONCAT(r1.DepartureCity, ' - ', r1.ArrivalCity, ' - ', r2.ArrivalCity, ' - ', r3.ArrivalCity, ' - ', r4.ArrivalCity) AS VARCHAR(MAX)),
        r1.Cost + r2.Cost + r3.Cost + r4.Cost
    FROM #Routes r1
    JOIN #Routes r2 ON r1.ArrivalCity = r2.DepartureCity
    JOIN #Routes r3 ON r2.ArrivalCity = r3.DepartureCity
    JOIN #Routes r4 ON r3.ArrivalCity = r4.DepartureCity
    WHERE r1.DepartureCity = 'Tashkent' AND r4.ArrivalCity = 'Khorezm'
)
SELECT Route, Cost
FROM RoutesCTE
WHERE Cost IN (
    (SELECT MIN(Cost) FROM RoutesCTE),
    (SELECT MAX(Cost) FROM RoutesCTE)
)
ORDER BY Cost;

-- 11. Rank products based on their order of insertion
WITH ProductRank AS (
    SELECT ID, Vals,
           MIN(CASE WHEN Vals = 'Product' THEN ID END) OVER (ORDER BY ID) AS GroupStart
    FROM #RankingPuzzle
)
SELECT ID, Vals,
       DENSE_RANK() OVER (PARTITION BY GroupStart ORDER BY ID) AS ProductRank
FROM ProductRank
WHERE Vals != 'Product';

-- 12. Find employees whose sales were higher than the average sales in their department
SELECT e.EmployeeID, e.EmployeeName, e.Department, e.SalesAmount
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales e2
    WHERE e2.Department = e.Department
    AND e2.SalesMonth = e.SalesMonth
    AND e2.SalesYear = e.SalesYear
);

-- 13. Find employees who had the highest sales in any given month using EXISTS
SELECT DISTINCT e.EmployeeID, e.EmployeeName
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.SalesMonth = e.SalesMonth
    AND e2.SalesYear = e.SalesYear
    AND e2.SalesAmount = (
        SELECT MAX(SalesAmount)
        FROM #EmployeeSales e3
        WHERE e3.SalesMonth = e.SalesMonth
        AND e3.SalesYear = e.SalesYear
    )
    AND e2.EmployeeID = e.EmployeeID
);

-- 14. Find employees who made sales in every month using NOT EXISTS
SELECT DISTINCT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth, SalesYear
    FROM #EmployeeSales e2
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e3
        WHERE e3.EmployeeName = e.EmployeeName
        AND e3.SalesMonth = e2.SalesMonth
        AND e3.SalesYear = e2.SalesYear
    )
);

-- 15. Retrieve products more expensive than the average price
SELECT Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- 16. Find products with stock count lower than the highest stock count
SELECT Name, Stock
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

-- 17. Get products in the same category as 'Laptop'
SELECT Name
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
);

-- 18. Retrieve products with price greater than the lowest price in Electronics
SELECT Name, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);

-- 19. Find products with price higher than their category's average
SELECT p.Name, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(Price)
    FROM Products p2
    WHERE p2.Category = p.Category
);

-- 20. Find products that have been ordered at least once
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

-- 21. Retrieve products ordered more than the average quantity
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.Quantity > (
    SELECT AVG(Quantity)
    FROM Orders
);

-- 22. Find products that have never been ordered
SELECT Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);

-- 23. Retrieve product with the highest total quantity ordered
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) = (
    SELECT MAX(TotalQuantity)
    FROM (
        SELECT SUM(Quantity) AS TotalQuantity
        FROM Orders
        GROUP BY ProductID
    ) sub
);
