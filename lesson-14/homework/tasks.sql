SELECT Id, PARSENAME(REPLACE(Name, ',', '.'), 2) AS Name, PARSENAME(REPLACE(Name, ',', '.'), 1) AS Surname FROM TestMultipleColumns;

SELECT Strs FROM TestPercent WHERE Strs LIKE '%[%]%';

SELECT Id, PARSENAME(REPLACE(Vals, '.', '.'), 2) AS FirstPart, PARSENAME(REPLACE(Vals, '.', '.'), 1) AS SecondPart FROM Splitter;

SELECT PATINDEX('%[0-9]%', '1234ABC123456XYZ1234567890ADS') AS Position, PATINDEX('%[0-9]%', '1234ABC123456XYZ1234567890ADS') AS ReplacedString;

SELECT ID, Vals FROM testDots WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

SELECT texts, LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount FROM CountSpaces;

SELECT e1.Id, e1.Name FROM Employee e1 JOIN Employee e2 ON e1.ManagerId = e2.Id WHERE e1.Salary > e2.Salary;

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsOfService FROM Employees WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 14;

DECLARE @String VARCHAR(50) = 'rtcfvty34redt'; SELECT STRING_AGG(CASE WHEN SUBSTRING(@String, n, 1) LIKE '[0-9]' THEN SUBSTRING(@String, n, 1) END, '') AS Integers, STRING_AGG(CASE WHEN SUBSTRING(@String, n, 1) NOT LIKE '[0-9]' THEN SUBSTRING(@String, n, 1) END, '') AS Characters FROM (SELECT TOP (LEN(@String)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM sys.all_objects) AS Numbers WHERE n <= LEN(@String);

SELECT w1.Id FROM weather w1 JOIN weather w2 ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate) WHERE w1.Temperature > w2.Temperature;

SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id;

SELECT PARSENAME(REPLACE(fruit_list, ',', '.'), 2) AS ThirdFruit FROM fruits;

SELECT SUBSTRING('sdgfhsdgfhs@121313131', n, 1) AS Character FROM (SELECT TOP (LEN('sdgfhsdgfhs@121313131')) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM sys.all_objects) AS Numbers WHERE n <= LEN('sdgfhsdgfhs@121313131');

SELECT p1.id, CASE WHEN p1.code = 0 THEN p2.code ELSE p1.code END AS code FROM p1 JOIN p2 ON p1.id = p2.id;

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire' WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior' WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 5 AND 10 THEN 'Mid-Level' WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 20 THEN 'Senior' ELSE 'Veteran' END AS EmploymentStage FROM Employees;

SELECT Id, CAST(LEFT(VALS, PATINDEX('%[^0-9]%', VALS + ' ') - 1) AS INT) AS IntegerValue FROM GetIntegers WHERE VALS IS NOT NULL AND VALS LIKE '[0-9]%';

SELECT Id, CONCAT(SUBSTRING(Vals, 3, 1), SUBSTRING(Vals, 2, 1), SUBSTRING(Vals, 4, LEN(Vals))) AS SwappedVals FROM MultipleVals;

SELECT player_id, device_id FROM Activity WHERE (player_id, event_date) IN (SELECT player_id, MIN(event_date) FROM Activity GROUP BY player_id);

WITH WeeklySales AS (SELECT FinancialWeek, Area, SUM(COALESCE(SalesLocal, 0) + COALESCE(SalesRemote, 0)) AS TotalSales FROM WeekPercentagePuzzle GROUP BY FinancialWeek, Area), WeeklyTotals AS (SELECT FinancialWeek, SUM(TotalSales) AS WeekTotal FROM WeeklySales GROUP BY FinancialWeek) SELECT w.FinancialWeek, w.Area, w.TotalSales, (w.TotalSales * 100.0 / t.WeekTotal) AS Percentage FROM WeeklySales w JOIN WeeklyTotals t ON w.FinancialWeek = t.FinancialWeek ORDER BY w.FinancialWeek, w.Area;
