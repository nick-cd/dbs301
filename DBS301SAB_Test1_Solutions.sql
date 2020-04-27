/*
NAME: Clint MacDonald (SOLUTIONS)
Student ID:
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
1. Create a SELECT statement to return the full player names "lastname, firstname", the shirt number and short team name for all players whom are both active as players and active on their respective teams.
    -	Sort the results by team name and then by last name. 
    -	USE Joins, not sub-selects   */

SELECT  namelast || ', ' || namefirst AS FullName,
        jerseynumber AS ShirtNum,
        teamnameshort AS TeamName
    FROM (tbldatteams t JOIN tbljncrosters r USING (teamid))
        JOIN tbldatplayers p USING (playerid)
    WHERE p.isactive = 1 AND r.isactive = 1
    ORDER BY teamnameshort, namelast;
	/*	
	1 mark - SELECT/ORDER BY
	3 mark - FROM/JOIN
	1 mark - WHERE 
	*/
	
/*
2. We want to start a new award for the league; player of the week.  
Therefore we will need a query that returns the top goal scorers for 
the week.  Create a query that returns the first name, last name, 
and total goals scored in the past 7 days.  
    - Only include those whom have scored more than 1 goal. 
    - Sort the output from most goals to least goals scored.
*/

SELECT namefirst, namelast, SUM(NumGoals) AS TotGoals
    FROM tbldatplayers JOIN tbldatgoalscorers USING (playerid)
        JOIN tbldatgames using (gameid)
    WHERE gamedatetime BETWEEN sysdate - 7 AND sysdate
    GROUP BY namefirst, namelast
    HAVING Sum(NumGoals) > 1
    ORDER BY TotGoals DESC;


-- more complex
SELECT trim(p.namelast) || ', ' || trim(p.namefirst) AS "Player Name", temp."Scored"
    FROM tbldatplayers p JOIN
    (
        SELECT playerid, sum(numgoals) AS "Scored"
            FROM tbldatgoalscorers
            WHERE gameid IN 
            (
                SELECT gameid
                    FROM tbldatgames
                    WHERE gamedatetime >= sysdate-7    
                    AND gamedatetime <= sysdate 
                    AND isplayed = 1
            ) 
            GROUP BY playerid
    ) temp 
    ON p.playerid = temp.playerid
    ORDER BY "Scored" DESC; 
/*
3. We are starting a monthly newsletter and want to include a small section detailing the upcoming games.  Produce a query, with friendly column headings, that lists all games to be played "next month".  
    -	Include the game number, game date, and the short team names for both the home team and the visitor team.  
    -	Sort the schedule by date showing the first games first.  
*/

SELECT  gamenum AS Game#, 
        to_char(gamedatetime, 'Mon dd') AS GameDate, 
        h.teamnameshort AS HomeTeam, 
        v.teamnameshort AS Visitor
    FROM tbldatteams h JOIN tbldatgames g
        ON h.teamid = g.hometeam
        JOIN tbldatteams v 
            ON v.teamid = g.visitteam
    WHERE EXTRACT(month FROM gamedatetime) = EXTRACT(month FROM sysdate) + 1
    ORDER BY GameDateTime;

/*
4. Create a query that shows the FUTURE games for any single team where the t
eamID is entered as a parameter by the user at the time the query is run.  
-	show the game number and game date for each game
-	format the date similar to "Feb 21st, 2019"
-	sort the results by game date
*/

SELECT  gamenum AS GameNum, 
        to_char(gamedatetime, 'fmMon ddth, yyyy') AS GameDate
    FROM tbldatgames
    WHERE (hometeam = &teamID OR visitteam = &teamID) 
        AND gamedatetime > sysdate
    ORDER BY gamedatetime;

/*
5. Show a list of teams in each division in the database.  
-	include the long division name and the long team name
-	sort the output by the divisions display order and then by team name
-	only show divisions that are active and teams that are active
-	include all active divisions, even if they contain no teams
*/

SELECT divnamelong AS DivName, teamnamelong AS Team
    FROM tbllistdivisions d LEFT OUTER JOIN tbljncteamsdivs j USING (divid)
        LEFT OUTER JOIN tbldatteams t USING (teamid)
    WHERE d.isactive = 1 AND t.isactive = 1 OR teamnamelong IS NULL
    ORDER BY d.displayorder, Team;
 
/*
6. List all the used jersey (shirt) numbers in the league along with the total number of players whom use that number
-	order the results showing the most used number first
-	only show results for those numbers used more than once
*/

SELECT  JerseyNumber, COUNT(rosterid) AS NumUses
    FROM tbljncrosters
    GROUP BY JerseyNumber
    HAVING COUNT(rosterid) > 1
    ORDER BY NumUses DESC;
