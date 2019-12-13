--------------------------------------------------
-- Name: Clint MacDonald
-- Id: 900******
-- Date: Sept 09, 2019
-- Purpose Week 2 - Lecture Demo DBS301
--------------------------------------------------

--quick examples

SELECT * 
    FROM employees
    WHERE salary >= 6000;
    
SELECT *
    FROM employees
    WHERE salary >= 6000
    ORDER BY salary DESC;
    
-- Select * is not usually acceptable
SELECT employee_id, first_name, last_name, job_id, salary, commission_pct
    FROM employees
    WHERE salary >= 6000
    ORDER BY salary DESC;
	-- be detailed in exactly what you want to output, optimal and efficient
    
-- aliases
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct  -- field alias
    FROM employees e   -- table alias
    WHERE salary >= 6000
    ORDER BY salary DESC;
    
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE e.salary >= 6000
    ORDER BY LastName, first_name;
	-- can use either alias in ORDER BY, but be careful of data types.
    
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE e.salary >= 6000 AND LastName = 'Fay'
    ORDER BY LastName, first_name;
    -- This cause an error as field aliases can not run in the WHERE portion of the statement (they do not exist yet)
	-- but table aliases are okay because the FROM executes before the 
    
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE e.salary >= 6000 AND Last_Name = 'Fay'  -- use the original field name here
    ORDER BY LastName, first_name;  
    
-- String based comparators
--  Case sensitivity (Never assume how the data is formatting in the database storage)  make sure it ALWAYS works
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE e.salary >= 6000 AND upper(Last_Name) = 'FAY'
    ORDER BY LastName, first_name;
    
--  = vs LIKE
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE e.salary >= 6000 AND upper(Last_Name) LIKE 'FAY'
    ORDER BY LastName, first_name;
    -- no difference YET! (LIKE simply activates the ability to use wildcards)
    
    --WILDCARDS
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE upper(Last_Name) LIKE '%G%'  -- there is a "G" somewhere in the string 
    ORDER BY LastName, first_name;

SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE upper(Last_Name) LIKE '%S'  -- ends with "S"
    ORDER BY LastName, first_name;
    
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE upper(Last_Name) LIKE 'D%'  -- Starts with "D"
    ORDER BY LastName, first_name; 
    
-- String concatenation
SELECT first_name|| ' ' || last_name AS FullName
    FROM employees
    ORDER BY last_name, first_name;
    -- note that this IS a calculated field (not just match)
    
-- list of employees hired before september 9, 2012
SELECT employee_id, first_name, last_name, hire_date, job_id
    FROM employees
    WHERE hire_date < to_date('2012-09-09', 'yyyy-mm-dd');
    
-- parameters
SELECT employee_id, first_name AS "First Name", last_name AS LastName, job_id, salary, commission_pct
    FROM employees e
    WHERE upper(Last_Name) LIKE upper('%&name%')  -- the & starts a parameter name and the text the immediately follows is the variable name.
    ORDER BY LastName, first_name;
    
	
SELECT  e.first_name AS "First",
        e.last_name AS "Last",
        e.first_name|| ' ' || e.last_name AS "Full Name"
    FROM employees e
    WHERE e.first_name || ' ' || e.last_name LIKE '%s D%'  -- full name (first name ends in "s" and last name starts with "D")  careful with case sensitivity
    ORDER BY "Last";