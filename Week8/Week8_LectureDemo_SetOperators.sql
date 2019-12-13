-- *************************
-- WEEK 8 Demos DBS301
-- SET OPERATORS
-- *************************

-- SET OPERATORS
--------------------------------------
-- UNION
-- UNION ALL
-- INTERSECT
-- MINUS

-- EXAMPLE 1:   List all players whose last name starts with "st" or whose first name starts with "D"
--              DO NOT use any comparator operators in the statement (i.e. no AND or OR)

SELECT * FROM tbldatplayers
    WHERE upper(namelast) LIKE 'ST%'
    ORDER BY namelast;
    -- aha 13 results
SELECT * FROM tbldatplayers
    WHERE upper(namefirst) LIKE 'D%'
    ORDER BY namefirst;
    -- 53 results
    
-- but we want them both in one list
SELECT * FROM tbldatplayers
    WHERE upper(namelast) LIKE 'ST%'
    
    UNION
    
SELECT * FROM tbldatplayers
    WHERE upper(namefirst) LIKE 'D%';

-- now do not elimnate duplicates
SELECT * FROM tbldatplayers
    WHERE upper(namelast) LIKE 'ST%'
    
    UNION ALL
    
SELECT * FROM tbldatplayers
    WHERE upper(namefirst) LIKE 'D%';
    
  
    
    -- now sorting
SELECT * FROM tbldatplayers
    WHERE upper(namelast) LIKE 'ST%'
    
    UNION ALL
    
SELECT * FROM tbldatplayers
    WHERE upper(namefirst) LIKE 'D%'
    
    ORDER BY namelast;
-- wow does not work::::  :)

-- add aggregate function
SELECT namelast, namefirst, COUNT(playerid) AS Numplayers
    FROM (
        SELECT * FROM tbldatplayers
            WHERE upper(namelast) LIKE 'ST%'
            
            UNION ALL
            
        SELECT * FROM tbldatplayers
            WHERE upper(namefirst) LIKE 'D%'
    )
    GROUP BY namelast, namefirst
    HAVING count(playerid) > 1;
    
    -- but there is an easier way

SELECT * FROM tbldatplayers
    WHERE upper(namelast) LIKE 'ST%'
    
    INTERSECT
    
SELECT * FROM tbldatplayers
    WHERE upper(namefirst) LIKE 'D%';
    
    
    
SELECT * FROM tbldatplayers
    WHERE upper(namelast) LIKE 'ST%'
    
    MINUS
    
SELECT * FROM tbldatplayers
    WHERE upper(namefirst) LIKE 'D%';
    
-- Example: List all teams who play today
SELECT hometeam, teamnameshort
    FROM tbldatgames g JOIN tbldatteams t ON g.hometeam = t.teamid
    WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1;
    -- but we need the away team too
SELECT visitteam, teamnameshort
    FROM tbldatgames g JOIN tbldatteams t ON g.visitteam = t.teamid
    WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1;
    
    -- now combine these
SELECT hometeam AS tID, teamnameshort
    FROM tbldatgames g JOIN tbldatteams t ON g.hometeam = t.teamid
    WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1
UNION
SELECT visitteam, teamnameshort
    FROM tbldatgames g JOIN tbldatteams t ON g.visitteam = t.teamid
    WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1;
    
-- now let us sort by team name
SELECT tID, teamName FROM(
    SELECT hometeam AS tID, teamnameshort AS teamName
        FROM tbldatgames g JOIN tbldatteams t ON g.hometeam = t.teamid
        WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1
    UNION
    SELECT visitteam, teamnameshort
        FROM tbldatgames g JOIN tbldatteams t ON g.visitteam = t.teamid
        WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1)

    ORDER BY teamName;
    

SELECT hometeam AS tID, teamnameshort AS teamName
        FROM tbldatgames g JOIN tbldatteams t ON g.hometeam = t.teamid
        WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1
    UNION
SELECT visitteam, teamnameshort
        FROM tbldatgames g JOIN tbldatteams t ON g.visitteam = t.teamid
        WHERE g.gamedatetime BETWEEN sysdate - 1 AND sysdate + 1
    ORDER BY teamName;
    
    
    
    