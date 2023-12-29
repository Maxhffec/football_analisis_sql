-- Select unique teams that played either as a home or away team at least once
select distinct home_team from results
union 
select distinct away_team from results; 

-- Select all records of goalscorers from teams whose names start with 'Uni'
select * from goalscorers 
where team Like 'Uni%';

-- Count the number of matches played after January 1, 2015
select COUNT(*) from results where date > '2015-01-01';

-- Select dates of matches where more than 16 goals were scored
select date from results
where home_score + away_score > 16;

-- Calculate the total sum of goals scored in all matches
select sum(home_score + away_score) as total_goals from results;

-- Count the total number of games played
select count(date) as total_games from results;

-- Select the average number of home goals scored
select avg(home_score) from results;

-- Select the maximum and minimum goals scored in a single match
select Max(home_score + away_score) as max_goals, min(home_score + away_score) as min_goals from results;

-- Calculate total home goals scored for each home team
select home_team, sum(home_score) as total_home_goals
from results
group by home_team;

-- Select teams that scored more than 100 home goals
select home_team, sum(home_score) as matches_with_more_10_home
from results
group by home_team
having sum(home_score) > 100;

-- Count the total number of unique teams in home and away columns
SELECT COUNT(DISTINCT home_team) + COUNT(DISTINCT away_team) AS total_unique_teams FROM results;

-- Select dates where more than 15 matches were played
select date, Count(*) as matches_played
from results
group by date
having matches_played > 15;

-- Count wins, draws, and losses for each team
select team,
sum(case when home_score > away_score then 1 else 0 end) as wins,
sum(case when home_score = away_score then 1 else 0 end) as draw,
sum(case when home_score < away_score then 1 else 0 end) as looses
from(select home_team as team, home_score,away_score from results
union all
select away_team as team, home_score,away_score from results) as combined_results
group by team
order by team;

-- Select match results that ended in penalty shootout and did not have own goals
SELECT * FROM results
WHERE (home_team, away_team) IN (SELECT home_team, away_team FROM shootouts WHERE winner = 'penalty')
AND (home_team, away_team) NOT IN (SELECT home_team, away_team FROM goalscorers WHERE own_goal = 1);

-- Add a column indicating if the home team won the match
select *, 
case 
 when home_score > away_score then 'yes'
 else 'no'
 end as home_team_won
 from results;

-- Select teams that scored more than 1000 home goals
select home_team,sum(home_score) as home_team_goals
from results
group by home_team
having home_team_goals > 1000;

-- Select match dates in descending order
select date from results
order by date Desc;

-- Select match results where there is a recorded penalty shootout winner
select * from results 
where (home_team,away_team) in(select home_team,away_team from shootouts where winner is not null)

-- Combine match results from 'results' table and goal scorers
SELECT date, home_team, away_team FROM results
union 
SELECT date, home_team, away_team FROM goalscorers;

-- Merge all matches from 'results' table and shootouts
WITH AllMatches AS (
    SELECT date, home_team, away_team FROM results
    UNION ALL
    SELECT date, home_team, away_team FROM shootouts
)
SELECT * FROM AllMatches;

-- Add a column with the average home goals scored and the difference from the average
SELECT *,
   AVG(home_score)  OVER(PARTITION BY home_team) AS avg_home_goals,
home_score - AVG(home_score) OVER(PARTITION BY home_team) AS diff_from_avg
FROM results;

-- Merge data from results and goal scorers based on home team
select * from results
inner join goalscorers on results.home_team = goalscorers.team;

-- Select all data from results and goal scorers, joining based on dates and teams
SELECT *
FROM results
left JOIN goalscorers ON results.date = goalscorers.date
AND (results.home_team = goalscorers.home_team OR results.away_team = goalscorers.away_team);

-- Select all data from results and goal scorers, joining based on dates
select * from results
inner join goalscorers on results.date = goalscorers.date;

