------------------------------------------
-- Name: Nicholas Defranco
-- ID: 106732183
-- Date: Sunday, September 29th, 2019
-- Purpose: Lab 4 DBS301
-- Description: This lab focuses on the use of multi-line functions
--              restricting aggregate data and grouping.
------------------------------------------

-- Question 1: Shows the difference between the average salary and 
--              the lowest salary.

SELECT to_char(avg(salary) - min(salary), '$999,999.99') AS "RealAmount"
    FROM employees;
    
-- Question 2: Shows the highest salary, lowest salary, and average
--              salary for every department.

SELECT department_id AS "DepartNum", 
        to_char(max(salary), '$999,999.99') AS "Max", 
        to_char(avg(salary), '$999,999.00') AS "Avg", 
        to_char(min(salary), '$999,999.00') AS "Min"
    FROM employees
    GROUP BY department_id
    ORDER BY avg(salary) DESC;
    
-- Question 3: Shows amount of employees that have the same job in
--              the same department. 

SELECT department_id AS "Dept#", job_id AS "Job", 
        count(employee_id) AS "How Many"
    FROM employees
    GROUP BY department_id, job_id
    HAVING count(employee_id) > 1
    ORDER BY "How Many" DESC;
    
-- Question 4: Shows the total salary of employees that work 
--              the same job excluding the president and vice 
--              president jobs in the administration department.

SELECT job_id AS "Job", sum(salary) AS "TotalPaid"
    FROM employees
    WHERE job_id NOT IN('AD_PRES', 'AD_VP')
    GROUP BY job_id
    HAVING sum(salary) > 11000
    ORDER BY "TotalPaid" DESC;
    
-- Question 5: Shows how many people a particular manager is 
--              responsible for except for the managers with the
--              id 100, 101, 102. 

SELECT manager_id AS "ManagerNum", 
        count(employee_id) AS "AmountSupervised"
    FROM employees
    WHERE manager_id NOT BETWEEN 100 AND 102
    GROUP BY manager_id
    HAVING count(employee_id) > 2
    ORDER BY "AmountSupervised" DESC;
    
-- Question 6: Shows the lastest and earliest date an employee was 
--              hired for every department. (execpt for departments
--              with the id 10 or 20 or the last hire date was 
--              within this decade)

SELECT department_id AS "DepartNum", min(hire_date) AS "Earliest", 
        max(hire_date) AS "Latest"
    FROM employees
    WHERE department_id NOT IN(10, 20)
    GROUP BY department_id
    HAVING NOT (max(hire_date) >= to_date('2011-01-01', 'yyyy-mm-dd') 
        AND max(hire_date) < to_date('2021-01-01', 'yyyy-mm-dd'))
    ORDER BY "Latest" DESC;
    

SELECT  department_id AS "Dept#",
        max(hire_date) AS "Latest",
        min(hire_date) AS "Earliest"
    FROM employees
    GROUP BY department_id
    HAVING  department_id NOT IN (10, 20)
            AND
            (max(hire_date) >= to_date('01012021','mmddyyyy')
			OR max(hire_date) < to_date('12312010','mmddyyyy'))
    ORDER BY max(hire_date) DESC;
