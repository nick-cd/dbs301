-- *************************
-- DBS301 - Lab 9 DDL, DML
-- Clint MacDonald
-- Nov 15, 2018
-- Solutions
-- *************************
-- Q1
CREATE TABLE L09SalesRep AS(
    SELECT  employee_id RepID, 
            first_name FName, 
            last_name LName, 
            phone_number Phone#, 
            salary, 
            commission_pct commission
        FROM employees WHERE department_id = 80);
SELECT * FROM L09SalesRep;
-- Q2
CREATE TABLE L09Cust (
   custID	  	NUMBER(6),
   CustName 	VARCHAR2(30),
   City 		VARCHAR2(20),
   rating		CHAR(1),
   comments	    VARCHAR2(200),
   salesRepID	NUMBER(7) 
   );
            
DELETE FROM L09Cust;
COMMIT;      
INSERT ALL 
    INTO L09Cust VALUES (501, 'ABC LTD.', 'Montreal', 'C', '', 201)
    INTO L09Cust VALUES (502, 'Black Giant', 'Ottawa', 'B', '', 202)
    INTO L09Cust VALUES (503, 'Mother Goose', 'London', 'B', '', 202)
    INTO L09Cust VALUES (701, 'Blue Sky', 'Vancouver', 'B', '', 102)
    INTO L09Cust VALUES (702, 'Mike and Sam Inc.', 'Kingston', 'A', '', 107)
    INTO L09Cust VALUES (703, 'Red Planet', 'Mississauga', 'C', '', 107)
    INTO L09Cust VALUES (717, 'Blue Sky LTD', 'Regina', 'D', '', 102)
    SELECT 1 FROM dual;
COMMIT;

-- Q3 
DROP TABLE L09GoodCust;
CREATE TABLE L09GoodCust AS(
    SELECT custID, custname "Name", city "Location", salesRepID repID 
    FROM L09Cust WHERE upper(rating) IN('A', 'B'));

SELECT * FROM L09GoodCust;

-- Q4 
ALTER TABLE L09SalesRep
    ADD JobCode varchar2(12);
    
DESCRIBE L09SalesRep;

-- Q5 a
ALTER TABLE L09SalesRep
    MODIFY salary NOT NULL;
DESCRIBE L09SalesRep;

DESCRIBE L09GoodCust;
ALTER TABLE L09GoodCust MODIFY CustID NOT NULL;
ALTER TABLE L09GoodCust MODIFY "Name" NOT NULL;
ALTER TABLE L09GoodCust MODIFY "Location" NOT NULL;
ALTER TABLE L09GoodCust MODIFY RepID NOT NULL;
DESCRIBE L09GoodCust;

ALTER TABLE L09GoodCust
    MODIFY "Location" varchar2(20) NULL;
    
-- Q5 b
ALTER TABLE L09SalesRep
    MODIFY fname varchar(37);
DESCRIBE L09SalesRep;

SELECT MAX(LENGTH(TRIM("Name"))) L FROM L09GoodCust;
-- returns 17
ALTER TABLE L09GoodCust MODIFY "Name" varchar(17);
    
-- Q6 
ALTER TABLE L09SalesRep
    DROP COLUMN JobCode;
DESCRIBE L09SalesRep;

-- Q7 
ALTER TABLE L09Cust
    ADD CONSTRAINT cust_pk PRIMARY KEY (CustID);
DESCRIBE L09Cust;

ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_pk PRIMARY KEY (RepID);
DESCRIBE L09SalesRep;

-- Q8
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_phone_uk UNIQUE (phone#);
ALTER TABLE L09Cust
    ADD CONSTRAINT cust_name_uk UNIQUE (custname);
    
-- Q9
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_salary_chk CHECK(salary BETWEEN 6000 AND 12000);
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_Commission_chk CHECK(commission <= 0.5);
DESCRIBE L09SalesRep;
-- Q10 
ALTER TABLE L09GoodCust
    ADD CONSTRAINT goodcust_salesrep_fk FOREIGN KEY (RepID) REFERENCES L09SalesRep(RepID);
    -- It fails because existing data already in the table breaks the rule we are attempting
    -- to create.  Therefore, the rule creation fails.  We must fix the data before creating
    -- the rule.

-- Q11
SELECT * FROM L09GoodCust;  -- took screenshot
DESCRIBE L09GoodCust;
UPDATE L09GoodCust SET RepID = (NULL); 
-- fails as NOT NULL constraint on REPid
ALTER TABLE L09GoodCust MODIFY RepID NUMBER(7) NULL;
UPDATE L09GoodCust SET RepID = (NULL); 
SELECT * FROM L09GoodCust; 
ALTER TABLE L09GoodCust
    ADD CONSTRAINT goodcust_salesrep_fk FOREIGN KEY (RepID) REFERENCES L09SalesRep(RepID);
    -- It was now successful :)
    
-- Q12
ALTER TABLE L09GoodCust
    DISABLE CONSTRAINT goodcust_salesrep_fk;
UPDATE L09GoodCust SET RepID = 202 WHERE custID IN (502, 503);
UPDATE L09GoodCust SET RepID = 102 WHERE custID = 701;
UPDATE L09GoodCust SET RepID = 107 WHERE custID = 702;
ALTER TABLE L09GoodCust
    ENABLE CONSTRAINT goodcust_salesrep_fk;
/*
ORA-02298: cannot validate (DBS301_191B45.GOODCUST_SALESREP_FK) - parent keys not found
02298. 00000 - "cannot validate (%s.%s) - parent keys not found"
*Cause:    an alter table validating constraint failed because the table has
           child records.
*Action:   Obvious

THE Enabling failed as the child records do not necessarily exist in the referenced table
*/

-- Q13 
ALTER TABLE L09GoodCust
    DROP CONSTRAINT goodcust_salesrep_fk;
ALTER TABLE L09SalesRep
    DROP CONSTRAINT salesrep_salary_chk;
ALTER TABLE L09SalesRep
    ADD CONSTRAINT salesrep_salary_chk CHECK (salary BETWEEN 5000 AND 15000);
-- Q14
DESCRIBE L09SalesRep;
DESCRIBE L09GoodCust;

SELECT  constraint_name, constraint_type, search_condition, table_name
    FROM user_constraints
    WHERE upper(table_name) IN ('L09SALESREP','L09GOODCUST')
    ORDER BY table_name, constraint_type;
