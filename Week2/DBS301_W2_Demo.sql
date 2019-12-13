-- Week 2 Lecture Notes
-- Generic SELECT Syntax to this point

-- SELECT <FieldList comma separated>
--     FROM <tablename>
--     WHERE <one or more conditions>
--     ORDER BY <field list, comma separated, ASC, DESC>


-- Generic
SELECT *
    FROM employees
    WHERE salary >= 6000;
    -- improve through analyzing the question
SELECT *
    FROM employees
    WHERE salary >= 6000
    ORDER BY salary DESC;  

-- SELECT * is not usually acceptable, so explicitly declare fields
SELECT first_name, last_name, hire_date, job_id, salary, commission_pct, department_id
    FROM employees
    WHERE salary >= 6000
    ORDER BY salary DESC;  
    
-- String based conditions
SELECT employee_id, first_name, last_name, job_id
    FROM employees
    WHERE last_name = 'Fay';

-- let's test
UPDATE employees 
    SET last_name = 'Fay' 
    WHERE employee_id = 202;
-- oop's now previous SELECT does not work.... case sensitivity
SELECT employee_id, first_name, last_name, job_id
    FROM employees
    WHERE upper(last_name) = upper('FAY');
    
    -- OR
SELECT employee_id, first_name, last_name, job_id
    FROM employees
    WHERE lower(last_name) = 'fay';
    
-- String Concatenation
SELECT first_name || ' ' || last_name AS "Full Name"
    FROM emlpoyees
    ORDER BY last_name;
    
-- ORDER by Multiple Rows
SELECT first_name, last_name
    FROM employees
    ORDER BY last_name, first_name;
      -- second sort only happens if first has duplicates (case sensitive)
      
-- Wildcards
-- lost soccer ball with initials C.T.
SELECT  first_name,
        last_name,
        phone_number
    FROM employees
    WHERE upper(first_name) LIKE 'C%' AND upper(last_name) LIKE 'U%';
    
-- find a coat owner whose name contains "rt"
SELECT first_name, last_name, email
    FROM employees
    WHERE lower(first_name) LIKE '%rt%' OR lower(last_name) LIKE '%rt%';

-- Dates
-- list employees whom have worked for the company since before 2010
SELECT employee_id, first_name, last_name, hire_date, job_id
    FROM employees
    WHERE hire_date < to_date('2010-01-01', 'yyyy-dd-mm');
    
-- Aliases
SELECT  first_name AS "First",
        last_name AS "Last",
        first_name || ' ' || last_name AS "Full Name"
    FROM employees
    ORDER BY last_name;
    
-- use aliases in different ways
SELECT  first_name AS "First",
        last_name AS "Last",
        first_name || ' ' || last_name AS "Full Name"
    FROM employees
    WHERE "First" LIKE 'C%'
    ORDER BY "Last";
-- error

-- ORDER OF PRECENDENCE
  -- 1) FROM
  -- 2) WHERE
  -- 3) SELECT
  -- 4) ORDER BY
-- therefore alias used in WHERE clause does not yet exist, because SELECT has not run yet

SELECT  first_name AS "First",
        last_name AS "Last",
        first_name || ' ' || last_name AS "Full Name"
    FROM employees
    WHERE first_name LIKE 'C%'
    ORDER BY "Last";

-- but what if i want to use full name
SELECT  first_name AS "First",
        last_name AS "Last",
        first_name || ' ' || last_name AS "Full Name"
    FROM employees
    WHERE first_name || ' ' || last_name LIKE '%s D%'
    ORDER BY "Last";
    
-- one more kind of alias
-- table alias
SELECT  e.first_name AS "First",
        e.last_name AS "Last",
        e.first_name || ' ' || e.last_name AS "Full Name"
    FROM employees e
    WHERE e.first_name || ' ' || e.last_name LIKE '%s D%'
    ORDER BY "Last";