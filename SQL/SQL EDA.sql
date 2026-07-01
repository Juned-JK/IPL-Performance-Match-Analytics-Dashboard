use cricketdata;

select * from ipl limit 10;
select count(distinct match_id) from ipl;
select count(distinct date)from ipl;

select batting_team as Team , count( distinct match_id) as total_matches from ipl group by batting_team;
select match_won_by as Team , count( distinct match_id) as Match_won from ipl group by match_won_by;
select toss_winner as Team , count( distinct match_id) as Toss_won from ipl group by toss_winner;

with cte as (
select distinct match_id, batting_team as team, match_won_by from ipl 
union
select distinct match_id, bowling_team as team, match_won_by from ipl)
select team, COUNT(match_id) AS total_matches_played,
sum(case when team = match_won_by then 1 else 0 end) as matches_won,
round((sum(case when team = match_won_by then 1 else 0 end) * 100 / count(match_id)), 2)as win_percentage from cte group by team order by win_percentage desc;

select * from ipl limit 10;
select batter, sum(runs_batter) as total_runs,sum(balls_faced) from ipl group by batter order by total_runs desc limit 20;
select batter, (sum(runs_batter) /count( distinct match_id)) as avg_runs from ipl group by batter order by avg_runs desc limit 20;
select batter, max(batter_runs) as Highest_runs from ipl group by batter order by Highest_runs desc limit 20;
select batter, sum(case when runs_total = 4 then 1 else 0 end) as Total_num_of_fours from ipl group by batter order by Total_num_of_fours desc limit 20;
select batter, sum(case when runs_total = 6 then 1 else 0 end) as Total_num_of_six from ipl group by batter order by Total_num_of_six desc limit 20;
select batter,round(sum(runs_batter)/sum(balls_faced) * 100,2)  as strike_rate from ipl group by batter order by strike_rate desc; 
select season,batter , sum(runs_batter) from ipl group  by season, batter;

select * from ipl limit 10;
select bowler, sum(bowler_wicket) as Total_wickets from ipl group by bowler order by Total_wickets desc;
SELECT  bowler, SUM(runs_bowler) AS runs_conceded, COUNT(valid_ball) AS total_valid_balls, ROUND((SUM(runs_bowler) * 6.0) / COUNT(valid_ball), 2) AS economy_rate 
FROM ipl WHERE valid_ball = 1 GROUP BY bowler LIMIT 20;
select bowler, SUM(runs_bowler) AS runs_conceded, sum(bowler_wicket) as total_wickets, round(SUM(runs_bowler)/sum(bowler_wicket) ,2) as Bowling_Average 
from ipl group by bowler having sum(bowler_wicket) > 0 order by total_wickets desc;
select season,bowler , sum(bowler_wicket) from ipl group  by season, bowler;

select * from ipl limit 10;
select batting_team, max(team_runs) from ipl group by batting_team;
select batting_team, min(case when team_balls = 120 then team_runs end) as lowest_score from ipl group by batting_team limit 10;

select venue, count(distinct match_id) as total_matches from ipl group by venue order by total_matches desc ;

with cte as (
select season, batter, sum(runs_batter) as total_runs, rank() over (partition by season order by sum(runs_batter) desc) as `rank` from ipl GROUP BY season, batter )
select season, batter, total_runs from cte where `rank` = 1 order by season;

with cte as (
 select season, bowler, sum(bowler_wicket) as total_wickets, rank() over (partition by season order by sum(bowler_wicket) desc) as `rank` from ipl group by season, bowler)
 select season, bowler, total_wickets from cte where `rank` = 1 order by season;
 
select season, sum(runs_batter) as total_runs from ipl group by season order by season;
select season, batting_team as Team, sum(runs_batter) as total_runs from ipl group by season, batting_team order by season;

select season, sum(case when runs_batter = 6 then 1 else 0 end) as total_sixes from ipl group by season;
select season,batter, sum(case when runs_batter = 6 then 1 else 0 end) as total_sixes from ipl group by season , batter having total_sixes > 0;

select season, sum(case when runs_batter = 4 then 1 else 0 end) as total_fours from ipl group by season;
select season,batter, sum(case when runs_batter = 4 then 1 else 0 end) as total_fours from ipl group by season , batter having total_fours > 0;

with cte as (
select season, batter, sum(case when runs_batter = 4 then 1 else 0 end) as total_fours, row_number() over (partition by season order by 
sum(case when runs_batter = 4 then 1 else 0 end) desc) as rn from ipl group by season, batter)
select season, batter, total_fours, rn as `rank` from cte where rn  < 6 ;

with cte as (
select season, batter, sum(case when runs_batter = 6 then 1 else 0 end) as total_sixes, row_number() over (partition by season order by 
sum(case when runs_batter = 6 then 1 else 0 end) desc) as rn from ipl group by season, batter)
select season, batter, total_sixes, rn as `rank` from cte where rn  < 6 ;

select player_of_match, count(distinct match_id) as POTM from ipl group by player_of_match order by POTM desc;
