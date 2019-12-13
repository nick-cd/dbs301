-------------------------------------------------------
-- Lab 1 Week 1 Solution files
-- Created by: Clint MacDonald
-- Sept 9, 2019
-- Purpose: Lab 1 - Week 1 DBS301
-- Description: To get familiarized with SQL Developer
--              and getting output from basic SQL statements
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Question 1
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM job_history;
-- employees is the longest (20 - most records)
-- employees is also the widest (11 columns)

-----------------------------------------------------------------
-- Question 2
-- the following produces errors
-- SELECT last_name "LName", job_id "Job Title", Hire Date "Job Start" 
--     FROM employees;
-- ORA-00923: FROM keyword not found where expected
-- 00923. 00000 -  "FROM keyword not found where expected"

SELECT 
    last_name AS "Last Name", 
    job_id AS "Job Title", 
    Hire_Date AS "Job Start" 
    FROM employees;
-- the correction was simply an underscore in the hire_date field

-----------------------------------------------------------------
-- Question 3
-- Three coding errors
-- SELECT employee_id, last name, commission_pct Emp Comm,
--     FROM employees;
    
-- 1 - comma at end of field list, before FROM    
-- 2 - emp comm needs an underscore or AS with quotes
-- 3 - last name needs an underscore
SELECT 
    employee_id, 
    last_name, 
    commission_pct Emp_Comm
    FROM employees;
-- OR
SELECT 
    employee_id, 
    last_name, 
    commission_pct AS "Emp Comm"
    FROM employees;
    
-----------------------------------------------------------------
-- Question 4
-- What command would show the structure of the LOCATIONS table. 

DESCRIBE locations;  -- Works in both SQL Developer and SQL*PLUS
DESC locations; -- also works but not best practices as is confused with DESC - DESCENDING (ORDER BY)

-----------------------------------------------------------------
-- Question 5 
-- Create a query to display the output shown below.
-- the following is all that was expected
SELECT 
    location_ID AS "City#", 
    City as "City", 
    state_province || ' IN THE ' || country_id AS "Province with Country Code" 
    FROM 
        locations ;
  
        
-- BONUS answer
SELECT 
    location_ID AS "City#", 
    City as "City", 
    (CASE 
        WHEN state_province IS NOT NULL 
            THEN state_province || ' IN THE ' || country_id 
        ELSE 
            country_id 
    END) AS "Province with Country Code" 
    FROM 
        locations;
        
-----------------------------------------------------------------
-- The following question is from a previous terms lab, but I leave the solution here as
-- an example to learn something from
-----------------------------------------------------------------
-- Question 6
-- Create a query to display unique (department codes and job titles) from the EMPLOYEES table.

SELECT DISTINCT department_id, job_id 
    FROM employees
    ORDER BY department_id;
-- OR
SELECT UNIQUE department_id, job_id 
    FROM employees
    ORDER BY department_id;
-- How many rows in the output 
-- A:  13

