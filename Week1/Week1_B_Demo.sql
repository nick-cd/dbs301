-----------------------------------------
-- Name: Clint MacDonald
-- ID#: 900######
-- Date: Sept 4, 2019
-- Purpose: Demo Week 1 Section B DBS301
-----------------------------------------

SELECT *
    FROM countries;
    
SELECT * 
    FROM employees;
    
-- review from DBS201 simple JOINS

-- list all employees and the name of the department in which they belong
SELECT employee_id, first_name, last_name, department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
    ORDER BY last_name, first_name;
    
    -- wow this is not good !
    -- we missed on employee, so the join failed us.
    -- SIMPLE joins will NOT be used in this course.
    
