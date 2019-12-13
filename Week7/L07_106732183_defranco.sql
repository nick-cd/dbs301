------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Wednesday, Novmeber 6th, 2019
-- Purpose: Submission for Lab 7 for DBS301
------------------------------------------

-- Question: 1
SELECT department_id AS "DepartID"
    FROM departments
    
    MINUS

SELECT DISTINCT department_id
    FROM departments JOIN employees USING(department_id)
    WHERE upper(job_id) = 'ST_CLERK';
    
-- Question: 2
SELECT country_id AS "CountryID", 
        country_name AS "CountryName"
    FROM countries

    MINUS

SELECT country_id, country_name
    FROM locations JOIN countries USING(country_id)
        JOIN departments USING(location_id);
        

-- Question: 3
SELECT DISTINCT job_id AS "JobID", 
            department_id AS "DepartID"
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


-- Question: 4
SELECT employee_id AS "EmpID", 
        job_id AS "JobID"
    FROM job_history
    WHERE (employee_id, start_date) IN (
    
        SELECT employee_id, MIN(start_date) 
            FROM job_history
            GROUP BY employee_id

    )
    
    INTERSECT 
    
SELECT employee_id, job_id
    FROM employees;
    
-- Question: 5
SELECT last_name AS "Name", 
        NULL AS "DepartName",
        department_id AS "DepartID"
    FROM employees
    
    UNION
    
SELECT NULL, department_name, department_id
    FROM departments;
 
 
 