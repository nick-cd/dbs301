------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Sunday, Novmeber 24th, 2019
-- Purpose: Submission for Lab 10 for DBS301
------------------------------------------

-- Question 1:

CREATE TABLE L10Cities AS (
    SELECT * 
        FROM locations
        WHERE location_id < 2000
);

SELECT * FROM L10Cities;

DESCRIBE L10Cities;


-- Question 2:

CREATE TABLE L10Towns AS (
    SELECT *
        FROM locations
        WHERE location_id < 1500
);

SELECT * FROM L10Towns;

DESCRIBE L10Towns;


-- Question 3:

PURGE RECYCLEBIN;

DROP TABLE L10Towns;

-- drop time: 2019-11-21:09:04:51
SHOW RECYCLEBIN;


-- Question 4:

FLASHBACK TABLE L10Towns TO BEFORE DROP;

DESCRIBE L10Towns;

SHOW RECYCLEBIN;

-- Question 5:

DROP TABLE L10Towns PURGE;

-- "Object "" is INVALID, it may not be described."
SHOW RECYCLEBIN;

-- this operation failed as the object was not found in the
-- recycle bin
FLASHBACK TABLE L10Towns TO BEFORE DROP;


-- Question 6:

CREATE OR REPLACE VIEW can_city_vu AS (
    SELECT street_address, postal_code, city, state_province
        FROM L10Cities
        WHERE upper(country_id) = 'CA'
);

SELECT * FROM can_city_vu;


-- Question 7:

CREATE OR REPLACE VIEW can_city_vu AS (
    SELECT street_address AS "Str_Adr", 
            postal_code AS "P_Code", 
            city AS "City", 
            state_province AS "Prov"
        FROM L10Cities
        WHERE upper(country_id) IN('CA', 'IT')
);


SELECT * FROM can_city_vu;


-- Question 8:

CREATE OR REPLACE VIEW vwcity_dname_vu AS (
    SELECT department_name, city, state_province
        FROM departments RIGHT JOIN locations USING(location_id)
        WHERE upper(country_id) IN('CA', 'IT')
);

SELECT * FROM vwcity_dname_vu;


-- Question 9:

CREATE OR REPLACE VIEW vwcity_dname_vu AS (
    SELECT department_name AS "DName", 
            city AS "City", 
            state_province AS "Prov"
        FROM departments RIGHT JOIN locations USING(location_id)
        WHERE upper(country_id) != 'US'
);        

SELECT * FROM vwcity_dname_vu;


-- Question 10:
-- Start a transaction
COMMIT;

-- Create "Marketing and Sales" department
INSERT INTO departments VALUES (
    200, 'Marketing and Sales', NULL, (SELECT location_id FROM departments WHERE upper(department_name) = 'MARKETING')
);

SAVEPOINT adddept;

-- Changing sales department' location to the marketing
-- department' location
UPDATE departments 
    SET location_id = (
    
        -- get location of marketing department
        SELECT location_id
            FROM departments
            WHERE upper(department_name) = 'MARKETING'
    
    )
    WHERE department_id = (
    
        -- get department id of sales department
        SELECT department_id
            FROM departments
            WHERE upper(department_name) = 'SALES'
    
    );

SAVEPOINT movesales;

-- Move staff from marketing and Sales departments to the 
-- new department
UPDATE employees
    SET department_id = (
    
        -- get department id of the new department
        SELECT department_id
            FROM departments
            WHERE upper(department_name) = 'MARKETING AND SALES'
            
    )
    WHERE department_id IN (
    
        -- get departments IDs for the sales and marketing department
        SELECT department_id
            FROM departments
            WHERE upper(department_name) IN('SALES', 'MARKETING')
            
    );
    
COMMIT;

-- Question 11:

SELECT object_name
    FROM user_objects
    WHERE object_type = 'VIEW';
    
DROP VIEW vwcity_dname_vu;

SELECT object_name
    FROM user_objects
    WHERE object_type = 'VIEW';
