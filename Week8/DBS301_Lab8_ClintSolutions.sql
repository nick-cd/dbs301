-------------------------------------------------------------------------------
-- DBS301 Lab 8
-- Date: November 8th, 2018
-- Student Name: Clint MacDonald
-- Student ID: SOLUTION FILE
-------------------------------------------------------------------------------

-- Lowest salary overall
-- Q1
SELECT MIN(salary) AS LowSalary FROM employees;
-- 
SELECT first_name, last_name FROM employees
    WHERE salary = (
        SELECT MIN(salary) AS LowSalary FROM employees)
    ORDER BY last_name, first_name;
    
-- OR -- 
SELECT MIN(salary) AS LowSalary FROM employees
GROUP BY department_id;
-- 
SELECT first_name, last_name FROM employees
    WHERE salary = ANY(
        SELECT MIN(salary) AS LowSalary FROM employees
        GROUP BY department_id)
    ORDER BY last_name, first_name;
    
----------------------
-- Q2
SELECT first_name, last_name FROM employees
    WHERE (salary, department_id) IN (
        SELECT MIN(salary), department_id AS LowSalary FROM employees
        GROUP BY department_id)
    ORDER BY last_name, first_name;

-- Q3
SELECT first_name, last_name, salary + 120 AS PayAmount FROM employees
    WHERE (salary, department_id) IN (
        SELECT MIN(salary), department_id AS LowSalary FROM employees
        GROUP BY department_id)
    ORDER BY last_name, first_name;
    
-- Q4 
DROP VIEW vwAllEmps;
CREATE VIEW vwAllEmps AS
    SELECT employee_id, last_name, salary, e.department_id, 
        department_name, city, country_name
    FROM employees e LEFT JOIN departments d
        ON e.department_id = d.department_id
        LEFT JOIN locations l ON l.location_id = d.location_id
        LEFT JOIN countries c ON c.country_id = l.country_id;
SELECT * FROM vwAllEmps;

-- Q5 
-- a) 
SELECT employee_id, last_name, salary, city 
    FROM vwAllEmps;
-- b) 
SELECT SUM(salary) TotalSalary, City 
    FROM vwAllEmps
    GROUP BY City
    ORDER BY City;
-- c) 
UPDATE employees SET salary = salary + 120
    WHERE employee_id IN (
    SELECT employee_ID FROM vwAllEmps
        WHERE (salary, department_id) IN (
            SELECT MIN(salary), department_id AS LowSalary FROM employees
            GROUP BY department_id)
            );

-- d) 
INSERT INTO vwAllEmps VALUES (3245, 'MacDonald', 12000, 80, 
        'IT', 'Oshawa', 'Canada');
        -- FAILS - cannot modify more than one base table through a join view

-- e) 
DELETE FROM vwAllEmps WHERE employee_id = 144;
-- IT WORKED, WTF!

-- Q6
DROP VIEW vwAllDepts;
CREATE VIEW vwAllDepts AS
    (SELECT department_id, department_name, city, country_name
        FROM departments d LEFT JOIN locations l ON d.location_id = l.location_id
            LEFT JOIN countries c ON l.country_id = c.country_id);
SELECT * FROM vwAllDepts;

-- Q7
-- a) 
SELECT department_id, department_name, city 
    FROM vwAllDepts;
-- b) 
SELECT city, COUNT(department_id) AS NumDepts
    FROM vwAllDepts
    GROUP BY city
    ORDER BY city;
    
-- Q8
DROP VIEW vwAllDeptSumm;

CREATE VIEW vwAllDeptSumm AS
    SELECT e.department_id, department_name, 
        COUNT(employee_id) AS NumEmps, 
        (SELECT COUNT(employee_id) FROM employees WHERE commission_pct IS NULL AND department_id = e.department_id) AS NumSalaried,
        SUM(salary) AS TotSalary
    FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id
    GROUP BY e.department_id, department_name
    ORDER BY department_name;
    
    
SELECT * FROM vwAllDeptSumm;

-- Q9
-- Use the vwAllDeptSumm view to display department name and number of 
-- employees for departments that have more than the average number of employees 
SELECT department_name, numemps FROM vwAllDeptSumm
    WHERE numemps > (SELECT AVG(NumEmps) AS AvgNumEmps FROM vwAllDeptSumm);

--  Q10
GRANT READ ON employees TO <login>;
REVOKE EDIT ON departments TO <login>;
