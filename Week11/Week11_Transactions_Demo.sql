-- ***********************************
-- Week 11 - DBS 301 Lecture Demo
-- TRANSACTIONS, OOPs continued
-- November 18, 2019
-- ***********************************

-- in SQL Server

-- START TRANSACTION
--      do stuff
-- END TRANSACTION
-- COMMIT

-- in ORACLE
-- 3 KEYWORDS
   -- COMMIT
   -- ROLLBACK
   -- SAVEPOINT
   
SELECT * FROM tblDatPlayers WHERE playerid = 99989;

INSERT INTO tbldatplayers VALUES (99989, 'A431', 'MacDonald', 'Bobby', 1);
SELECT * FROM tblDatPlayers WHERE playerid = 99989;
-- crash SQL Developer
SELECT * FROM tblDatPlayers WHERE playerid = 99989;
-- bobby is missing
INSERT INTO tbldatplayers VALUES (99989, 'A431', 'MacDonald', 'Bobby', 1);
SELECT * FROM tblDatPlayers WHERE playerid = 99989;
-- closed program and chose to Commit changes
SELECT * FROM tblDatPlayers WHERE playerid = 99989;
-- bobby is still there

INSERT INTO tbldatplayers VALUES (99990, 'A412', 'MacDonald', 'Sally', 1);
SELECT * FROM tblDatPlayers WHERE playerid IN( 99989, 99990);
COMMIT;

-- this both ends and commits the existing transaction and STARTS A NEW ONE

-- Multi-step transaction
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);
-- player 1019404 is on team 214
-- player 1746230 is on team 221

UPDATE tbljncrosters SET teamid = 221 WHERE rosterid = 4;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);
ROLLBACK;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);


UPDATE tbljncrosters SET teamid = 221 WHERE rosterid = 4;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);
SAVEPOINT a;
UPDATE tbljncrosters SET teamid = 214 WHERE rosterid = 14;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);

ROLLBACK to a;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);
UPDATE tbljncrosters SET teamid = 214 WHERE rosterid = 14;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);
COMMIT;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);
ROLLBACK;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);

COMMIT;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);
UPDATE tbljncrosters SET teamid = 221 WHERE rosterid = 14;
UPDATE tbljncrosters SET teamid = 214 WHERE rosterid = 4;
SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230);

CREATE TABLE myTempTable AS (
    SELECT * FROM tbljncrosters WHERE playerID IN(1019404, 1746230)
);

SELECT * FROM myTempTable;
-- so that covers OOPs and UNDO in DML

-- Now what about oops and UNDO in DDL
DROP TABLE tbljncrosters;

SHOW RecycleBin;
FLASHBACK TABLE tbljncrosters TO BEFORE DROP;
SELECT * FROM tbljncrosters;

-- this is the oops (sortof) of DDL


SELECT * FROM ALL_OBJECTS WHERE OBJECT_TYPE='TABLE';