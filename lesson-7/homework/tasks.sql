SELECT MIN(Price) AS Min_Price FROM Products;

SELECT MAX(Salary) AS Max_Salary FROM Employees;

SELECT COUNT(*) AS Total_Customers FROM Customers;

SELECT COUNT(DISTINCT Category) AS Unique_Categories FROM Products;

SELECT Product_ID, SUM(Sales_Amount) AS Total_Sales 
FROM Sales 
WHERE Product_ID = 'your_product_id' 
GROUP BY Product_ID;

SELECT AVG(Age) AS Average_Age FROM Employees;

SELECT Department, COUNT(*) AS Employee_Count 
FROM Employees 
GROUP BY Department;

SELECT Category, MIN(Price) AS Min_Price, MAX(Price) AS Max_Price 
FROM Products 
GROUP BY Category;

SELECT Region, SUM(Sales_Amount) AS Total_Sales 
FROM Sales 
GROUP BY Region;

SELECT Department, COUNT(*) AS Employee_Count 
FROM Employees 
GROUP BY Department 
HAVING COUNT(*) > 5;

SELECT Category, 
       SUM(Sales_Amount) AS Total_Sales, 
       AVG(Sales_Amount) AS Average_Sales 
FROM Sales 
GROUP BY Category;

SELECT JobTitle, COUNT(JobTitle) AS Employee_Count 
FROM Employees 
WHERE JobTitle = 'your_job_title'
GROUP BY JobTitle;

SELECT Department, 
       MAX(Salary) AS Max_Salary, 
       MIN(Salary) AS Min_Salary 
FROM Employees 
GROUP BY Department;

SELECT Department, AVG(Salary) AS Average_Salary 
FROM Employees 
GROUP BY Department;

SELECT Department, 
       AVG(Salary) AS Average_Salary, 
       COUNT(*) AS Employee_Count 
FROM Employees 
GROUP BY Department;

SELECT Product_ID, AVG(Price) AS Average_Price 
FROM Products 
GROUP BY Product_ID 
HAVING AVG(Price) > 100;

SELECT COUNT(DISTINCT Product_ID) AS Product_Count 
FROM Sales 
WHERE Quantity > 100;

SELECT YEAR(Sale_Date) AS Sale_Year, 
       SUM(Sales_Amount) AS Total_Sales 
FROM Sales 
GROUP BY YEAR(Sale_Date);

SELECT Region, COUNT(DISTINCT Customer_ID) AS Customer_Count 
FROM Sales 
GROUP BY Region;

SELECT Department, SUM(Salary) AS Total_Salary 
FROM Employees 
GROUP BY Department 
HAVING SUM(Salary) > 100000;

SELECT Category, AVG(Sales_Amount) AS Average_Sales
FROM Sales
GROUP BY Category
HAVING AVG(Sales_Amount) > 200;

SELECT Employee_ID, SUM(Sales_Amount) AS Total_Sales
FROM Sales
GROUP BY Employee_ID
HAVING SUM(Sales_Amount) > 5000;

SELECT Department, 
       SUM(Salary) AS Total_Salary, 
       AVG(Salary) AS Average_Salary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 6000;

SELECT Customer_ID, 
       MAX(Order_Amount) AS Max_Order_Value, 
       MIN(Order_Amount) AS Min_Order_Value
FROM Orders
GROUP BY Customer_ID
HAVING MIN(Order_Amount) >= 50;

SELECT Region, 
       SUM(Sales_Amount) AS Total_Sales, 
       COUNT(DISTINCT Product_ID) AS Unique_Products_Sold
FROM Sales
GROUP BY Region
HAVING COUNT(DISTINCT Product_ID) > 10;

SELECT p.Category, 
       s.Product_ID, 
       MIN(s.Quantity) AS Min_Order_Quantity, 
       MAX(s.Quantity) AS Max_Order_Quantity
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
GROUP BY p.Category, s.Product_ID;

SELECT Region, 
       SUM(CASE WHEN YEAR(Sale_Date) = 2020 THEN Sales_Amount ELSE 0 END) AS Sales_2020,
       SUM(CASE WHEN YEAR(Sale_Date) = 2021 THEN Sales_Amount ELSE 0 END) AS Sales_2021,
       SUM(CASE WHEN YEAR(Sale_Date) = 2022 THEN Sales_Amount ELSE 0 END) AS Sales_2022
FROM Sales
GROUP BY Region;
