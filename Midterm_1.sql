/*
NAME: Nicholas Defranco
Student ID: 106732183
October 16, 2019
Midterm Test # 1
DBS301 SAB 

INSTRUCTIONS:
Answer each question below such that the code can be executed.
ALL questions are out of 5 marks for a total of 30
*/
-- ---------------------------------------------------------

-- RUN this command first on the leagues database.  This simply makes games cover the current date range.
UPDATE tbldatgames SET gamedatetime = gamedatetime + 840;

/* 
1. Create a SELECT statement to return the full player names "lastname, firstname", 
    the shirt number and short team name for all players whom are both active as 
    players and active on their respective teams.
    •	Sort the results by team name and then by last name. 
    •	USE Joins, not sub-selects   */

SELECT namefirst || ', ' || namelast AS "FullName",
        jerseynumber AS "ShirtNum",
        teamnameshort AS "TeamName"
    FROM (tbldatplayers p JOIN tbljncrosters r
        ON p.playerid = r.playerid)
        JOIN tbldatteams t
        ON t.teamid = r.teamid
    WHERE p.isactive = 1
        AND r.isactive = 1
    ORDER BY "TeamName", namelast;
    

/*
2. We want to start a new award for the league; player of the week.  
Therefore we will need a query that returns the top goal scorers for the week.  
Create a query that returns the first name, last name, and total goals scored 
in the past 7 days.  

Only include those whom have scored more than 1 goal.  

Sort the output from most goals to least goals scored.
*/

SELECT namefirst AS "FName", 
        namelast AS "LName", 
        sum(numgoals) AS "TotalGoals"
    FROM (tbldatplayers p JOIN tbldatgoalscorers g
        ON p.playerid = g.playerid) 
        JOIN tbldatgames ga
        ON g.gameid = ga.gameid
    WHERE gamedatetime > sysdate - 7
    GROUP BY namefirst, namelast
    HAVING sum(numgoals) > 1
    ORDER BY "TotalGoals" DESC;
    



/*
3. We are starting a monthly newsletter and want to include a small section 
detailing the upcoming games.  Produce a query, with friendly column headings, 
that lists all games to be played "next month".  

    •	Include the game number, game date, and the short team names for both 
    the home team and the visitor team.  
    •	Sort the schedule by date showing the first games first.  
*/
    
SELECT gamenum AS "Game Number", 
        gamedatetime AS "Scheduled Date", 
        (SELECT teamnameshort FROM tbldatteams WHERE tbldatteams.teamid = g.hometeam) AS "Home Team",
        (SELECT teamnameshort FROM tbldatteams WHERE tbldatteams.teamid = g.visitteam) AS "Away Team"
    FROM tbldatgames g
    WHERE gamedatetime > sysdate 
        AND gamedatetime < add_months(sysdate, 1)
    ORDER BY gamedatetime;
/*
4. Create a query that shows the FUTURE games for any single team where the teamID 
    is entered as a parameter by the user at the time the query is run.  
•	show the game number and game date for each game
•	format the date similar to "Feb 21st, 2019"
•	sort the results by game date
*/

SELECT * FROM tbldatgoalscorers;

SELECT teamid AS "Team ID", 
        gamenum AS "Game Number", 
        to_char(gamedatetime, 'Mon ddth, yyyy') AS "Scheduled Date"
    FROM tbldatgames g JOIN tbldatgoalscorers gs
        ON g.gameid = gs.gameid 
    WHERE gamedatetime > sysdate
        AND teamid LIKE '%&team_id%'
    ORDER BY gamedatetime;  

/*
5. Show a list of teams in each division in the database.  
•	include the long division name and the long team name
•	sort the output by the divisions display order and then by team name
•	only show divisions that are active and teams that are active
•	include all active divisions, even if they contain no teams
*/

SELECT divnamelong AS "Division", 
        teamnamelong AS "Team"
    FROM (tbllistdivisions d LEFT JOIN tbljncteamsdivs td
        ON d.divid = td.divid)
        LEFT JOIN tbldatteams t
        ON td.teamid = t.teamid
    WHERE d.isactive = 1 
        AND t.isactive = 1
    ORDER BY divnamelong, teamnamelong;
 
/*
6. List all the used jersey (shirt) numbers in the league along with the total number of players whom use that number
•	order the results showing the most used number first
•	only show results for those numbers used more than once
*/

SELECT jerseynumber AS "JerseyNumber", 
        count(rosterid) AS "AmountOfPlayers"
    FROM tbljncrosters
    GROUP BY jerseynumber
    HAVING count(rosterid) > 1
    ORDER BY count(rosterid) DESC;
