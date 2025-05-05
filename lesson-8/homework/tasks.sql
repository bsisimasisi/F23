SELECT Category, COUNT(*) AS TotalProducts
FROM Products
GROUP BY Category;

SELECT AVG(Price) AS AveragePrice
FROM Products
WHERE Category = 'Electronics';

SELECT *
FROM Customers
WHERE City LIKE 'L%';

SELECT ProductName
FROM Products
WHERE ProductName LIKE '%er';

SELECT *
FROM Customers
WHERE Country LIKE '%A';

SELECT MAX(Price) AS HighestPrice
FROM Products;

SELECT ProductName, 
       CASE WHEN StockQuantity < 30 THEN 'Low Stock' ELSE 'Sufficient' END AS StockStatus
FROM Products;

SELECT Country, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY Country;

SELECT MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM Orders;

SELECT DISTINCT o.CustomerID
FROM Orders o
LEFT JOIN Invoices i ON o.CustomerID = i.CustomerID 
    AND YEAR(i.InvoiceDate) = 2023 
    AND MONTH(i.InvoiceDate) = 1
WHERE YEAR(o.OrderDate) = 2023 
    AND MONTH(o.OrderDate) = 1
    AND i.InvoiceID IS NULL;

SELECT ProductName
FROM Products
UNION ALL
SELECT ProductName
FROM Products_Discounted;

SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;

SELECT YEAR(OrderDate) AS OrderYear, AVG(TotalAmount) AS AverageOrderAmount
FROM Orders
GROUP BY YEAR(OrderDate);


SELECT ProductName, 
       CASE 
           WHEN Price < 100 THEN 'Low'
           WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
           ELSE 'High'
       END AS PriceGroup
FROM Products;

SELECT District_Name, [2012], [2013]
INTO Population_Each_Year
FROM City_Population
PIVOT
(
    SUM(Population)
    FOR Year IN ([2012], [2013])
) AS PivotTable;

SELECT ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

SELECT ProductName
FROM Products
WHERE ProductName LIKE '%oo%';

SELECT Year, Bektemir, Chilonzor, Yakkasaroy
INTO Population_Each_City
FROM City_Population
PIVOT
(
    SUM(Population)
    FOR District_Name IN (Bektemir, Chilonzor, Yakkasaroy)
) AS PivotTable;

SELECT TOP 3 CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

SELECT District_Name AS District_Name, Year, Population
FROM Population_Each_Year
UNPIVOT
(
    Population
    FOR Year IN ([2012], [2013])
) AS UnpivotTable
WHERE Population IS NOT NULL;

SELECT p.ProductName, COUNT(s.SaleID) AS TimesSold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;

SELECT District_Name, Year, Population
FROM Population_Each_City
UNPIVOT
(
    Population
    FOR District_Name IN (Bektemir, Chilonzor, Yakkasaroy)
) AS UnpivotTable
WHERE Population IS NOT NULL;
