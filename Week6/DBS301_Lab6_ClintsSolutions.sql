-------------------------------------------------------
-- Lab 6 Week 6 Solution files
-- Created by: Clint MacDonald
-- Sept 2019
-- Purpose: Lab 6 - Week 6 DBS301
-- Description: Sub-Select
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Question 1
-- SET AUTOCOMMIT ON (do this each time you log on) so any updates, deletes and 
-- inserts are automatically committed before you exit from Oracle.

SET AUTOCOMMIT ON;

-----------------------------------------------------------------
-- Question 2
-- Create an INSERT statement to do this.  Add yourself as an employee with a 
-- NULL salary, 0.2 commission_pct, in department 90, and Manager 100.  
-- You started TODAY.  

INSERT INTO employees 
                (employee_id, first_name, last_name, email, 
                phone_number, hire_date, 
                job_id, salary, commission_pct, manager_id, department_id)
                VALUES
                (244, 'Clint', 'MacDonald', 'clint.macdonald@',
                '416.555.1212', sysdate,
                'AD_VP', null, 0.21, 100, 90);

-----------------------------------------------------------------
-- Question 3
-- Create an Update statement to: Change the salary of the employees with a 
-- last name of Matos and Whalen to be 2500.

UPDATE employees SET salary = 2500 
    WHERE last_name IN ('Matos', 'Whalen');


-----------------------------------------------------------------
-- Question 4
-- Display the last names of all employees who are in the same department as 
-- the employee named Abel.

SELECT last_name
    FROM employees
    WHERE department_id =
        (SELECT department_id FROM employees WHERE UPPER(last_name) = 'ABEL');

-----------------------------------------------------------------
-- Question 5
-- Display the last name of the lowest paid employee(s)

SELECT last_name
    FROM employees
    WHERE salary = (SELECT MIN(salary) FROM employees);

-----------------------------------------------------------------
-- Question 6
-- Display the city that the lowest paid employee(s) are located in.

SELECT DISTINCT city
    FROM locations JOIN departments 
        USING (location_id) JOIN employees 
            USING (department_id)
    WHERE salary = (SELECT MIN(salary) FROM employees);

-- without using joins at all
SELECT DISTINCT city
    FROM locations 
    WHERE location_ID IN (
        SELECT location_ID 
            FROM departments
            WHERE department_ID IN (
                SELECT department_ID 
                    FROM employees
                    WHERE salary = ( SELECT min(salary) FROM employees )
                    )
                );
-----------------------------------------------------------------
-- Question 7
-- Display the last name of the lowest paid employee(s) in each department

SELECT emp.last_name, emp.department_id, MinSalary 
    FROM employees emp, (SELECT Min(Salary) As MinSalary, department_ID 
                            FROM employees 
                            GROUP BY department_ID 
                            ORDER BY department_id) SubQuery1
    WHERE emp.department_id=SubQuery1.department_id 
        AND emp.Salary = MinSalary
        ORDER BY department_id;
    
-- The following is the previous solution for this question, however this gives an incorrect answer (Can you tell me why?)            
SELECT last_name, department_id, Salary
    FROM employees 
    WHERE Salary IN (SELECT MIN(Salary) FROM employees GROUP BY department_id)
    ORDER BY department_id, salary;


-----------------------------------------------------------------
-- Question 8
SELECT last_name, salary
  FROM employees
  WHERE salary IN
        (SELECT MIN(salary)
           FROM locations JOIN departments USING (location_id) 
                JOIN employees USING (department_id)
           GROUP BY city);
-- the above is the solution from ORACLE, but THIS IS NOT CORRECT as it does not ensure the salary is 
    -- linked to the right person in the right city, the following is a better solutions

SELECT last_name, t1.city, t1.salary
    FROM (
            SELECT last_name, city, salary
            FROM employees e JOIN departments d ON e.department_id = d.department_id 
                JOIN locations l ON l.location_id = d.location_id
        ) t1 JOIN (
        
             SELECT city, min(salary) as MinSal 
                FROM (
                        SELECT last_name, city, salary
                        FROM employees e JOIN departments d ON e.department_id = d.department_id 
                            JOIN locations l ON l.location_id = d.location_id
                )
                GROUP BY City
        
        ) t2 ON (t1.city = t2.city AND t1.salary = t2.MinSal);
        
		   
-----------------------------------------------------------------
-- Question 9
-- Display last name and salary for all employees who earn less than the 
-- lowest salary in ANY department.  Sort the output by top salaries first and 
-- then by last name.

SELECT last_name, salary
    FROM employees
    WHERE salary < ANY (
                    SELECT MIN(salary) 
                        FROM employees 
                        GROUP BY department_id)
    ORDER BY salary DESC, last_name;

-----------------------------------------------------------------
-- Question 10
-- Display last name, job title and salary for all employees whose salary 
-- matches any of the salaries from the IT Department. Do NOT use Join method.

SELECT last_name, job_id, salary
    FROM employees
    WHERE salary = ANY (
                    SELECT salary 
                        FROM employees 
                        WHERE upper(job_id= 'IT_PROG'))
    ORDER BY salary, last_name;
