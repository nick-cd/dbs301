------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Sunday, September 22nd, 2019
-- Purpose: Submission for Lab 3 for DBS301
-- Description: This lab focuses on the use of 
--              single-row functions in various 
--              clauses within the SELECT statement
------------------------------------------


-- Question 1: Display tommorow's date in specified format

SELECT to_char(sysdate + 1, 'fmMonth ddTH "of year" yyyy') AS "Tommorow"
    FROM dual;


-- Question 1 bonus: Define a variable called tommorow and use it 
--                      in a statment     


SET SERVEROUTPUT ON;
  
DECLARE
    tommorow DATE := sysdate + 1;
    
BEGIN
        
    dbms_output.put_line('Tommorow is ' || to_char(tommorow, 'fmMonth ddTH "of year" yyyy'));   
        
END;
/

SET SERVEROUTPUT OFF;
    

-- Question 2: Display employees in departments 20, 50, 60. Calculate
--              salary increase for each of these employees.
--              Display as a whole number. (ceil was used as
--              employees are never paid below what they are owed)

SELECT department_id AS "departID", last_name AS "LName", 
        first_name AS "FName", ceil(salary) AS "Salary", 
        ceil(salary * 1.04) AS "GoodSalary", 
        ceil((salary * 0.04) * 12) AS "AnnualPayIncrease"
    FROM employees
    WHERE department_id IN(20, 50, 60);
    
    
-- Question 3: Display employee info in specified format
--              last name of employee must end with 'S' and 
--              first name must start with 'C' or 'K'

SELECT first_name || ', ' || last_name || ' is ' || Job_id AS "EmpInfo"
    FROM employees
    WHERE (upper(last_name) LIKE '%S') 
        AND (substr(upper(first_name), 1, 1) IN ('C', 'K'))
    ORDER BY last_name;

-- Question 4: Display every employee hired before 2012 and calculate 
--              the amount of years they have been working and round 
--              it UP to the closest whole number.

SELECT last_name AS "LName", hire_date AS "HireDate", 
        ceil(months_between(sysdate, hire_date) / 12) AS "YearsWorked"
    FROM employees
    WHERE hire_date < to_date('2012-01-01', 'yyyy-mm-dd')
    ORDER BY "YearsWorked" DESC;


-- Question 5: Display cities with country and province. If city does
--              not have a province, "Unknown province" is shown.
--              City must start with 'S' and be at least 8 characters long

SELECT city AS "CityName", country_id AS "Country", 
        NVL(state_province, 'Unknown Province') AS "Province"
    FROM locations
    WHERE upper(city) LIKE 'S%' AND length(city) >= 8;


-- Question 6: Display employees hired after 2017 and 
--              calculate the next thursday after a year.


SELECT last_name AS "LName", 
        to_char(hire_date, 'fmDAY, MONTH "the" DDSPTH "of year" yyyy') AS "HireDate", 
        to_char(next_day(add_months(hire_date, 12), 'Thursday'), 'fmDAY, MONTH "the" DDSPTH "of year" yyyy') AS "ReviewDay"
    FROM employees
    WHERE hire_date >= to_date('2018-01-01', 'yyyy-mm-dd')
    ORDER BY next_day(add_months(hire_date, 12), 'Thursday');
