------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Wednesday, September 11th, 2019
-- Purpose: Submission for Lab 1 for DBS301
-- Description: This lab is an introduction to SQL developer
--              as well as a review of querying data from tables.
------------------------------------------

------------------------------------------
-- Question 1: Comparing table sizes. 
--             Which table appears to be the widest or longest?

SELECT * 
    FROM employees;
    
SELECT *
    FROM departments;
    
SELECT *
    FROM job_history;

-- Question 1 solution:
-- The employees table appears to be the widest and longest

------------------------------------------
--  Question 2: Would this SELECT statment work? 
--              If it does not work, how can it be fixed?

/*

SELECT last_name "LName", job_id "Job_Title",
        Hire Date "Job Start"
        FROM employees;
     
This statment does not work.
Oracle says "FROM keyword not found where expected".

This is because of a missing underscore between 
the words "Hire" and "Date".

Notes: The field should also be in lowercase to stay 
consistant with the style guideline.

When creating an alias for a field and the AS keyword 
should be used to be clear as to which is the alias 
and which is the actual field name.

Naming convention for aliases should be consistent.
The camel casing convention was used as the naming convention.

*/

-- Question 2 solution:
-- This is the working SELECT statment.
SELECT last_name AS "LName", job_id AS "JobTitle", hire_date AS "JobStart"
        FROM employees;
        
------------------------------------------
-- Question 3: Identify three errors in the SELECT statment.

/*

SELECT employee_id, last name, commission_pct Emp Comm,
FROM employees;

1) There is a missing underscore between the words "last" and "name".
2) An alias for a column name with spaces must be surrounded with 
   double quotes.
3) There is an unneccessary comma after "EMP Comm" and before 
   FROM CLAUSE.
   
NOTES: FROM clause should be indented for consistency.
AS keyword should be used for consistancy.
The naming convention was kept with the comission_pct alias.
Aliases were added for the rest of the field names.


*/

-- Question 3 solution:
-- This is the working SELECT statment.
SELECT employee_id "EmpID", last_name "LName", commission_pct AS "EmpComm"
    FROM employees;

------------------------------------------
-- Question 4: What command would show the structure of the 
--             LOCATIONS table?

-- Question 4 solution:
-- The command that would show the structure of the LOCATIONS table is:
DESC LOCATIONS;

------------------------------------------
-- Question 5: Create a query to display the output shown on the 
--             lab sheet.

-- Question 5 solution:
-- This statment matches what is shown on the lab worksheet.
SELECT location_id AS "City#", city AS "City", 
        state_province || ' IN THE ' || country_id AS "Province with Country Code"
    FROM locations;
    
/*

This is my bonus attempt.
The bonus is to only show the country code if there is no province.

NOTE: name of alias for calculated field has been changed to make 
more sense in this context.

*/

SELECT location_id AS "City#", city AS "City", 
        NVL2(state_province, state_province, country_id) AS "Location"
    FROM locations;
    
------------------------------------------
-- END OF FILE
------------------------------------------