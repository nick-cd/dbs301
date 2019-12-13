-- ************************
-- DBS301 Midterm Test # 2
-- Fall 2019
-- Nicholas Defranco
-- ************************
--
-- This is a closed book test, no aids are permitted.
-- Top marks can only be achieved if all code conforms 
-- with the style guide used in class.  
--
-- Ensure consideration for case sensitivity, internationalization,
-- and time zones in all answer.
--
-- There are 5 questions, for a total of 30 marks.
-- ***********************************************************************
-- Q1 (5 marks)
-- a) Create a new temporary table, called t2tmpUSdepartments, that shows names of the departments that have 
-- offices in the US.  Include the department id, department name, city and state.
    -- Complete this task using only a single SQL statement.
    -- Include all departments and all locations in the data. 
    -- your answer should have 7 results
DROP TABLE t2tmpUSdepartments;    
-- Q1 SOLUTION
CREATE TABLE t2tmpUSdepartments AS (

    SELECT department_id, department_name, city, state_province
        FROM departments FULL JOIN locations USING(location_id)
        WHERE upper(country_id) = 'US'
        
);

--Q2 (5 marks)
-- a) List all cities in the database. (3 marks)
    -- Show the Canadian cities first, 
    -- followed by US cities,
    -- followed by all other cities.  
    -- Do not list any city more than once.
-- Q2a SOLUTION

SELECT city
    FROM locations
    WHERE upper(country_id) = 'CA'
    
UNION ALL

SELECT city
    FROM locations
    WHERE upper(country_id) = 'US'
    
UNION ALL
    
SELECT city
    FROM locations
    WHERE upper(country_id) NOT IN('US', 'CA');
    

-- b) Repeat the same query but now (2 marks)
    -- Sort the Canadian cities alphabetically, 
    -- the US cities alphabetically and the rest of the cities 
    -- alphabetically without changing the order in which the 
    -- countries are shown. 
-- Q2b SOLUTION

SELECT city 
    FROM (
    
        SELECT city
            FROM locations
            WHERE upper(country_id) = 'CA'
            ORDER BY city
    )

UNION ALL

SELECT city 
    FROM (
    
        SELECT city
            FROM locations
            WHERE upper(country_id) = 'US'
            ORDER BY city

    )
    
UNION ALL
    
SELECT city 
    FROM (
    
        SELECT city
            FROM locations
            WHERE upper(country_id) NOT IN('US', 'CA')
            ORDER BY city

    );
    
--Q3 a) There currently is not any referential integrity on the country_id 
--      field in the locations table.  Write a statement that enforces this rule. 
--      (3 marks)
-- Q3a SOLUTION

ALTER TABLE locations
    ADD CONSTRAINT locations_country_id_fk FOREIGN KEY(country_id)
        REFERENCES countries(country_id);

--   b) In the countries table, add a rule to the region_id column that ensures that 
--      the region is one that exists (1, 2, 3, 4, 5) only.
--      (2 marks)
-- Q3b SOLUTION

ALTER TABLE countries
    ADD CONSTRAINT countries_region_id_chk CHECK(region_id IN(1, 2, 3, 4, 5));
    
--Q4
-- The company is expanding, adding 2 new offices to the company.  
-- Write ALL statements required to add the following offices locations to the database 
-- (do not worry about departments at this time). (5 marks)
-- STREET:          2000 Simcoe St. N.      ul. Kommunizma d. 24, kv. 15
-- CITY:            Oshawa,                 Novomosskovsk
-- STATE/COUNTRY:   ON, Canada (CA)         Tula Oblast, Russia (RU)
-- POSTAL CODE:     L1G 0C5                 123456
-- Q4 SOLUTION

COMMIT; -- start new transaction

INSERT INTO locations VALUES (
    3300, '2000 Simcoe St. N', 'L1G0C5', 'Oshawa', 'Ontario', 'CA'
);

SAVEPOINT simcoe_insert;

-- Russia needs to be added in countries table before we can insert 
-- an office that exists in Russia
INSERT INTO countries VALUES (
    'RU', 'Russia', 1
);

SAVEPOINT russia_insert;

-- inserting office location that required Russia
INSERT INTO locations VALUES (
    3400, 'ul. Kommunizma d. 24, kv. 15', '123456', 'Novomosskovsk', 'Tula Oblast', 'RU'
);

ROLLBACK; -- undoes all changes made in the transaction

COMMIT; -- commit changes

--Q5 (10 marks)
-- Execute the following creation script
DROP TABLE t2BankAccounts;
CREATE TABLE t2BankAccounts (
    account_number INT PRIMARY KEY,
    client_id INT NOT NULL,
    account_type varchar2(1) CHECK (account_type IN ('S', 'C')) NOT NULL,
    account_balance decimal(10,2) DEFAULT(0.0) NOT NULL CHECK (account_balance >= 0.0));
INSERT INTO t2BankAccounts VALUES (1234, 12, 'S', 4567.89);
INSERT INTO t2BankAccounts VALUES (4321, 12, 'C', 124.12);

-- Use transactional SQL to perform the following tasks.
    -- a) Write a statement to ensure that the above script is performed 
    --      and the insertions are permanent. (2 marks)
-- Q5a SOLUTION

COMMIT;

    -- b) Client 12 wants to move $400 from the Chequing (C) account 
    --    to the Savings (S) account.  Write the appropriate transaction statements 
    --    required to do this.
    --          - as an example: if you were to perform the exact statement twice 
				-- successfully, the balance would be $800 different) 
    -- Add the ability to undo part of the transaction by adding a statement between 
    --    each part of the transaction (call these "withdrawal" and "deposit") (5 marks)
-- Q5 b SOLUTION    

-- display client 12's Chequing account
-- ensuring it exists
SELECT account_number
    FROM t2BankAccounts
    WHERE client_id = 12 AND upper(account_type) = 'C';

-- check if the client has enough money in their account
-- by subtracting the amount and temporarily holding the money
-- ***should fail here due to check constraint***
UPDATE t2BankAccounts
    SET account_balance = account_balance - 400 
    WHERE account_number = 4321;
    
SAVEPOINT withdrawal; -- allows undoing

-- display client 12's Savings account
-- ensuring it exists
SELECT account_number
    FROM t2BankAccounts
    WHERE client_id = 12 AND upper(account_type) = 'S';

-- deposit amount previously taken from the client's checquing's account
UPDATE t2BankAccounts
    SET account_balance = account_balance + 400
    WHERE account_number = 1234;

-- no need for another savepoint here as we are at the end of the transaction


-- COMMIT; If everything was successful, we can commit 
-- (in this case the transaction failed so we would NOT execute this statement).
    
    -- d) it is obvious that the withdrawal can not happen as requested, 
    --    in words, describe what should happen at this point. 
	--      - Add the appropriate statement.
    --    (3 marks)
 -- Q5d SOLUTION
    
/*

Since the client did not have enough money in their Chequing account, the first 
update statement in the transaction failed. In transactions, either everthing happens 
or nothing at all. Thus, we must ROLLBACK to the beginning of the transaction as the 
transaction is considered to be a failure. We do this by executing the ROLLBACK 
command as shown below:

*/
ROLLBACK;

/*

The idea of transactions are important as in case of a power failure in the middle 
of the transaction, the client would not lose any money.

*/