-------------------------------------------------------
-- Week 3 Working Demos
-- Created by: Clint MacDonald
-- September 16, 2019
-- Purpose: Week 3, Lesson 3 Working Demos DBS301
-- Description: Using Single-Line Functions in SELECT statements
-- 				in addition to more string and date formatting
-----------------------------------------------------------------

-- From week 2
-- list all countries that start with "C"
SELECT * FROM countries WHERE upper(country_name) LIKE 'C%';

-- but what if I want to use a different letter, without making 26 SQL statements
-- introduce a PARAMETER
SELECT * FROM countries WHERE upper(country_name) LIKE upper('&EnterLetter%');

-- let's optimize the country_name field by setting it to the perfect length (size)
SELECT country_name, length(country_name) AS NameLen
    FROM countries
    WHERE rownum = 1
    ORDER BY NameLen DESC;  -- returns the wrong result
    
-- just for fun, let's play with the replace function
-- replace all a's in countries with o's.
SELECT country_name, replace(country_name, 'a', 'o') AS "The new world order"
    FROM countries
    ORDER BY country_name;
    
-- straight up calculated fields
SELECT  last_name, first_name,
        salary AS "Old Salary",
        salary + 200 AS "New Salary"
    FROM employees;

-- relative math
SELECT  last_name, first_name,
        salary AS "Old Salary",
        salary * 1.2 AS "New Salary"
    FROM employees;

-- DATES
-- get today's date
SELECT sysdate FROM dual;
SELECT * FROM dual;

SELECT sysdate - 43 FROM dual;


-- list all employees hired in 2019
SELECT * FROM employees
    WHERE hire_date >= to_date('01012019', 'mmddyyyy') AND hire_date < to_date('01012020','mmddyyyy');

SELECT * FROM employees
    WHERE hire_date BETWEEN to_date('01012019', 'mmddyyyy') AND to_date('01012020','mmddyyyy');
    -- are the dates inclusive or exclusive and consider time of day !!!
    
-- extract
SELECT * FROM employees 
    WHERE extract(year FROM hire_date) = 2019;

-- what is the date on saturday
SELECT next_day(sysdate, 'Saturday') AS "Next Sat"
    FROM dual;
    -- the next next sat
SELECT next_day(sysdate+7, 'Saturday') AS "Next Sat"
    FROM dual;

SELECT next_day(sysdate + (7 * (&NumWeeks - 1)), 'Saturday') AS "Next Sat"
    FROM dual;
    
-- formatting
SELECT to_char(sysdate, 'Month ddth, yyyy') AS "date" FROM dual;

-- make it look like   Jan the 22 of 2019
SELECT to_char(sysdate, 'Mon" the "dd" of "yyyy') FROM dual;

-- odd spacing
SELECT to_char(sysdate, 'Month ddth, yyyy') AS "date" FROM dual;
SELECT to_char(to_date('05052019', 'mmddyyyy'), 'Month dd, yyyy') AS "date" FROM dual;
SELECT to_char(to_date('05052019', 'mmddyyyy'), 'fmMonth dd, yyyy') AS "date" FROM dual;

-- spell day in text
SELECT to_char(to_date('05052019', 'mmddyyyy'), 'fmMonth ddsp, yyyy') AS "date" FROM dual;

