-------------------------------------------------------
-- Lab 4 Week 4 Solution files
-----------------------------------------------------------------
-- Question 1
SELECT 
    to_char(round(avg(salary) - min(salary),2), '$99,999.99') AS "Real Amount" 
    FROM employees;
-----------------------------------------------------------------
-- Question 2
SELECT  department_ID AS "Dept ID",
        to_char(max(salary), '$99,999.99') AS "High",
        to_char(min(salary), '$99,999.99') AS "Low",
        to_char(round(avg(salary),2), '$99,999.99') AS "Avg"
    FROM employees
    GROUP BY department_id
    ORDER BY round(avg(salary),2) DESC;  
	-- note, do not sort using the alias as it is now a string

-----------------------------------------------------------------
-- Question 3
SELECT  department_id AS "Dept#",
        job_id AS "Job",
        count(employee_id) AS "How Many"
    FROM employees
    GROUP BY department_id, job_id
	HAVING Count(employee_id) > 1
    ORDER BY "How Many" DESC;
-----------------------------------------------------------------
-- Question 4
SELECT  job_id as "Job",
        SUM(salary) AS "Amount Paid"
    FROM employees
    GROUP BY job_id
    HAVING  job_id NOT IN ('AD_PRES','AD_VP')
            AND SUM(salary) > 11000
    ORDER BY "Amount Paid" DESC;
-----------------------------------------------------------------
-- Question 5
SELECT  manager_id AS "Manager",
        count(employee_id) AS "Employees"
    FROM employees
    GROUP BY manager_id
    HAVING 
        manager_id NOT IN (100,101,102)
        AND count(employee_id) > 2
    ORDER BY "Employees" DESC;
-----------------------------------------------------------------
-- Question 6
SELECT  department_id AS "Dept#",
        max(hire_date) AS "Latest",
        min(hire_date) AS "Earliest"
    FROM employees
    GROUP BY department_id
    HAVING  department_id NOT IN (10, 20)
            AND
            max(hire_date) > to_date('01012021','mmddyyyy')
			AND max(hire_date) < to_date('12312010','mmddyyyy')
    ORDER BY max(hire_date) DESC;
