SELECT CONCAT(EMPLOYEE_ID, '-', FIRST_NAME, ' ', LAST_NAME) AS Result FROM Employees;

UPDATE Employees SET PHONE_NUMBER = REPLACE(PHONE_NUMBER, '124', '999');

SELECT FIRST_NAME AS FirstName, LEN(FIRST_NAME) AS NameLength FROM Employees WHERE FIRST_NAME LIKE '[AJM]%' ORDER BY FIRST_NAME;

SELECT MANAGER_ID, SUM(SALARY) AS TotalSalary FROM Employees WHERE MANAGER_ID IS NOT NULL GROUP BY MANAGER_ID;

SELECT Year1, CASE WHEN Max1 >= Max2 AND Max1 >= Max3 THEN Max1 WHEN Max2 >= Max1 AND Max2 >= Max3 THEN Max2 ELSE Max3 END AS HighestValue FROM TestMax;

SELECT id, movie, description, rating FROM cinema WHERE id % 2 = 1 AND description != 'boring';

SELECT Id, Vals FROM SingleOrder ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id;

SELECT id, COALESCE(ssn, passportid, itin) AS FirstNonNull FROM person;

SELECT StudentID, TRIM(PARSENAME(REPLACE(FullName, ' ', '.'), 3)) AS Firstname, TRIM(PARSENAME(REPLACE(FullName, ' ', '.'), 2)) AS Middlename, TRIM(PARSENAME(REPLACE(FullName, ' ', '.'), 1)) AS Lastname FROM Students;

SELECT CustomerID, OrderID, DeliveryState, Amount FROM Orders WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE DeliveryState = '

CA') AND DeliveryState = 'TX';

SELECT STRING_AGG(String, ' ') AS ConcatenatedString FROM DMLTable;

SELECT FIRST_NAME, LAST_NAME FROM Employees WHERE LEN(CONCAT(FIRST_NAME, LAST_NAME)) - LEN(REPLACE(LOWER(CONCAT(FIRST_NAME, LAST_NAME)), 'a', '')) >= 3;

SELECT DEPARTMENT_ID, COUNT(*) AS TotalEmployees, (COUNT(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 END) * 100.0 / COUNT(*)) AS PercentOver3Years FROM Employees WHERE DEPARTMENT_ID IS NOT NULL GROUP BY DEPARTMENT_ID;

WITH RankedExperience AS (SELECT SpacemanID, JobDescription, MissionCount, ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount DESC) AS MostExperienced, ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount ASC) AS LeastExperienced FROM Personal) SELECT JobDescription, MAX(CASE WHEN MostExperienced = 1 THEN SpacemanID END) AS MostExperiencedID, MAX(CASE WHEN LeastExperienced = 1 THEN SpacemanID END) AS LeastExperiencedID FROM RankedExperience GROUP BY JobDescription;

DECLARE @String VARCHAR(50) = 'tf56sd#%OqH'; SELECT STRING_AGG(CASE WHEN ASCII(SUBSTRING(@String, n, 1)) BETWEEN 65 AND 90 THEN SUBSTRING(@String, n, 1) END, '') AS Uppercase, STRING_AGG(CASE WHEN ASCII(SUBSTRING(@String, n, 1)) BETWEEN 97 AND 122 THEN SUBSTRING(@String, n, 1) END, '') AS Lowercase, STRING_AGG(CASE WHEN SUBSTRING(@String, n, 1) LIKE '[0-9]' THEN SUBSTRING(@String, n, 1) END, '') AS Numbers, STRING_AGG(CASE WHEN ASCII(SUBSTRING(@String, n, 1)) NOT BETWEEN 65 AND 90 AND ASCII(SUBSTRING(@String, n, 1)) NOT BETWEEN 97 AND 122 AND SUBSTRING(@String, n, 1) NOT LIKE '[0-9]' THEN SUBSTRING(@String, n, 1) END, '') AS Other FROM (SELECT TOP (LEN(@String)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM sys.all_objects) AS Numbers WHERE n <= LEN(@String);

SELECT StudentID, FullName, SUM(Grade) OVER (ORDER BY StudentID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeGrade FROM Students;

SELECT Equation, CASE WHEN Equation NOT LIKE '%[+-]%' THEN CAST(Equation AS INT) ELSE (SELECT SUM(CAST(value AS INT) * CASE WHEN sign = '-' THEN -1 ELSE 1 END) FROM (SELECT value, LAG(sign, 1, '+') OVER (ORDER BY (SELECT NULL)) AS sign FROM STRING_SPLIT(REPLACE(Equation, '-', '+-'), '+') WHERE value != '') AS Parsed) END AS TotalSum FROM Equations;

SELECT Birthday, STRING_AGG(StudentName, ', ') AS Students FROM Student GROUP BY Birthday HAVING COUNT(*) > 1;

SELECT CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1, CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2, SUM(Score) AS TotalScore FROM PlayerScores GROUP BY CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END, CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END;
