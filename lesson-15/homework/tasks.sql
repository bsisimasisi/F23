SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

SELECT id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

SELECT e.id, e.name
FROM employees e
WHERE e.department_id = (SELECT id FROM departments WHERE department_name = 'Sales');

SELECT customer_id, name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

SELECT p.id, p.product_name, p.price, p.category_id
FROM products p
WHERE p.price = (SELECT MAX(price) FROM products p2 WHERE p2.category_id = p.category_id);

SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
WHERE e.department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) = (
        SELECT MAX(avg_salary)
        FROM (SELECT AVG(salary) AS avg_salary FROM employees GROUP BY department_id) AS avg_salaries
    )
);

SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

SELECT s.student_id, s.name, g.course_id, g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade = (
    SELECT MAX(grade)
    FROM grades g2
    WHERE g2.course_id = g.course_id
);

WITH RankedPrices AS (
    SELECT id, product_name, price, category_id,
           DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
    FROM products
)
SELECT id, product_name, price, category_id
FROM RankedPrices
WHERE price_rank = 3;

SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (SELECT AVG(salary) FROM employees)
AND e.salary < (
    SELECT MAX(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);
