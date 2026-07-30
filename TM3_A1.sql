

SELECT EMPNO, ENAME, DEPTNO
FROM EMP
WHERE DEPTNO = (
    SELECT DEPTNO
    FROM EMP
    WHERE ENAME = UPPER('&ENAME')
)
AND ENAME <> UPPER('&ENAME');



-- Q2. Display employees who earn more than the average salary of EMP table.

SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE SAL > (
    SELECT AVG(SAL)
    FROM EMP
);



-- Q3. Display ENAME, JOB who are Managers (EXISTS Operator).

SELECT E.ENAME, E.JOB
FROM EMP E
WHERE EXISTS (
    SELECT *
    FROM EMP
    WHERE MGR = E.EMPNO
);



-- Q4. Display employees who earn less than the least salary of DEPTNO 10 (ALL Operator).

SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE SAL < ALL (
    SELECT SAL
    FROM EMP
    WHERE DEPTNO = 10
);



-- Q5. Display employees who have the same DEPTNO and MGR of a given employee,
-- excluding that employee.

SELECT EMPNO, ENAME, DEPTNO, MGR
FROM EMP
WHERE (DEPTNO, MGR) = (
    SELECT DEPTNO, MGR
    FROM EMP
    WHERE ENAME = UPPER('&ENAME')
)
AND ENAME <> UPPER('&ENAME');



-- Q6. Display employee number and name of all employees who work in a
-- department with any employee whose name contains 'R'.

SELECT EMPNO, ENAME
FROM EMP
WHERE DEPTNO IN (
    SELECT DEPTNO
    FROM EMP
    WHERE ENAME LIKE '%R%'
);



-- Q7. Display ENAME, DEPTNO, JOB of employees working in NEW YORK.

SELECT ENAME, DEPTNO, JOB
FROM EMP
WHERE DEPTNO = (
    SELECT DEPTNO
    FROM DEPT
    WHERE LOC = 'NEW YORK'
);



-- Q8. Modify the above query so that the user is prompted for a location.

SELECT ENAME, DEPTNO, JOB
FROM EMP
WHERE DEPTNO = (
    SELECT DEPTNO
    FROM DEPT
    WHERE LOC = UPPER('&LOC')
);



-- Q9. Display the name and salary of every employee who reports to KING.

SELECT ENAME, SAL
FROM EMP
WHERE MGR = (
    SELECT EMPNO
    FROM EMP
    WHERE ENAME = 'KING'
);



-- Q10. Display all employees working with JAMES.

SELECT EMPNO, ENAME, DEPTNO
FROM EMP
WHERE DEPTNO = (
    SELECT DEPTNO
    FROM EMP
    WHERE ENAME = 'JAMES'
)
AND ENAME <> 'JAMES';



-- Q11. Display employees who earn less than the average salary of
-- their respective departments (Correlated Subquery).

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP E
WHERE SAL < (
    SELECT AVG(SAL)
    FROM EMP
    WHERE DEPTNO = E.DEPTNO
);



-- Q12. Display the location and average salary of each location
-- (Scalar Subquery).

SELECT D.LOC,
(
    SELECT AVG(SAL)
    FROM EMP E
    WHERE E.DEPTNO = D.DEPTNO
) AS AVG_SALARY
FROM DEPT D;



-- Q13. Display the least N salaries (Inline View).

SELECT *
FROM (
    SELECT EMPNO, ENAME, SAL
    FROM EMP
    ORDER BY SAL
)
WHERE ROWNUM <= &N;



-- Q14. Display the last N rows from EMP table
-- (Correlated Subquery).

SELECT *
FROM EMP E1
WHERE &N >
(
    SELECT COUNT(*)
    FROM EMP E2
    WHERE E2.EMPNO > E1.EMPNO
)
ORDER BY EMPNO;



-- Q15. Display employees and sort only employees working in DALLAS.

SELECT E.EMPNO,
       E.ENAME,
       D.LOC
FROM EMP E
JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
ORDER BY CASE
    WHEN D.LOC = 'DALLAS' THEN E.ENAME
END,
E.EMPNO;



-- Q16. Display employees who earn less than the average salary of their
-- department and also display the average salary (Inline View).

SELECT E.EMPNO,
       E.ENAME,
       E.SAL,
       A.AVGSAL
FROM EMP E,
(
    SELECT DEPTNO,
           AVG(SAL) AVGSAL
    FROM EMP
    GROUP BY DEPTNO
) A
WHERE E.DEPTNO = A.DEPTNO
AND E.SAL < A.AVGSAL;

-- ===================== END OF TM3_A1 =====================