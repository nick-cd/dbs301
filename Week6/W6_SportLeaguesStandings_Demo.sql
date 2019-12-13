-- Standings Calculation using the sportleagues database.
-- Feb 19, 2019

-- first with respect to the home team only
SELECT  count(gameid) AS "GamesPlayed",
        hometeam AS "TheTeamID",
        sum(homescore) AS "GoalsFor",
        sum(visitscore) AS "GoalsAgainst",
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
    GROUP BY hometeam;
-- now with respect to teams that are NOT home (visitor)       
SELECT  count(gameid) AS "GamesPlayed",
        visitteam AS "TheTeamID",
        sum(visitscore) AS "GoalsFor",
        sum(homescore) AS "GoalsAgainst",
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
    GROUP BY visitteam;
    
-- now put them together using SET OPERATOR
SELECT  count(gameid) AS "GamesPlayed",
        hometeam AS "TheTeamID",
        sum(homescore) AS "GoalsFor",
        sum(visitscore) AS "GoalsAgainst",
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
    
UNION ALL

SELECT  count(gameid) AS "GamesPlayed",
        visitteam AS "TheTeamID",
        sum(visitscore) AS "GoalsFor",
        sum(homescore) AS "GoalsAgainst",
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
    GROUP BY visitteam;   
    
-- now add them together using a sub-query with aggregate functions
SELECT  sum(GamesPlayed) AS GP,
        (SELECT teamnameshort FROM tbldatteams WHERE teamid = temp.TheTeamID) AS tID,
        sum(GoalsFor) AS GF,
        sum(GoalsAgainst) AS GA,
        sum(GoalsFor - GoalsAgainst) AS GDiff,
        sum(Wins) AS W,
        sum(Losses) AS L,
        sum(Ties) AS T,
        sum(Wins * 3 + Ties * 1) AS Pts
    FROM (
            SELECT  count(gameid) AS GamesPlayed,
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
            
        UNION ALL
        
        SELECT  count(gameid) AS GamesPlayed,
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
    ) temp
    GROUP BY TheTeamID
    ORDER BY Pts DESC, W DESC, GDiff DESC;
        