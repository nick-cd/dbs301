-- ************************
-- DBS301 - Lab 7 
-- Clint MacDonald
-- Nov 14, 2018
-- ************************

-- Q1
SELECT department_id FROM departments 
MINUS
SELECT department_id FROM employees
    WHERE UPPER(job_id) = 'ST_CLERK';


SELECT DISTINCT department_id FROM employees
    WHERE UPPER(job_id) != 'ST_CLERK'
    ORDER BY department_id;
-- Q2
SELECT country_id, country_name FROM countries
MINUS
SELECT l.country_id, c.country_name
    FROM locations l JOIN countries c
    ON l.country_id = c.country_id
        JOIN departments d
        ON l.location_id = d.location_id;

-- Q3
SELECT DISTINCT job_id, department_id
    FROM employees
    WHERE department_id = 10
UNION ALL
SELECT DISTINCT job_id, department_id
    FROM employees
    WHERE department_id = 50
UNION ALL
SELECT DISTINCT job_id, department_id
    FROM employees
    WHERE department_id = 20;
    
-- OR

SELECT job_id, department_ID, 1 AS OrderBY
	FROM employees
	WHERE department_id = 10
UNION
SELECT job_id, department_ID, 2 AS OrderBY
	FROM employees
	WHERE department_id = 50
UNION
SELECT job_id, department_ID, 3 AS OrderBY
	FROM employees
	WHERE department_id = 20
	
ORDER BY OrderBY;

-- OR But not using SET OPERATORS

SELECT 
	job_id, 
	department_ID, 
	CASE 
		WHEN department_id = 10 THEN 1
		WHEN department_id = 50 THEN 2
		WHEN department_id = 20 THEN 3
		END AS Ordering
	FROM employees
	WHERE department_id IN (10, 20, 50)
	ORDER BY Ordering;
	
	
-- Q4
SELECT employee_id, job_id FROM employees
INTERSECT
SELECT employee_id, job_id FROM job_history WHERE (employee_id, start_date) IN (
SELECT employee_id, MIN(Start_date) as DT FROM job_history
 GROUP BY employee_id);

SELECT employee_id, job_id FROM (
SELECT employee_id, hire_date, job_id FROM employees
INTERSECT
SELECT employee_id, start_date, job_id FROM job_history);


-- Q5 
SELECT last_name, department_id, to_char(NULL) As Dept
    FROM employees
UNION
SELECT to_char(NULL), department_id, department_name
    FROM departments;