-- Easy Questions

-- 1. Compute Running Total Sales per Customer
SELECT sale_id, customer_id, customer_name, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM sales_data;

-- 2. Count the Number of Orders per Product Category
SELECT product_category,
       COUNT(*) OVER (PARTITION BY product_category) AS order_count
FROM sales_data;

-- 3. Find the Maximum Total Amount per Product Category
SELECT sale_id, product_category, total_amount,
       MAX(total_amount) OVER (PARTITION BY product_category) AS max_total_amount
FROM sales_data;

-- 4. Find the Minimum Price of Products per Product Category
SELECT sale_id, product_category, unit_price,
       MIN(unit_price) OVER (PARTITION BY product_category) AS min_price
FROM sales_data;

-- 5. Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
SELECT sale_id, order_date, total_amount,
       AVG(total_amount) OVER (
           ORDER BY order_date
           ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
       ) AS moving_average
FROM sales_data;

-- 6. Find the Total Sales per Region
SELECT region,
       SUM(total_amount) OVER (PARTITION BY region) AS total_sales
FROM sales_data;

-- 7. Compute the Rank of Customers Based on Their Total Purchase Amount
WITH CustomerTotals AS (
    SELECT customer_id, customer_name,
           SUM(total_amount) AS total_purchase
    FROM sales_data
    GROUP BY customer_id, customer_name
)
SELECT customer_id, customer_name, total_purchase,
       DENSE_RANK() OVER (ORDER BY total_purchase DESC) AS purchase_rank
FROM CustomerTotals;

-- 8. Calculate the Difference Between Current and Previous Sale Amount per Customer
SELECT sale_id, customer_id, customer_name, total_amount,
       total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS amount_difference
FROM sales_data;

-- 9. Find the Top 3 Most Expensive Products in Each Category
WITH RankedProducts AS (
    SELECT sale_id, product_category, product_name, unit_price,
           ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS price_rank
    FROM sales_data
)
SELECT sale_id, product_category, product_name, unit_price
FROM RankedProducts
WHERE price_rank <= 3;

-- 10. Compute the Cumulative Sum of Sales Per Region by Order Date
SELECT sale_id, region, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- Medium Questions

-- 11. Compute Cumulative Revenue per Product Category
SELECT sale_id, product_category, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date) AS cumulative_revenue
FROM sales_data;

-- 12. Sum of Previous Values to Current Value
SELECT Value,
       SUM(Value) OVER (ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SumOfPrevious
FROM OneColumn;

-- 13. Generate Row Numbers with Odd First Number per Partition
SELECT Id, Vals,
       2 * ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) - 1 AS RowNumber
FROM Row_Nums;

-- 14. Find Customers with Purchases from More than One Product Category
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

-- 15. Find Customers with Above-Average Spending in Their Region
WITH RegionAverages AS (
    SELECT region,
           AVG(total_amount) AS avg_region_spending
    FROM sales_data
    GROUP BY region
)
SELECT s.customer_id, s.customer_name, s.region, SUM(s.total_amount) AS total_spending
FROM sales_data s
JOIN RegionAverages ra ON s.region = ra.region
GROUP BY s.customer_id, s.customer_name, s.region
HAVING SUM(s.total_amount) > ra.avg_region_spending;

-- 16. Rank Customers Based on Total Spending Within Each Region
WITH CustomerRegionTotals AS (
    SELECT customer_id, customer_name, region,
           SUM(total_amount) AS total_spending
    FROM sales_data
    GROUP BY customer_id, customer_name, region
)
SELECT customer_id, customer_name, region, total_spending,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY total_spending DESC) AS spending_rank
FROM CustomerRegionTotals;

-- 17. Calculate Running Total of Total Amount for Each Customer
SELECT sale_id, customer_id, customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- 18. Calculate Sales Growth Rate for Each Month Compared to Previous Month
WITH MonthlySales AS (
    SELECT YEAR(order_date) AS sale_year,
           MONTH(order_date) AS sale_month,
           SUM(total_amount) AS monthly_total
    FROM sales_data
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT sale_year, sale_month, monthly_total,
       ROUND(
           ((monthly_total - LAG(monthly_total) OVER (ORDER BY sale_year, sale_month)) / 
           NULLIF(LAG(monthly_total) OVER (ORDER BY sale_year, sale_month), 0) * 100),
           2
       ) AS growth_rate
FROM MonthlySales;

-- 19. Identify Customers Whose Total Amount is Higher Than Their Last Order's Total Amount
WITH LastOrder AS (
    SELECT customer_id,
           MAX(order_date) AS last_order_date,
           MAX(total_amount) AS last_order_amount
    FROM sales_data
    GROUP BY customer_id
)
SELECT s.customer_id, s.customer_name,
       SUM(s.total_amount) AS total_spending,
       lo.last_order_amount
FROM sales_data s
JOIN LastOrder lo ON s.customer_id = lo.customer_id
GROUP BY s.customer_id, s.customer_name, lo.last_order_amount
HAVING SUM(s.total_amount) > lo.last_order_amount;

-- Hard Questions

-- 20. Identify Products with Prices Above Average Product Price
SELECT product_name, unit_price
FROM sales_data
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM sales_data
);

-- 21. Sum of Val1 and Val2 at the Beginning of Each Group
SELECT Id, Grp, Val1, Val2,
       CASE 
           WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
           THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
           ELSE NULL 
       END AS Tot
FROM MyData;

-- 22. Sum Cost and Add Quantities for Different Values
SELECT ID,
       SUM(Cost) AS Cost,
       SUM(DISTINCT Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

-- 23. Sum TyZe for Each Z
WITH SumForZ AS (
    SELECT Level, TyZe, Result,
           CASE 
               WHEN Result = 'Z' 
               THEN SUM(CASE WHEN Result = 'X' THEN TyZe ELSE 0 END) 
                    OVER (ORDER BY Level ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) + TyZe
               ELSE 0 
           END AS Results
    FROM testSuXVI
)
SELECT Level, TyZe, Result, Results
FROM SumForZ;

-- 24. Generate Row Numbers with Even First Number per Partition
SELECT Id, Vals,
       2 * ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) AS Changed
FROM Row_Nums;
