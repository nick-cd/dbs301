-------------------------------------------------------
-- Week 4 Working Demos
-- Created by: Clint MacDonald
-- Sept 23, 2019
-- Purpose: Week 4, Lesson 5 Working Demos DBS301
-- Description: Multi-Row Functions, Aggregate functions, and Grouping
-----------------------------------------------------------------

/* NEW GENERIC SYNTAX
SELECT column, group function
    FROM table
    [WHERE condition]
    [GROUP BY group by expression]
    [HAVING group condition]
    [ORDER BY column(s)];
    
     There are 7 aggregate functions
    -- AVG
    -- SUM
    -- COUNT
    -- MIN
    -- MAX
    -- STDDEV
    -- VARIANCE
    -- Aggregate functions are calculated fields, Therefore you MUST assign an alias
    */
    
-- how many countries in the database
SELECT COUNT(country_id) AS NumCountries
    FROM countries;

-- how many countries in each region
SELECT region_id, COUNT(country_id) as NumCountries
    FROM countries
    GROUP BY region_id
    ORDER BY region_id;
    
    -- LAW OF GROUPING
    -- Any field included in the SELECT statement NOT part of an aggregate function
    --    MUST be included in the GROUP BY statement.
    
-- how much money goes out for salaries per month per department
SELECT department_id, SUM(salary) AS TotSal
    FROM employees
    GROUP BY department_id;
    
-- Sportleagues examples
SELECT COUNT(playerID) AS NumPlayers
    FROM tblDatPlayers;
SELECT COUNT(teamID) AS NumTeams
    FROM tblDatTeams;
SELECT COUNT(rosterID) AS NumActivePlayers
    FROM tblJncRosters;
    
-- --------------------------
SELECT COUNT(department_ID) FROM employees;
SELECT department_id FROM employees;
SELECT DISTINCT department_id FROM employees;
SELECT DISTINCT COUNT(department_id) FROM employees;  -- wrong

SELECT COUNT(DISTINCT department_id) FROM employees;  -- yes, BUT  NULL is not included

SELECT COUNT (DISTINCT NVL(department_ID, -1)) FROM employees;

-- what is the average employee commission?
SELECT avg(commission_pct) FROM employees;  -- good but may not answer the question
SELECT avg(NVL(commission_pct,0)) FROM employees; 


-- OTHER FUNCTIONS
-- Produce a SINGLE sql statement that returns a SINGLE line result that displays 
--   the minimum, maximum, and average salaries for all employees
SELECT  min(salary) AS minSalary,
        max(salary) AS maxSalary,
        avg(salary) AS avgSalary
    FROM employees;
    
-- GROUPING BY MULTIPLE COLUMNS
-- display the average salary for employees in each job-title in each department
SELECT job_id, department_id, avg(NVL(salary,0)) AS avgSalary
    FROM employees
    GROUP BY job_id, department_id;
    
-- HAVING
-- display the average salary for emplyees in each job title in each department, 
-- but only show those where the average is over $10,000.00.
SELECT job_id, department_id, avg(NVL(salary,0)) AS avgSalary
    FROM employees
    GROUP BY job_id, department_id
    HAVING avg(NVL(salary,0)) > 10000;
    
-- HAVING and WHERE at the same time
-- repeat the previous example but only include departments 20, 60, 80 and 90
SELECT job_id, department_id, avg(NVL(salary,0)) AS avgSalary
    FROM employees
    WHERE department_id IN(20, 60, 80, 90)
    GROUP BY job_id, department_id
    HAVING avg(NVL(salary,0)) > 10000;
    
    -- NEW ORDER OF EXECUTION
/*

    FROM
    WHERE
    GROUP BY
    HAVING
    SELECT
    DISTINCT
    ORDER BY
    
    */