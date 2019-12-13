------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Sunday, September 15th, 2019
-- Purpose: Submission for Lab 2 for DBS301
-- Description: This lab focuses on various kinds of conditions 
--              for the WHERE clause as well as sorting data. 
------------------------------------------

------------------------------------------
-- Question 1: Display the employee_id, last name and salary 
--              salary must be between $8,000 to $11,000 inclusive.
--              sort salary descending and then by last_name 

SELECT employee_id AS "EmpID", last_name AS "LName", 
        to_char(salary, '$999,999.99') AS "Salary"
    FROM employees
    WHERE salary BETWEEN 8000 AND 11000
    ORDER BY salary DESC, last_name;

------------------------------------------  
-- Question 2: Added another condition checking not only if they 
--             earn in the range but also if they belong to certain 
--             postions.

SELECT employee_id AS "EmpID", last_name AS "LName", 
        job_id AS "JobTitle",
        to_char(salary, '$999,999.99') AS "Salary"
    FROM employees
    WHERE (salary BETWEEN 8000 AND 11000) 
        AND (upper(JOB_ID) IN ('IT_PROG', 'SA_REP')) 
    ORDER BY salary DESC, last_name;

------------------------------------------
-- Question 3: Same statment as before but people outside the
--             range for salary were needed.

SELECT employee_id AS "EmpID", last_name AS "LName", 
        job_id AS "JobTitle",
        to_char(salary, '$999,999.99') AS "Salary"
    FROM employees
    WHERE (salary NOT BETWEEN 8000 AND 11000) 
        AND (upper(job_id) IN ('IT_PROG', 'SA_REP')) 
    ORDER BY salary DESC, last_name;

------------------------------------------    
-- Question 4: Display only the employees that were hired before 2018
--             and have them in descending order

SELECT last_name AS "LName", job_id AS "JobTitle", 
        hire_date AS "HireDate",
        to_char(salary, '$999,999.99') AS "Salary"
    FROM employees
    WHERE hire_date <= to_date('2017-12-31', 'yyyy-mm-dd')
    ORDER BY hire_date DESC;
    
------------------------------------------
-- Question 5: Additional condition from question 4 to check if 
--             the employee earns more than $11,000 and sort by 
--             the job name and then salary descending 

SELECT last_name AS "LName", job_id AS "JobTitle",
        to_char(salary, '$999,999.99') AS "Salary"
    FROM employees
    WHERE hire_date <= to_date('2017-12-31', 'yyyy-mm-dd')
        AND salary > 11000
    ORDER BY job_id, salary DESC;
    
------------------------------------------
-- Question 6: Display all employees with the letter 'e' in their
--             name regardless of case.

SELECT job_id AS "JobTitle", 
        first_name || ' ' || last_name AS "FullName"
    FROM employees
    WHERE upper(first_name) LIKE '%E%';
    
------------------------------------------
-- Question 7: User will enter a city, then it will produce a 
--             list of matching cities given the string with 
--             its corresponding office location

SELECT street_address AS "Address", city AS "City", 
        state_province AS "Province", postal_code AS "PostalCode", 
        country_id AS "Country"
    FROM locations
    WHERE upper(city) LIKE upper('%&city%');
