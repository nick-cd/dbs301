-- *************************
-- DBS301 Lab 10
-- Clint MacDonald
-- Nov 22, 2018
-- *************************

-- Q1
CREATE TABLE L10Cities AS (SELECT * FROM locations WHERE location_id < 2000);
DESCRIBE L10Cities;

-- Q2
CREATE TABLE L10Towns AS (SELECT * FROM locations WHERE location_id < 1500);
DESCRIBE L10Towns;

-- Q3
SHOW RecycleBin;
PURGE RecycleBin;
DROP TABLE l10Towns;

-- Q4
FLASHBACK TABLE l10towns TO BEFORE DROP;
SHOW RecycleBin;

-- Q5
DROP TABLE l10towns;
SHOW RecycleBin;
PURGE TABLE l10towns;
SHOW RecycleBin;

-- Q6
CREATE VIEW can_city_vu AS 
    (SELECT street_address, postal_code, city, state_province FROM l10cities 
        WHERE UPPER(country_id) = 'CA');
SELECT * FROM can_city_vu;

-- Q7
CREATE OR REPLACE VIEW can_city_vu AS 
    (SELECT street_address "Str_Adr", postal_code "P_Code", city "City", state_province "Prov" FROM l10cities 
        WHERE UPPER(country_id) = 'CA');
SELECT * FROM can_city_vu;

-- Q8
CREATE OR REPLACE VIEW city_dname_vu AS 
    (SELECT department_name, city, state_province 
        FROM locations LEFT JOIN departments USING (location_id)
        WHERE UPPER(country_id) IN ('IT', 'CA'));
SELECT * FROM city_dname_vu;

-- Q9
CREATE OR REPLACE VIEW city_dname_vu AS 
    (SELECT department_name "DName", city "City", state_province "Prov" 
        FROM locations LEFT JOIN departments USING (location_id)
        WHERE UPPER(country_id) NOT IN ('US'));
SELECT * FROM city_dname_vu ORDER BY "City";

-- Q10 
SELECT * FROM ALL_OBJECTS WHERE object_type = 'VIEW';
SELECT * FROM ALL_OBJECTS WHERE object_type = 'VIEW' AND lower(object_name) = 'city_dname_vu';
DROP VIEW city_dname_vu;
SELECT * FROM ALL_OBJECTS WHERE object_type = 'VIEW' AND lower(object_name) = 'city_dname_vu';
  -- Difference, it is no longer contained in the data dictionary