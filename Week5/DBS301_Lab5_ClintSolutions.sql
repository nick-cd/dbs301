-------------------------------------------------------
-- Lab 5 Week 5 Solution files
-- Created by: Clint MacDonald
-- June 6, 2017
-- Purpose: Lab 5 - Week 5 DBS301
-- Description: Multiple Table Join Statements
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Question 1
-- Display the department name, city, street address and postal code for 
-- departments sorted by city and department name.

SELECT  department_name AS Department,
        city AS City,
        street_address AS Address,
        postal_code as PC
    FROM departments JOIN locations 
        ON departments.location_id = locations.location_id
    ORDER BY city, department_name;
        
-- ** OR ** --

SELECT  department_name AS Department,
        city AS City,
        street_address AS Address,
        postal_code as PC
    FROM departments JOIN locations 
        USING (location_id)
    ORDER BY city, department_name;
      
    
-----------------------------------------------------------------
-- Question 2
(
SELECT  last_name || ', ' || first_name AS Employee,
        hire_date AS Hired,
        salary AS Salary,
        department_name AS Department,
        city As City
    FROM employees JOIN 
        (departments JOIN locations USING (location_id))
        USING (department_id)
    WHERE upper(department_name) LIKE 'A%' OR upper(department_name) LIKE 'S%'
    ORDER BY department_name, Employee;

-----------------------------------------------------------------
-- Question 3
SELECT  first_name || ' ' || last_name AS "Manager",
        department_name AS "Department",
        city AS "City",
        postal_code AS "PC",
        state_province AS "State/Prov"
    FROM employees JOIN 
        (departments JOIN locations USING (location_id))
        ON departments.manager_id = employees.employee_id
    WHERE lower(state_province) IN ('washington', 'new jersey', 'ontario')
    ORDER BY city, department_name;

-----------------------------------------------------------------
-- Question 4

SELECT  emp.last_name AS "Employee",
        emp.employee_id AS "Emp#",
        mgr.last_name AS "Manager",
        mgr.employee_id AS "Mgr#"
    FROM employees emp, employees mgr 
        WHERE (mgr.employee_id = emp.manager_id);
        
        
        
        
SELECT  emp.last_name AS "Employee",
        emp.employee_id AS "Emp#",
        mgr.last_name AS "Manager",
        mgr.employee_id AS "Mgr#"
    FROM employees emp LEFT OUTER JOIN employees mgr 
        ON mgr.employee_id = emp.manager_id;
        
-----------------------------------------------------------------
-- Question 5

SELECT  department_name, city, street_address, postal_code, country_name
    FROM departments JOIN locations USING (location_id) 
        JOIN countries USING (country_id)
    ORDER BY department_name DESC;
    
-----------------------------------------------------------------
-- Question 6

SELECT  first_name || ' / ' || last_name AS Employee,
        hire_date,
        to_char(salary,'$99,999.99') AS Salary,
        department_name AS "Dept."
    FROM employees JOIN departments 
        ON employees.department_id = departments.department_id
    WHERE upper(department_name) LIKE 'A%' OR upper(department_name) LIKE 'S%'
    ORDER BY department_name, last_name;
        
-----------------------------------------------------------------
-- Question 7

SELECT  first_name || ' / ' || last_name AS Employee,
        hire_date,
        to_char(salary,'$99,999.99') AS Salary,
        department_name AS "Dept."
    FROM employees RIGHT JOIN departments 
        ON (employees.department_id = departments.department_id)
    WHERE (upper(department_name) LIKE 'A%' OR upper(department_name) LIKE 'S%')
    ORDER BY department_name, last_name;
-----------------------------------------------------------------
-- Question 8

SELECT  
    CASE departments.manager_id 
            WHEN IS NULL THEN
            ''
            ELSE 
             last_name || ', ' || first_name
            END
        AS "Manager",
        department_name AS "Dept",
        city AS "City",
        postal_code AS "PC",
        state_province AS "State/Prov."
    FROM employees RIGHT OUTER JOIN departments 
        ON departments.manager_id = employees.employee_id
        JOIN locations
            ON departments.location_id = locations.location_id
    WHERE lower(state_province) IN('ontario', 'new jersey', 'washington')
    ORDER BY city, department_name;

-----------------------------------------------------------------
-- Question 9

SELECT  last_name || ', ' || first_name AS "Manager",
        department_name AS "Dept",
        city AS "City",
        postal_code AS "PC",
        state_province AS "State/Prov."
    FROM employees, departments, locations
    WHERE (departments.manager_id = employees.employee_id)
        AND (departments.location_id = locations.location_id)
        AND (lower(state_province) IN('ontario', 'new jersey', 'washington'))
    ORDER BY city, department_name;

-----------------------------------------------------------------
-- Question 10

SELECT  department_name AS Dept,
        to_char(MAX(salary),'$999,999.99') AS "High",
        to_char(MIN(salary),'$999,999.99') AS "Low",
        to_char(ROUND(AVG(salary),2),'$999,999.99') AS "Avg"
    FROM employees e JOIN departments d
        ON e.department_id = d.department_id
    GROUP BY department_name
    ORDER BY ROUND(AVG(salary),2) DESC;
    
-----------------------------------------------------------------
-- Question 11

SELECT  emp.last_name AS "Employee",
        emp.employee_id AS "Emp#",
        mgr.last_name AS "Manager",
        mgr.employee_id AS "Mgr#"
    FROM employees emp FULL OUTER JOIN employees mgr 
        ON emp.manager_id = mgr.employee_id
        ;
        
