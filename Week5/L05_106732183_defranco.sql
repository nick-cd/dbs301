------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Sunday, October 6th, 2019
-- Purpose: Submission for Lab 5 for DBS301
------------------------------------------

-- Question 1: Display each department showing the name of 
-- the department, the city it's located in, address, and 
-- postal code

SELECT department_name AS "DepartName", 
        city AS "City", 
        street_address AS "Addr", 
        postal_code AS "PostalCode"
    FROM departments d, locations l
    WHERE d.location_id = l.location_id 
    ORDER BY city, department_name;
    
-- Question 2: Display employee information that includes
-- their name, the date when they were hired, their salary,
-- the department they are in, and the city the department
-- is located in

SELECT last_name || ', ' || first_name AS "FName",
        hire_date AS "HireDate", 
        salary AS "Salary",
        department_name AS "DepartName", 
        city AS "City"
    FROM employees e, departments d, locations l
    WHERE (upper(department_name) LIKE 'A%'
        OR upper(department_name) LIKE 'S%')
        AND e.department_id = d.department_id
        AND d.location_id = l.location_id
    ORDER BY department_name, "FName";
    
-- Question 3: Display manager information for managers
-- that work in Ontario, New Jersey, or Washington

SELECT last_name || ', ' || first_name AS "FName",
        department_name AS "DepartName", 
        city AS "City", 
        postal_code AS "PostalCode", 
        state_province AS "StateProvince"
    FROM employees e, departments d, locations l
    WHERE (upper(state_province) IN ('ONTARIO', 'NEW JERSEY', 'WASHINGTON'))
        AND (e.employee_id = d.manager_id
        AND d.location_id = l.location_id)
    ORDER BY city, department_name;
    
-- Question 4: Display a list of all employees with
-- the name of their manager (this query excludes employees
-- with no manager)


SELECT  emp.last_name AS "Employee",
        emp.employee_id AS "Emp#",
        mgr.last_name AS "Manager",
        mgr.employee_id AS "Mgr#"
    FROM employees emp, employees mgr 
        WHERE (mgr.employee_id = emp.manager_id)
        
MINUS
        

SELECT e2.last_name AS "Employee", 
        e2.employee_id AS "Emp#", 
        e.last_name AS "Manager", 
        e.employee_id AS "Mgr#"
    FROM employees e, employees e2
    WHERE e.employee_id = e2.manager_id;
    
-- Question 5: Display each department showing the name of 
-- the department, the city it's located in, address, and 
-- postal code 

SELECT department_name AS "DepartName", 
        city AS "City", 
        street_address AS "StreetAddr", 
        postal_code AS "PostalCode",
        country_id AS "CountryName"
    FROM locations JOIN departments 
        USING (location_id)
    ORDER BY department_name DESC;
    
-- Question 6: Display employee information that includes
-- their name, the date when they were hired, their salary,
-- and the department they are in.

SELECT first_name || ' / ' || last_name AS "FName",
        hire_date AS "HireDate", 
        salary AS "Salary",
        department_name AS "DepartName"
    FROM employees e FULL JOIN departments d
        ON e.department_id = d.department_id
    WHERE department_name LIKE 'A%'
        OR department_name LIKE 'S%'
    ORDER BY department_name, last_name;
    
    
-- Question 7: Display manager information for managers
-- that work in Ontario, New Jersey, or Washington

SELECT last_name || ', ' || first_name AS "FName",
        department_name AS "DepartName", 
        city AS "City", 
        postal_code AS "PostalCode", 
        state_province AS "StateProvince"
    FROM (employees e RIGHT JOIN departments d ON e.employee_id = d.manager_id) 
        FULL JOIN locations l ON l.location_id = d.location_id
    WHERE (upper(state_province) IN ('ONTARIO', 'NEW JERSEY', 'WASHINGTON'))
    ORDER BY city, department_name;
    
-- Question 8: Display the largest, smallest and average
-- salary for each department.

SELECT department_name AS "DepartName", 
        max(salary) AS "High", 
        avg(salary) AS "Avg",
        min(salary) AS "Low"
    FROM employees e RIGHT JOIN departments d
        ON e.department_id = d.department_id
    GROUP BY department_name
    ORDER BY avg(salary) DESC;
    
-- Question 9: Display a list of all employees with
-- the name of their manager (this query excludes employees
-- with no manager)

SELECT e2.last_name AS "Employee", 
        e2.employee_id AS "Emp#", 
        e.last_name AS "Manager", 
        e.employee_id AS "Mgr#"
    FROM employees e FULL JOIN employees e2
        ON e.employee_id = e2.manager_id;
