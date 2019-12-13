-- ***********************
-- Name: Nicholas Defranco, Alex Hai, Viet Nguyen
-- ID: 106732183. 140230186, 139335178
-- Date: Friday, October 18th, 2019
-- Purpose: Assignment 1 - DBS301
-- ***********************

-- Question 1:    

SELECT employee_id AS "EmpNum", 
        rpad(first_name || ', ' || last_name, 25, ' ') AS "FullName", 
        job_id AS "Job", 
        to_char(last_day(hire_date), '[fmMonth ddTH "of" yyyy]') AS "HireDate"
    FROM employees
    WHERE extract(YEAR FROM hire_date) NOT IN (2015, 2016)
        AND extract(MONTH FROM hire_date) IN (5, 11)
    ORDER BY hire_date DESC;


-- Question 2:

SELECT 'Emp# ' || employee_id || ' named ' || 
        first_name || ', ' || last_name || ' who is ' || 
        job_id || ' will have a new salary of $' 
        || decode(upper(substr(job_id, (instr(job_id, '_') + 1))), 'VP', round(salary * 1.25), 
        'MAN', round(salary * 1.18), 'MGR', round(salary * 1.18)) AS "Employees with increased pay"
    FROM employees
    WHERE (salary NOT BETWEEN 6000 AND 11000)
        AND (upper(job_id) LIKE '%VP' 
        OR upper(job_id) LIKE '%MAN' 
        OR upper(job_id) LIKE '%MGR')
    ORDER BY salary DESC;
        
        
-- Question 3:

    SELECT last_name AS "LName", 
        salary AS "MonthlySalary", 
        job_id AS "Job",
        department_id AS "DepartID",
        NVL(to_char(manager_id, '999'), 'NONE') AS "Manager#",
        to_char(((salary * (1 + NVL(commission_pct, 0))) + 1000) * 12, '$999,999.99') AS "TotalIncome"
    FROM employees
    WHERE (commission_pct IS NULL
        OR department_id IN (
        
            SELECT department_id AS "DepartID"
                FROM departments
                WHERE upper(department_name) = 'SALES'
            
        ))             
        AND ((salary * (1 + NVL(commission_pct, 0))) + 1000) > 15000
        ORDER BY ((salary * (1 + NVL(commission_pct, 0))) + 1000) DESC;

    
-- Question 4:

SELECT department_id AS "DepartID", 
        job_id AS "JobID", 
        min(salary) AS "LowestDept/JobPay"
    FROM employees
    WHERE upper(job_id) NOT LIKE 'SA%' 
        AND upper(job_id) NOT LIKE '%REP'
        AND upper(job_id) NOT LIKE 'IT%'
    GROUP BY department_id, job_id
    HAVING min(salary) BETWEEN 6000 AND 17000
    ORDER BY department_id, job_id;


-- Question 5:

SELECT last_name AS "LName", 
        salary AS "Salary", 
        job_id AS "Job"
    FROM employees
    WHERE upper(job_id) NOT LIKE '%VP'
        AND upper(job_id) NOT LIKE '%PRES'
        AND salary > ALL (
        
            SELECT min(salary) AS "Min"
                FROM departments d 
                    JOIN employees e 
                    ON e.department_id = d.department_id
                WHERE location_id IN (
                    
                    SELECT location_id AS "LocationID"
                        FROM locations
                        WHERE upper(country_id) != 'US'
                                
                )
                GROUP BY d.department_id
                    
        )
    ORDER BY job_id;
    
    
-- Question 6:
    
SELECT last_name AS "LName", 
        salary AS "Salary", 
        job_id AS "Job"
    FROM employees
    WHERE department_id IN (
    
            SELECT department_id AS "DepartID"
                FROM departments
                WHERE upper(department_name) IN ('IT', 'MARKETING')
    
    )   AND salary > (
        
            SELECT min(salary) AS "Min"
                FROM employees
                WHERE upper(job_id) LIKE 'AC%'
                
    )
    ORDER BY last_name;
    
    
-- Question 7:

SELECT rpad(first_name || ' ' || last_name, 25, ' ') AS "Employee",
        job_id AS "Job",
        lpad(to_char(salary, '$999,999'), 15, '=') AS "Salary",
        department_id AS "DepartID"
    FROM employees 
    WHERE department_id IN (
    
            SELECT department_id AS "DepartID"
                FROM departments
                WHERE upper(department_name) IN ('SALES', 'MARKETING')
    
        ) AND salary < (
    
            SELECT max(salary) AS "Max"
                FROM employees
                WHERE upper(job_id) NOT LIKE '%PRES'
                    AND upper(job_id) NOT LIKE '%MAN'
                    AND upper(job_id) NOT LIKE '%MGR'
                    AND upper(job_id) NOT LIKE '%VP'
                    
        )
    ORDER BY "Employee";
    
    
-- Question 8:

SELECT department_name AS "DepartName",
        rpad(NVL(city, 'Not Assigned Yet'), 24, ' ') AS "City", 
        count(DISTINCT job_id) AS "# Of Jobs"
    FROM (departments d RIGHT OUTER JOIN employees e 
        ON e.department_id = d.department_id)
        FULL OUTER JOIN locations l ON l.location_id = d.location_id
    GROUP BY department_name, rpad(NVL(city, 'Not Assigned Yet'), 24, ' ')
    ORDER BY rpad(NVL(city, 'Not Assigned Yet'), 24, ' ');
