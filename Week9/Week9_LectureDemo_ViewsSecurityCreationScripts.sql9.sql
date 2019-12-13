-- *************************
-- WEEK 9 Demos DBS301
-- Views/Users/Creation Scripts
-- *************************

-- What is a view?
-- the saved text of a SELECT statement that can be executed on demand

DROP VIEW vwTodaysPlayingTeams;
CREATE VIEW vwTodaysPlayingTeams AS (
    SELECT hometeam AS tID, teamnameshort
        FROM tbldatgames g JOIN tbldatteams t ON g.hometeam = t.teamid
        WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1
    UNION
    SELECT visitteam, teamnameshort
        FROM tbldatgames g JOIN tbldatteams t ON g.visitteam = t.teamid
        WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1   );

SELECT * FROM vwTodaysPlayingTeams
    ORDER BY teamnameshort;
    
CREATE OR REPLACE VIEW <viewname> AS (); 

-- Why Views?
-- reduce repeating similar code
-- setting up a foundation
-- replace sub-queries

-- big standings example at bottom of file


-- So views essentially are
CREATE VIEW <viewname> AS (<some select statement no order by >);

-- SECURITY
-- read Oracle docs on grant and revoke for homework

-- CREATION SCRIPTS
-- Step 1 - USE schema
-- Step 2 - IF EXISTS DROP TABLE
-- Step 3 - CREATE TABLE (but which one???) -   
    -- ALL TABLES without FKs'
    -- TABLES with FKs to tables that already exist
        -- repeat and rewash
    -- typically junction tables are last
-- then insert data using the same ordering


CREATE VIEW vwStandings_Home AS (
SELECT  count(gameID) AS GamesPlayed,
                    hometeam AS TheTeamID,
                    sum(homescore) AS GoalsFor,
                    sum(visitscore) AS GoalsAgainst,
                    sum(    CASE
                                WHEN homescore > visitscore THEN 1
                                ELSE 0
                                END
                                ) AS Wins,
                    sum(    CASE
                                WHEN homescore < visitscore THEN 1
                                ELSE 0
                                END
                                ) AS Losses,
                    sum(    CASE
                                WHEN homescore = visitscore THEN 1
                                ELSE 0
                                END
                                ) AS Ties
                    FROM tbldatgames
                    WHERE isPlayed = 1
                    GROUP BY hometeam
);

CREATE VIEW vwStandings_Visitor AS (
SELECT  count(gameID) AS GamesPlayed,
                    visitteam AS TheTeamID,
                    sum(visitscore) AS GoalsFor,
                    sum(homescore) AS GoalsAgainst,
                    sum(    CASE
                                WHEN homescore < visitscore THEN 1
                                ELSE 0
                                END
                                ) AS Wins,
                    sum(    CASE
                                WHEN homescore > visitscore THEN 1
                                ELSE 0
                                END
                                ) AS Losses,
                    sum(    CASE
                                WHEN homescore = visitscore THEN 1
                                ELSE 0
                                END
                                ) AS Ties
                    FROM tbldatgames
                    WHERE isPlayed = 1
                    GROUP BY visitteam
);
SELECT  
    (SELECT teamNameShort FROM tbldatteams WHERE teamID = Stand.TheTeamID) AS Team,
        SUM(GamesPlayed) AS GP,
        SUM(Wins) AS W,
        SUM(Losses) AS L,
        SUM(Ties) AS T,
        SUM(Wins * 3 + Ties) AS Pts,
        SUM(GoalsFor) AS GF,
        SUM(GoalsAgainst) AS GA,
        SUM(GoalsFor - GoalsAgainst) AS GD
    FROM (
                
            SELECT * FROM vwStandings_Home      
            UNION
            SELECT * FROM vwStandings_Visitor
            
        ) Stand
    GROUP BY TheTeamID;
 