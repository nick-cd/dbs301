-------------------------------------------------------
-- DBS301 - Assignment 1 Solution files
-- Created by: Clint MacDonald
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Question 1

SELECT  employee_id AS "Emp#", 
        SUBSTR(last_name || ', ' || first_name, 1, 25) AS "Full Name",
        job_id AS "Job",
        to_char(LAST_DAY(hire_date),'"["fmMonth ddth "of" YYYY"]"') AS "Start Date"
    FROM employees
    WHERE 
        EXTRACT(MONTH FROM hire_date) IN (05, 11) -- is May or November of any year
        AND 
        EXTRACT(YEAR FROM hire_date) NOT IN (2014, 2015)
    ORDER BY hire_date DESC;  
    
-----------------------------------------------------------------
-- Question 2
SELECT 
    'Emp# ' || employee_id || ' named ' || first_name  || ' ' ||  last_name || ' who is ' ||  
        job_id  || ' will have a new salary of $'  || 
        CASE  
            WHEN  UPPER(job_id) LIKE '%VP%' THEN round(salary*1.25)  
            ELSE  round(salary*1.18)
            END
        AS "Employees with increased pay"
    FROM employees
    WHERE salary NOT BETWEEN 5000 and 10000
            AND
            (UPPER(job_id) LIKE '%MAN%' 
                OR UPPER(job_id) LIKE '%MGR%'  
                OR UPPER(job_id) LIKE '%VP%')
ORDER BY  salary DESC , last_name;


-----------------------------------------------------------------
-- Question 3
SELECT   last_name,salary, job_id,  
     decode(e.manager_id,NULL,'NONE', e.manager_id)  "Manager#",
                 to_char(12*(salary + 1000) +12*salary* NVL(commission_pct,0),'$999,999.00') 
                  "Total Income"
FROM    employees  e  JOIN  departments  d  USING (department_id)
 WHERE  (commission_pct is null or UPPER(department_name) ='SALES')
 AND     salary*(1+ NVL(commission_pct,0)) + 1000 > 15000
 ORDER BY 5 DESC;
 
-----------------------------------------------------------------
-- Question 4
SELECT department_id, job_id, MIN(salary) "Lowest Dept/Job Pay"
FROM employees JOIN  departments
USING (department_id)
WHERE UPPER(job_id) NOT LIKE '%REP%'
AND UPPER(department_name) NOT IN ('IT','SALES')
GROUP BY  department_id, job_id 
HAVING MIN(salary) BETWEEN 6000 AND 18000
ORDER BY  department_id, job_id;

-----------------------------------------------------------------
-- Question 5
SELECT last_name, job_id, salary  
FROM   employees
WHERE  salary > ALL ( 
    SELECT MIN(salary)
    FROM   (employees e JOIN  departments d
    USING (department_id))
        JOIN locations l
        USING (location_id)
        WHERE  country_id <> 'US' 
        GROUP  BY  department_id )
AND    job_id NOT LIKE '%VP%' 
AND    job_id <> 'AD_PRES'
ORDER BY job_id;
-----------------------------------------------------------------
-- Question 6
SELECT last_name, first_name, job_id, salary
FROM employees
WHERE salary > (
    SELECT MIN(salary)
    FROM employees
    WHERE  department_id = (
        SELECT department_id
        FROM     departments
        WHERE  UPPER(department_name) = 'ACCOUNTING'
        )
    )
AND department_id IN (
    SELECT department_id
    FROM   departments
    WHERE  UPPER(department_name) IN ('IT', 'MARKETING')
    )
ORDER BY last_name;

-----------------------------------------------------------------
-- Question 7
SELECT SUBSTR(first_name || ' ' || last_name,1,25) "Employee",  job_id,
LPAD(TO_CHAR(salary,'$99,999'),15,'=') "Salary", department_id
FROM employees  JOIN  departments
USING (department_id)
WHERE UPPER(department_name) IN ('SALES','MARKETING') 
AND salary < (
    SELECT   MAX(salary)
    FROM   employees
    WHERE  upper(job_id) NOT LIKE '%PRES%'
    AND    upper(job_id) NOT LIKE '%VP%'
    AND    upper(job_id) NOT LIKE '%MAN%'
    AND    upper(job_id) NOT LIKE '%MGR%'
    )
ORDER  BY  last_name;

-----------------------------------------------------------------
-- Question 8
SELECT  d.department_name, 
    SUBSTR(NVL(l.city,'Not Assigned'),1,25) AS "City",
    COUNT(DISTINCT(job_id)) AS "# of Jobs"
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id  = d.department_id
FULL OUTER JOIN locations l
ON d.location_id = l.location_id
GROUP BY d.department_name, l.city
ORDER  BY department_name;

