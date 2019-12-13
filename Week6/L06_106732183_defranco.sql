------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Sunday, October 13th, 2019
-- Purpose: Submission for Lab 6 for DBS301
------------------------------------------

-- Question 1:
SET AUTOCOMMIT ON;


-- Question 2:
INSERT INTO employees VALUES
    (207, 'Nicholas', 'Defranco', 'ndefranco@myseneca.ca',
    NULL, sysdate, 'IT_PROG', NULL, 0.21, 100, 90);


-- Question 3:
UPDATE employees
    SET salary = 2500
    WHERE upper(last_name) IN ('MATOS', 'WHALEN');
    
    
-- Question 4:
SELECT last_name AS "LName"
    FROM employees
    WHERE department_id IN (
    
            SELECT department_id AS "DepartID"
                FROM employees
                WHERE upper(last_name) = 'ABEL'
                
    );
        
-- Question 5:
SELECT last_name AS "LName"
    FROM employees
    WHERE salary = (
    
            SELECT min(salary) AS "Min"
                FROM employees
                
    );
        
-- Question 6:   
SELECT city AS "City"
    FROM locations
    WHERE location_id IN (
    
        SELECT location_id AS "Location"
            FROM departments
            WHERE department_id IN (
            
                SELECT DISTINCT department_id AS "DepartID"
                        FROM employees
                        WHERE salary = (
                        
                            SELECT min(salary) AS "Min"
                                FROM employees
                                
                        )
            )
    );                             
                                
-- Question 7:
SELECT last_name AS "LName", 
        department_id AS "DepartID", 
        salary AS "Salary"
    FROM employees
    WHERE (department_id, salary) IN (
    
        SELECT department_id AS "DepartID", 
                min(salary) AS "Min"
            FROM employees
            GROUP BY department_id
        
    )
    ORDER BY department_id;
    
    

-- Question 8:
SELECT last_name AS "LName"
    FROM (employees JOIN departments USING(department_id))
        JOIN locations USING(location_id)
    WHERE (city, salary) IN (
    
        SELECT city AS "City", 
                min(salary) AS "Min"
            FROM (employees JOIN departments USING(department_id))
                JOIN locations USING(location_id)
            GROUP BY city
            
    );
 
-- Question 9:
SELECT last_name AS "LName", 
        salary AS "Salary"
    FROM employees
    WHERE salary < ANY(
    
        SELECT min(salary) AS "Min"
            FROM employees
            GROUP BY department_id
            
    )
    ORDER BY salary DESC, last_name;
    

-- Question 10:   
SELECT last_name AS "LName", 
        job_id AS "JobTitle", 
        salary AS "Salary"
    FROM employees
    WHERE salary IN (
    
        SELECT salary AS "Salary"
            FROM employees
            WHERE department_id IN (
            
                    SELECT department_id AS "DepartID"
                        FROM departments
                        WHERE upper(department_name) = 'IT'
            
            )
                       
     ) AND department_id NOT IN (
     
        SELECT department_id AS "DepartID"
            FROM departments
            WHERE upper(department_name) = 'IT'
            
     )
     ORDER BY salary, last_name;

SELECT last_name, job_id, salary
    FROM employees
    WHERE salary = ANY (
                    SELECT salary 
                        FROM employees 
                        WHERE upper(job_id)= 'IT_PROG')
    ORDER BY salary, last_name;


