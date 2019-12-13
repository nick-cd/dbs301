------------------------------------------
-- Name: Nicholas Defranco
-- ID#: 106732183
-- Date: Wednesday, Novmeber 20th, 2019
-- Purpose: Submission for Lab 9 for DBS301
------------------------------------------

-- Question 1:

-- NOTE: Department 80 is the Sales department.

-- LName field is NOT NULL on creation of this table
-- as the original employees table has the last_name field
-- as a manditory field.

-- The name of this NOT NULL constraint automatically determined
-- by the system.
CREATE TABLE L09SalesRep AS (

    SELECT employee_id AS RepID,
            first_name AS FName,
            last_name AS LName,
            phone_number AS Phone#,
            salary AS Salary,
            commission_pct AS Commission
        FROM employees
        WHERE department_id = 80
        
);

DELETE FROM employees
    WHERE employee_id = 206;   
    
SELECT * FROM employees;
    

CREATE TABLE L09Cust (

   cust#	  	NUMBER(6),
   custname 	VARCHAR2(30),
   city 		VARCHAR2(20),
   rating		CHAR(1),
   comments	    VARCHAR2(200),
   salesrep#	NUMBER(7) 
   
);

INSERT INTO L09Cust(cust#, custname, city, rating, salesrep#)
    VALUES(501, 'ABC LTD.', 'Montreal', 'C', 201);

INSERT INTO L09Cust(cust#, custname, city, rating, salesrep#)
    VALUES(502, 'Black Giant', 'Ottawa', 'B', 202);
    
INSERT INTO L09Cust(cust#, custname, city, rating, salesrep#)
    VALUES(503, 'Mother Goose', 'London', 'B', 202);
    
INSERT INTO L09Cust(cust#, custname, city, rating, salesrep#)
    VALUES(701, 'BLUE SKY LTD', 'Vancouver', 'B', 102);
    
INSERT INTO L09Cust(cust#, custname, city, rating, salesrep#)
    VALUES(702, 'MIKE and SAM Inc.', 'Kingston', 'A', 107);
    
INSERT INTO L09Cust(cust#, custname, city, rating, salesrep#)
    VALUES(703, 'RED PLANET', 'Mississauga', 'C', 107);
    
INSERT INTO L09Cust(cust#, custname, city, rating, salesrep#)
    VALUES(717, 'BLUE SKY LTD', 'Regina', 'D', 102);

    
-- Question 3:

CREATE TABLE L09GoodCust AS (

    SELECT cust# AS CustID,
            custname AS Name,
            city AS Location,
            salesrep# AS RepID
        FROM L09Cust
        WHERE rating IN ('A', 'B')
        
);

-- Question 4:

ALTER TABLE L09SalesRep
    ADD JobCode VARCHAR2(12);

DESCRIBE L09SalesRep;


-- Question 5:

ALTER TABLE L09SalesRep
    MODIFY Salary CONSTRAINT L09SalesRep_Salary_nn NOT NULL;
    
DESCRIBE  L09SalesRep;


-- Failed: "column to be modified to NULL cannot be modified 
--          to NULL"
/*
ALTER TABLE L09GoodCust
    MODIFY "Location" NULL;
*/
 
DESCRIBE L09GoodCust;
    
-- Question 6

ALTER TABLE L09SalesRep
    MODIFY FName VARCHAR2(37);
    
DESCRIBE L09SalesRep;


-- The max length of the data that is already stored is 17 
-- characters

SELECT MAX(length(Name)) AS MaxLen
    FROM L09GoodCust;

-- The size of the Name column will be decreased to the max 
-- name length determined by the previous query
ALTER TABLE L09GoodCust
    MODIFY Name VARCHAR2(17);

DESCRIBE L09GoodCust;

-- Question 7:

-- When a column is set as unused, the column becomes invisible
-- not allowing users to use the column. This makes it appear
-- as if it was deleted.

-- When the database is under maintenance, the column(s) can be
-- dropped without affecting any users.

ALTER TABLE L09SalesRep
    SET UNUSED COLUMN JobCode;
    
-- ... to be executed when database is under maintenance
ALTER TABLE L09SalesRep
    DROP UNUSED COLUMNS;


-- Question 8:

ALTER TABLE L09SalesRep
    ADD CONSTRAINT L09SalesRep_RepID_pk PRIMARY KEY(RepID);

DESCRIBE L09SalesRep;
    
ALTER TABLE L09GoodCust
    ADD CONSTRAINT L09GoodCust_CustID_pk PRIMARY KEY(CustID);
    
DESCRIBE L09GoodCust;

    
-- Question 9:

-- the style guide suggests unq as the suffix for a UNIQUE 
-- constraint identifier

ALTER TABLE L09SalesRep
    ADD CONSTRAINT L09SalesRep_Phone#_unq UNIQUE(Phone#);
    
ALTER TABLE L09GoodCust
    ADD CONSTRAINT L09GoodCust_Name_unq UNIQUE(Name);

    
-- Question 10:

ALTER TABLE L09SalesRep
    ADD CONSTRAINT L09SalesRep_Salary_chk CHECK(Salary >= 6000 AND Salary <= 12000);
    
ALTER TABLE L09SalesRep
    ADD CONSTRAINT L09SalesRep_Commission_chk CHECK(Commission <= 0.5);

-- Question 11:

-- Fails: "no matching unique or primary key for this column-list"
/*
ALTER TABLE L09GoodCust
    ADD CONSTRAINT L09GoodCust_RepID_fk FOREIGN KEY(RepID)
        REFERENCES L09SalesRep(RepID);
*/    
    
-- Question 12:
-- CustID 502, 503, 701, 702
-- RepID 202, 202, 102, 107

UPDATE L09GoodCust
    SET RepID = NULL; 


-- redo question 11...
-- success!
ALTER TABLE L09GoodCust
    ADD CONSTRAINT L09GoodCust_RepID_fk FOREIGN KEY(RepID)
        REFERENCES L09SalesRep(RepID);
        
        
-- Question 13:

ALTER TABLE L09GoodCust
    DISABLE CONSTRAINT L09GoodCust_RepID_fk;
    
UPDATE L09GoodCust
    SET RepID = 202
    WHERE CustID IN (502, 503);
    
UPDATE L09GoodCust
    SET RepID = 102
    WHERE CustID = 701;
    
UPDATE L09GoodCust
    SET RepID = 107
    WHERE CustID = 702;

-- failed: "cannot validate (DBS201_191A06.REPID_FK) - 
-- parent keys not found"
/*
ALTER TABLE L09GoodCust
    ENABLE CONSTRAINT L09GoodCust_RepID_fk;
*/
-- Question 14:

ALTER TABLE L09GoodCust
    DROP CONSTRAINT L09GoodCust_RepID_fk;


-- If a check constraint must be modified, the check constraint 
-- must first be dropped. However, for a brief moment, we are 
-- dropping the constraint allowing any incoming data to be accepted

-- therefore, changes such as this should only ever be done when
-- the database servers are down temporarly for maintainance
ALTER TABLE L09SalesRep
    DROP CONSTRAINT L09SalesRep_Salary_chk;

ALTER TABLE L09SalesRep
    ADD CONSTRAINT L09SalesRep_Salary_chk
        CHECK(Salary >= 5000 AND Salary <= 15000);

-- Question 15:

DESCRIBE L09SalesRep;
DESCRIBE L09GoodCust;

SELECT constraint_name, constraint_type, 
       search_condition, table_name
    FROM user_constraints
    WHERE lower(table_name) IN ('l09salesrep','l09goodcust')
    ORDER BY table_name, constraint_type;


COMMIT;