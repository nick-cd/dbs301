-------------------------------------------------------
-- Lab 2 Week 2 Solution files
-- Created by: Clint MacDonald
-- Sept 1, 2019
-- Purpose: Lab 2 - Week 2 DBS301
-- Description: To learn advanced use of the SELECT statement in Oracle SQL
-----------------------------------------------------------------

-- BASIC SELECT IN ORDER TO SEE THE DATA TO UNDERSTAND WHAT IT LOOKS LIKE
-- SELECT * FROM employees;
-----------------------------------------------------------------
-- Question 1
-- Display the employee id, last name and salary of employees earning in the 
-- range of $8,000 to $11,000.  
-- Sort the output by top salaries first and then by last name.
SELECT 
    employee_id AS "Emp ID", 
    last_name AS "Last Name", 
    to_char(salary, '$99,999.99') AS "Salary"
    FROM employees
    WHERE salary >= 8000 AND salary <= 11000
    ORDER BY salary DESC, last_name;
-- OR
SELECT 
    employee_id AS "Emp ID", 
    last_name AS "Last Name", 
    to_char(salary, '$99,999.99') AS "Salary"
    FROM employees
    WHERE salary BETWEEN 8000 AND 11000
    ORDER BY salary DESC, last_name;
    
-----------------------------------------------------------------
-- Question 2
-- Modify previous query (#1) so that additional condition is to display only 
-- if they work as Programmers or Sales Representatives. 
-- Use same sorting as before.

SELECT 
    employee_id AS "Emp ID", 
    last_name AS "Last Name", 
    to_char(salary, '$99,999.99') AS "Salary",
    job_id AS "Job ID"
    FROM employees
    WHERE 
        (salary >= 8000 AND salary <= 11000)
        AND
        (job_id LIKE 'SA_REP' OR job_ID LIKE 'IT_PROG')
    ORDER BY salary DESC, last_name;
    
    -- OR
    
SELECT 
    employee_id AS "Emp ID", 
    last_name AS "Last Name", 
    to_char(salary, '$99,999.99') AS "Salary",
    job_id AS "Job ID"
    FROM employees
    WHERE 
        (salary BETWEEN 8000 AND 11000)
        AND
        (job_id IN ('SA_REP', 'IT_PROG'))
    ORDER BY salary DESC, last_name;
-----------------------------------------------------------------
-- Question 3
-- The Human Resources department wants to find high salary and low salary 
-- employees. Modify previous query (#2) so that it displays the same job 
-- titles but for people who earn outside the given salary range from question 1
-- Use same sorting as before.

SELECT 
    employee_id AS "Emp ID", 
    last_name AS "Last Name", 
    to_char(salary, '$99,999.99') AS "Salary",
    job_id AS "Job ID"
    FROM employees
    WHERE 
        (salary < 8000 OR salary > 11000)
        AND
        (job_id in('SA_REP', 'IT_PROG'))
    ORDER BY salary DESC, last_name;

-----------------------------------------------------------------
-- Question 4
-- The company needs a list of long term employees, in order to give them a 
-- thank you dinner. Display the last name, job_id and salary of employees hired
-- before 2018. List the most recently hired employees first.

SELECT 
    last_name AS "Last Name", 
    to_char(salary, '$99,999.99') AS "Salary",
    job_id AS "Job Title",
    hire_date as "Started"
    FROM employees
    WHERE 
        hire_date < to_date ('2018-Jan-01', 'yyyy-mon-dd')
    ORDER BY hire_date DESC;


-----------------------------------------------------------------
-- Question 5
-- Modify previous query (#4) so that it displays only employees earning more 
-- than $11,000. List the output by job title alphabetically and then by highest
-- paid employees.
SELECT 
    last_name AS "Last Name", 
    to_char(salary,'$999,999.00') AS "Salary",
    job_id AS "Job Title",
    hire_date as "Started"
    FROM employees
    WHERE 
        (hire_date < to_date('2018-01-01','yyyy-mm-dd'))
        AND
        salary > 11000.00
    ORDER BY Job_ID, salary DESC;
    
-----------------------------------------------------------------
-- Question 6
-- Display the job titles and full names of employees whose first name contains 
-- an ‘e’ or ‘E’ anywhere. The output should look like:

SELECT 
    Job_id as "Job Title", 
    First_Name || ' ' || Last_Name AS "Full Name"
    FROM employees
    WHERE UPPER(first_name) LIKE '%E%';
-----------------------------------------------------------------
--  Job Title	Full name
--------------------------------------
--  AD_VP	    Neena Kochhar
--	    … more rows

-----------------------------------------------------------------
-- Question 7
-- Create a query to display the address of the various locations where offices are located.  Add a parameter
--      to the query such that the user can enter all, or part of, the city name and all locations from the resultant 
--      cities will be shown.
SELECT street_address, city, state_province, postal_code, country_id
    FROM locations
    WHERE upper(city) LIKE upper('%&CityName%');
 
