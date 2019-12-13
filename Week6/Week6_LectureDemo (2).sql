-- Week 6 Demo 
-- Using Sportleagues database
-- Sub-Queries
-- i.e. nesting selects
-- ********************************************

-- Types of Queries
-- TABULAR - Returns a table with columns and rows
-- LIST    - Single Column, multiple Rows
-- SCALAR  - Returns a single value

-- SCALAR
SELECT Count(playerid) AS NumPlayers FROM tbldatplayers;

-- LIST
SELECT teamnameshort FROM tbldatteams ORDER BY teamnameshort;

-- TABULAR
-- ALL QUERIES

-- What was the most goals scored in one game by a single player
SELECT max(numgoals) AS MaxGoals
    FROM tbldatgoalscorers;
    -- result was 5
-- which player scored 5
SELECT playerID
    FROM tbldatgoalscorers
    WHERE numGoals = 5;
-- eliminate duplicates
SELECT DISTINCT playerID
    FROM tbldatgoalscorers
    WHERE numGoals = 5;
-- no hard coding is allowed
SELECT DISTINCT playerID
    FROM tbldatgoalscorers
    WHERE numGoals = (
        SELECT max(numgoals) AS MaxGoals
            FROM tbldatgoalscorers);

-- we need names
SELECT namefirst, namelast
    FROM tbldatplayers
    WHERE playerid IN(2190470, 2201576, 2253404);
    -- oops still hard coding
    
    
SELECT namefirst, namelast
    FROM tbldatplayers
    WHERE playerid IN(
        SELECT DISTINCT playerID
            FROM tbldatgoalscorers
            WHERE numGoals = (
                SELECT max(numgoals) AS MaxGoals
                    FROM tbldatgoalscorers
                        )
                    );
                    
-- example: List all employees who work in Seattle
    -- you may NOT use JOINS
SELECT location_id 
    FROM locations
    WHERE upper(city) = 'SEATTLE';
    
SELECT department_id
    FROM departments
    WHERE location_id IN (
    
        SELECT location_id 
            FROM locations
            WHERE upper(city) = 'SEATTLE'
            
        );
    
SELECT employee_id, 
    ( SELECT first_name FROM employees WHERE employees.employee_id = e.employee_id) AS fName,
    ( SELECT department_name FROM departments WHERE departments.department_id = e.department_id) AS deptName
    FROM employees e
    WHERE department_id IN (
    
        SELECT department_id
            FROM departments
            WHERE location_id IN (
    
                SELECT location_id 
                    FROM locations
                    WHERE upper(city) = 'SEATTLE'
            
            )
        );
    
    
-- list all employees whose name starts with C and show only their name
SELECT first_name, last_name
    FROM employees
    WHERE upper(first_name) LIKE 'C%';
    
    
    -- list all employees whose name starts with C and show only their name 
    -- but choose only those employees listed to work in Seattle
    
SELECT fName
    FROM (
        
        SELECT employee_id, 
        ( SELECT first_name FROM employees WHERE employees.employee_id = e.employee_id) AS fName,
        ( SELECT department_name FROM departments WHERE departments.department_id = e.department_id) AS deptName
        FROM employees e
        WHERE department_id IN (
        
            SELECT department_id
                FROM departments
                WHERE location_id IN (
        
                    SELECT location_id 
                        FROM locations
                        WHERE upper(city) = 'SEATTLE'
                
                )
            )
    )
    WHERE upper(fName) LIKE 'N%';
    
    
    
    
    
    
    
    
    

                    
                    
                    
                    
                    