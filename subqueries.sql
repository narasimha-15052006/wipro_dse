-- ===========================================
-- TM3_SUBQUERIES.sql
-- Oracle HR Schema - Subqueries
-- ===========================================

SET PAGESIZE 100
SET LINESIZE 200

PROMPT ===== 1. Employees with same job as Steven =====

SELECT employee_id, first_name, department_id
FROM employees
WHERE job_id = (
    SELECT job_id
    FROM employees
    WHERE first_name = 'Steven'
);

PROMPT ===== 2. Employees earning more than all department averages =====

SELECT employee_id, first_name, salary
FROM employees
WHERE salary > ALL (
    SELECT AVG(salary)
    FROM employees
    GROUP BY department_id
);

PROMPT ===== 3. Employees who are managers =====

SELECT employee_id, first_name, job_id
FROM employees
WHERE employee_id IN (
    SELECT manager_id
    FROM departments
);

PROMPT ===== 4. Employee earning minimum salary in Department 10 =====

SELECT first_name, last_name, salary, department_id
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 10
);

PROMPT ===== 5. Same department and manager as Employee 176 =====

SELECT employee_id, first_name, last_name
FROM employees
WHERE department_id = (
        SELECT department_id
        FROM employees
        WHERE employee_id = 176
      )
AND manager_id = (
        SELECT manager_id
        FROM employees
        WHERE employee_id = 176
      )
AND employee_id <> 176;

PROMPT ===== 6. Employees in departments having employee name containing R =====

SELECT employee_id,
       first_name || ' ' || last_name AS employee_name
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM employees
    WHERE LOWER(first_name || last_name) LIKE '%r%'
);

PROMPT ===== 7. Employees working in South San Francisco =====

SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location_id = (
        SELECT location_id
        FROM locations
        WHERE city = 'South San Francisco'
    )
);

PROMPT ===== 8. Employees by Location (User Input) =====

ACCEPT LOC PROMPT 'Enter Location: '

SELECT employee_id, first_name
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location_id = (
        SELECT location_id
        FROM locations
        WHERE city = '&LOC'
    )
);

PROMPT ===== 9. Employees reporting to King =====

SELECT first_name, salary
FROM employees
WHERE manager_id = (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'King'
);

PROMPT ===== 10. Employees working with James =====

SELECT *
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE first_name = 'James'
);

PROMPT ===== 11. Employees earning less than department average =====

SELECT first_name, salary, department_id
FROM employees e
WHERE salary < (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

PROMPT ===== 12. Location and Average Salary =====

SELECT city,
       (
           SELECT AVG(salary)
           FROM employees e
           JOIN departments d
             ON e.department_id = d.department_id
           WHERE d.location_id = l.location_id
       ) AS avg_salary
FROM locations l;

PROMPT ===== 13. Least 5 Salaries =====

SELECT *
FROM (
    SELECT employee_id,
           first_name,
           salary
    FROM employees
    ORDER BY salary
)
WHERE ROWNUM <= 5;

PROMPT ===== 14. Last 5 Employees =====

SELECT *
FROM (
    SELECT *
    FROM employees
    ORDER BY employee_id DESC
)
WHERE ROWNUM <= 5;

PROMPT ===== 15. Employees working in Dallas =====

SELECT *
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location_id = (
        SELECT location_id
        FROM locations
        WHERE city = 'Dallas'
    )
)
ORDER BY salary;

PROMPT ===== 16. Employees below Department Average =====

SELECT e.first_name,
       e.salary,
       v.avg_sal
FROM employees e
JOIN (
    SELECT department_id,
           AVG(salary) avg_sal
    FROM employees
    GROUP BY department_id
) v
ON e.department_id = v.department_id
WHERE e.salary < v.avg_sal;

PROMPT ===== 17. WITH Clause =====

WITH dept_sal AS (
    SELECT d.location_id,
           SUM(e.salary) total_sal
    FROM departments d
    JOIN employees e
      ON d.department_id = e.department_id
    GROUP BY d.location_id
)
SELECT *
FROM dept_sal;