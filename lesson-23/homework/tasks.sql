-- Puzzle 1: Extract Month with Zero-Padding
SELECT Id, Dt, 
       RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPrefixedWithZero
FROM Dates;

-- Puzzle 2: Unique IDs and Sum of Max Values
SELECT 
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MAX( Vals)) OVER (PARTITION BY rID) AS TotalOfMaxVals
FROM MyTabel
GROUP BY Id, rID;

-- Puzzle 3: Records with 6 to 10 Characters
SELECT Id, Vals
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10
  AND Vals IS NOT NULL;

-- Puzzle 4: Maximum Value and Corresponding Item in Single SELECT
SELECT Id, Item, Vals
FROM (
    SELECT Id, Item, Vals,
           ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals DESC) AS rn
    FROM TestMaximum
) t
WHERE rn = 1;

-- Puzzle 5: Sum of Maximum Values by Id in Single SELECT
SELECT Id, 
       SUM(MAX(Vals)) OVER (PARTITION BY Id) AS SumofMax
FROM SumOfMax
GROUP BY Id, DetailedNumber;

-- Puzzle 6: Difference Between a and b with Zero Replaced by Blank
SELECT Id, a, b,
       CASE 
           WHEN a - b != 0 THEN CAST(a - b AS VARCHAR(10))
           ELSE ''
       END AS OUTPUT
FROM TheZeroPuzzle;

-- Sales Table Queries

-- 1. Total Revenue Generated from All Sales
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

-- 2. Average Unit Price of Products
SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales;

-- 3. Number of Sales Transactions Recorded
SELECT COUNT(*) AS TransactionCount
FROM Sales;

-- 4. Highest Number of Units Sold in a Single Transaction
SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales;

-- 5. Products Sold in Each Category
SELECT Category, COUNT(DISTINCT Product) AS ProductCount
FROM Sales
GROUP BY Category;

-- 6. Total Revenue for Each Region
SELECT Region, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

-- 7. Total Quantity Sold per Month
SELECT YEAR(SaleDate) AS SaleYear, MONTH(SaleDate) AS SaleMonth,
       SUM(QuantitySold) AS TotalQuantity
FROM Sales
GROUP BY YEAR(SaleDate), MONTH(SaleDate);

-- 8. Product with Highest Total Revenue
SELECT TOP 1 Product
FROM Sales
GROUP BY Product
ORDER BY SUM(QuantitySold * UnitPrice) DESC;

-- 9. Running Total of Revenue Ordered by Sale Date
SELECT SaleID, Product, SaleDate, 
       SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales;

-- 10. Category Contribution to Total Sales Revenue
SELECT Category, 
       SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
       SUM(QuantitySold * UnitPrice) / SUM(SUM(QuantitySold * UnitPrice)) OVER () AS RevenueContribution
FROM Sales
GROUP BY Category;

-- Customers and Sales Table Queries

-- 11. Show All Sales with Corresponding Customer Names
SELECT s.SaleID, s.Product, s.QuantitySold, s.UnitPrice, s.SaleDate, s.Region, c.CustomerName
FROM Sales s
JOIN Customers c ON s.SaleID = c.CustomerID;

-- 12. List Customers Who Have Not Made Any Purchases
SELECT c.CustomerID, c.CustomerName
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.SaleID
WHERE s.SaleID IS NULL;

-- 13. Compute Total Revenue Generated from Each Customer
SELECT c.CustomerID, c.CustomerName, 
       SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.SaleID
GROUP BY c.CustomerID, c.CustomerName;

-- 14. Find the Customer Who Has Contributed the Most Revenue
SELECT TOP 1 c.CustomerID, c.CustomerName, 
       SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.SaleID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

-- 15. Calculate Total Sales per Customer per Month
SELECT c.CustomerID, c.CustomerName, 
       YEAR(s.SaleDate) AS SaleYear, MONTH(s.SaleDate) AS SaleMonth,
       SUM(s.QuantitySold * s.UnitPrice) AS TotalSales
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.SaleID
WHERE s.SaleID IS NOT NULL
GROUP BY c.CustomerID, c.CustomerName, YEAR(s.SaleDate), MONTH(s.SaleDate);

-- Products Table Queries

-- 16. List All Products That Have Been Sold at Least Once
SELECT DISTINCT p.ProductName
FROM Products p
JOIN Sales s ON p.ProductName = s.Product;

-- 17. Find the Most Expensive Product in the Products Table
SELECT TOP 1 ProductName, SellingPrice
FROM Products
ORDER BY SellingPrice DESC;

-- 18. Show Each Sale with Its Corresponding Cost Price
SELECT s.SaleID, s.Product, s.QuantitySold, s.UnitPrice, s.SaleDate, 
       p.CostPrice
FROM Sales s
JOIN Products p ON s.Product = p.ProductName;

-- 19. Find All Products Where Selling Price is Higher Than Average in Category
SELECT p.ProductName, p.Category, p.SellingPrice
FROM Products p
WHERE p.SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Products p2
    WHERE p2.Category = p.Category
);
