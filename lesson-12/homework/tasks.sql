SELECT p.firstName, p.lastName, a.city, a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId;

SELECT e.name AS Employee
FROM Employee e
INNER JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;

SELECT email AS Email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;

DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
);

SELECT DISTINCT g.ParentName
FROM girls g
LEFT JOIN boys b ON g.ParentName = b.ParentName
WHERE b.ParentName IS NULL;

SELECT c.custid, c.companyname, SUM(o.freight) AS total_sales_amount, MIN(o.shipvia) AS least_weight
FROM Sales.Orders o
INNER JOIN Sales.Customers c ON o.custid = c.custid
WHERE o.shipvia > 50
GROUP BY c.custid, c.companyname;

SELECT c1.Item AS Item_Cart_1, c2.Item AS Item_Cart_2
FROM Cart1 c1
FULL OUTER JOIN Cart2 c2 ON c1.Item = c2.Item;

SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.id IS NULL;

SELECT s.student_id, s.student_name, sub.subject_name, COUNT(e.student_id) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
