-- Week 5 Demo 
-- Using Sportleagues database
-- Covering Simple Joins and Advanced Joins
-- i.e. SELECTs with multiple tables in the FROM portion of the statement
-- ********************************************

SELECT first_Name, last_Name, department_Name
    FROM employees, departments
    WHERE employees.department_id = departments.department_id
    ORDER BY last_name;
    -- NEVER DO THIS UNLESS IT SAYS SO
    
UPDATE locations SET city = 'sydney' WHERE location_id = 2200;

-- ADVANCED JOINS
SELECT first_Name, last_Name, department_Name
    FROM employees JOIN departments
        ON employees.department_id = departments.department_id
    ORDER BY last_name;
    -- yeah, way faster...but not for small databases
    -- but much faster for large datasets
    
-- but we are still missing one employee
SELECT first_Name, last_Name, department_Name
    FROM employees LEFT OUTER JOIN departments
        ON employees.department_id = departments.department_id
    ORDER BY last_name;
    
    -- now kimberley shows up, yeah!
    
-- now if we want to see all depts regardless if there are any empoyees in them.
SELECT first_Name, last_Name, department_Name
    FROM employees RIGHT OUTER JOIN departments
        ON employees.department_id = departments.department_id
    ORDER BY last_name;

-- what if we want to see ALL employees and ALL departments
SELECT first_Name, last_Name, department_Name
    FROM employees FULL OUTER JOIN departments
        ON employees.department_id = departments.department_id
    ORDER BY last_name;
    
-- what about inverse questions (i.e. NOT questions)
-- name departments with NO employees
SELECT first_Name, last_Name, department_Name
    FROM employees RIGHT OUTER JOIN departments
        ON employees.department_id = departments.department_id
    WHERE employees.first_name IS NULL
    ORDER BY last_name;
-- name employees in NO department
SELECT first_Name, last_Name, department_Name
    FROM employees LEFT OUTER JOIN departments
        ON employees.department_id = departments.department_id
    WHERE departments.department_name IS NULL
    ORDER BY last_name;
    
    -- another level - multiple joins
    
-- sportleagues show team rosters with names
SELECT teamnameshort, namefirst || ' ' || namelast AS playerName, jerseynumber
    FROM tbldatteams t JOIN tbljncrosters r ON t.teamid = r.teamid
        JOIN tbldatplayers p ON r.playerid = p.playerid
    ORDER BY teamnameshort, playerName;-- 230 records output, because inner joins
    
-- let's do the same thing, but show ALL players
SELECT teamnameshort, namefirst || ' ' || namelast AS playerName, jerseynumber
    FROM tbldatteams t JOIN tbljncrosters r ON t.teamid = r.teamid
        RIGHT JOIN tbldatplayers p ON r.playerid = p.playerid
    ORDER BY teamnameshort, playerName;
    
SELECT teamnameshort, namefirst || ' ' || namelast AS playerName, jerseynumber
    FROM tbldatplayers p LEFT JOIN tbljncrosters r ON p.playerid = r.playerid
        LEFT JOIN tbldatteams t ON r.teamid = t.teamid
    ORDER BY teamnameshort, playerName;
    
    
-- ambiguous fields
SELECT t.teamid, teamnameshort, p.playerID, namefirst || ' ' || namelast AS playerName, jerseynumber
    FROM (tbldatplayers p FULL JOIN tbljncrosters r ON p.playerid = r.playerid)
        FULL JOIN tbldatteams t ON r.teamid = t.teamid
    ORDER BY teamnameshort, playerName;

-- let us display all players NOT currently on a roster 
SELECT p.playerID, namefirst || ' ' || namelast AS playerName
    FROM tbldatplayers p LEFT JOIN tbljncrosters r ON p.playerid = r.playerid
    WHERE rosterID IS NULL
    ORDER BY playerName;
    
    
    
-- we need flexibility and object oriented approach
-- add a parameter
SELECT p.playerID, namefirst || ' ' || namelast AS playerName
    FROM tbldatplayers p LEFT JOIN tbljncrosters r ON p.playerid = r.playerid
    WHERE rosterID IS NULL AND upper(namelast) LIKE upper('&lastname%')
    ORDER BY playerName;
    
