------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Wednesday, Novmeber 13th, 2019
-- Purpose: Submission for Lab 8 for DBS301
------------------------------------------

-- Question 1:

SELECT first_name || ' ' || last_name AS "Name"
    FROM employees
    WHERE salary IN (
            
        SELECT MIN(salary) AS "Min"
            FROM employees
            WHERE department_id IS NOT NULL
            GROUP BY department_id
                
    );
    
-- Question 2:

SELECT first_name || ' ' || last_name AS "Name",
        salary AS "Salary"
    FROM employees
    WHERE (department_id, salary) IN (
    
        SELECT department_id AS "DepartID", 
                MIN(salary) AS "Min"
            FROM employees
            WHERE department_id IS NOT NULL
            GROUP BY department_id
            
    );

-- Question 3:

SELECT first_name || ' ' || last_name AS "Name", 
        salary + 120 AS "SalaryWithBonus"
    FROM employees
    WHERE (department_id, salary) IN (
    
        SELECT department_id AS "DepartID", 
                MIN(salary) AS "Min"
            FROM employees
            WHERE department_id IS NOT NULL
            GROUP BY department_id
            
    );
    
    
-- Question 4:
CREATE OR REPLACE VIEW vwAllEmps AS (

    
    SELECT employee_id, 
            last_name, 
            salary, 
            department_id,
            department_name,
            city,
            country_name
        FROM (employees LEFT JOIN departments USING(department_id))
            LEFT JOIN locations USING(location_id)
            LEFT JOIN countries USING(country_id)

);


-- Question 5:
-- a:
SELECT employee_id AS "EmpID", 
        last_name AS "LName", 
        salary AS "Salary", 
        city AS "City"
    FROM vwAllEmps;
    
-- b:
SELECT city AS "City", 
        MAX(salary) AS "MaxSal"
    FROM vwAllEmps
    WHERE city IS NOT NULL
    GROUP BY city;
    
-- c:
SELECT last_name AS "Name", 
        salary + 120 AS "SalaryWithBonus"
    FROM vwAllEmps
    WHERE (department_id, salary) IN (
    
        SELECT department_id AS "DepartID", 
                MIN(salary) AS "Min"
            FROM vwAllEmps
            WHERE department_id IS NOT NULL
            GROUP BY department_id
            
    );
    
-- d
-- This insert statment does not work
-- Attempted to insert data into more than one table

/*
INSERT INTO vwAllEmps VALUES (
    207, 'defranco', 4000, 60, 'IT', 'Southlake', 
        'United States of America'
);
*/

-- e
-- Works

DELETE FROM vwAllEmps
    WHERE upper(last_name) = 'VARGAS';

-- All employees are required for future asignments
ROLLBACK;


-- Question 6:

CREATE OR REPLACE VIEW vwAllDepts AS (

    SELECT department_id, 
            department_name, 
            city, 
            country_name
        FROM departments JOIN locations USING(location_id)
            JOIN countries USING(country_id)
        
);

-- Question 7:
-- a
SELECT department_id AS "DepartID", 
        department_name AS "DepartName", 
        city AS "City"
    FROM vwAllDepts;
    
-- b
SELECT city AS "City", 
        count(department_id) AS "Amount"
    FROM vwAllDepts
    GROUP BY city;


-- Question 8:

CREATE OR REPLACE VIEW vwAllDeptSumm AS (

    SELECT department_id, 
            department_name, 
            count(employee_id) AS "NumOfEmps", 
            count(commission_pct) AS "NumOfSalEmps", 
            NVL(sum(salary), 0) AS "TotalSalary"
        FROM employees RIGHT JOIN departments USING(department_id)
        GROUP BY department_id, department_name
        
);

-- Question 9:

SELECT department_name, "NumOfEmps"
    FROM vwAllDeptSumm
    WHERE "NumOfEmps" > (
    
        SELECT avg("NumOfEmps")
            FROM vwAllDeptSumm
    
    );
    
    
-- Question 10:

SELECT * FROM user_tab_privs;

GRANT SELECT
    ON employees
    TO dbs301_193a21;
    

GRANT SELECT, INSERT, UPDATE
    ON departments
    TO dbs301_193a21;
    

REVOKE INSERT, UPDATE
    ON departments
    FROM dbs301_193a21;
    

-- ensure all permissions are revoked
REVOKE ALL 
    ON departments 
    FROM PUBLIC;
    
REVOKE ALL 
    ON employees
    FROM PUBLIC;