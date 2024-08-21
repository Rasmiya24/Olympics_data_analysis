
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY
(
    id          INT,
    name        VARCHAR,
    sex         VARCHAR,
    age         VARCHAR,
    height      VARCHAR,
    weight      VARCHAR,
    team        VARCHAR,
    noc         VARCHAR,
    games       VARCHAR,
    year        INT,
    season      VARCHAR,
    city        VARCHAR,
    sport       VARCHAR,
    event       VARCHAR,
    medal       VARCHAR
);

DROP TABLE IF EXISTS OLYMPICS_HISTORY_NOC_REGIONS;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY_NOC_REGIONS
(
    noc         VARCHAR,
    region      VARCHAR,
    notes       VARCHAR
);

------------------------------------------

--- How many olympics games have been held?
SELECT COUNT(DISTINCT games) AS total_games
FROM olympics_history;
	
--- List down all Olympics games held so far.
SELECT DISTINCT year, season, city
FROM olympics_history
ORDER BY year;
	
--- Mention the total no of nations who participated in each olympics game?
WITH all_countries AS
	(SELECT games, NR.region 
	FROM olympics_history AS oh
	JOIN olympics_history_noc_regions AS nr
	ON nr.noc = oh.noc
	GROUP BY games, nr.region)
SELECT games, COUNT(1) AS total_countries
FROM all_countries
GROUP BY games
ORDER BY games;
		
--- Which nation has participated in all of the olympic games?
WITH tot_games AS
	(SELECT COUNT(DISTINCT games) AS total_games
	FROM olympics_history),
countries AS
	(SELECT games, NR.region AS country
	FROM olympics_history AS oh
	JOIN olympics_history_noc_regions AS nr
	ON nr.noc = oh.noc
	GROUP BY games, nr.region),
countries_participated AS
	(SELECT country, COUNT(1) AS total_participated_games
	FROM countries
	GROUP BY country)
SELECT cp.*
FROM countries_participated AS cp
JOIN tot_games AS tg 
ON tg.total_games = cp.total_participated_games
ORDER BY 1;
	
--- Identify the sport which was played in all summer olympics.
WITH T1 AS
	(SELECT COUNT(DISTINCT games) AS total_summer_games
	FROM olympics_history
	WHERE season = 'Summer'),
T2 AS
	(SELECT DISTINCT sport, games
	FROM olympics_history
	WHERE season = 'Summer'
	ORDER BY games),
T3 AS
	(SELECT sport, COUNT(games) AS no_of_games
	FROM T2
	GROUP BY sport)
SELECT *
FROM T3
JOIN T1
ON T1.total_summer_games = T3.no_of_games;
	
--- Which Sports were just played only once in the olympics?
WITH T1 AS
	(SELECT DISTINCT games, sport
	FROM olympics_history),
T2 AS
	(SELECT sport, COUNT(1) AS no_of_games
	FROM T1
	GROUP BY sport)
SELECT T2.*, T1.games
FROM T2
JOIN T1
ON T1.sport = T2.sport
WHERE T2.no_of_games = 1
ORDER BY T1.sport;
	
--- Fetch the total no of sports played in each olympic games.
WITH T1 AS
	(SELECT DISTINCT games, sport
	FROM olympics_history),
T2 AS
	(SELECT games, COUNT(1) AS no_of_sports
	FROM T1
	GROUP BY games)
SELECT * 
FROM T2
ORDER BY no_of_sports DESC;
	
--- Fetch details of the oldest athletes to win a gold medal.
WITH temp as
	(SELECT name, sex, cast(CASE WHEN age = 'NA' THEN '0' ELSE age END AS int) AS age,team,games,city,sport, event, medal
     FROM olympics_history),
ranking AS
	(SELECT *, RANK() OVER(ORDER BY age DESC) AS rnk
     FROM temp
     WHERE medal = 'Gold')
SELECT *
FROM ranking
WHERE rnk = 1;

--- Find the Ratio of male and female athletes participated in all olympic games.
WITH T1 AS
	(SELECT sex, COUNT(1) AS cnt
	FROM olympics_history
	GROUP BY sex),
T2 AS
	(SELECT *, ROW_NUMBER() OVER(ORDER BY cnt) AS rn
	FROM T1),
min_cnt AS
	(SELECT cnt 
	FROM T2
	WHERE rn = 1),
max_cnt AS
	(SELECT cnt 
	FROM T2
	WHERE rn = 2)
SELECT CONCAT('1 : ', ROUND(max_cnt.cnt::decimal/min_cnt.cnt, 2)) AS ratio
FROM min_cnt, max_cnt;
	
--- Fetch the top 5 athletes who have won the most gold medals.
WITH T1 AS
	(SELECT name, team, COUNT(1) AS total_gold_medals
	FROM olympics_history
	WHERE medal = 'GOLD'
	GROUP BY name, team
	ORDER BY total_gold_medals DESC),
T2 AS 
	(SELECT *, dense_rank() OVER(ORDER BY total_gold_medals DESC) AS rnk
	FROM T1)
SELECT name, team, total_gold_medals
FROM T2
WHERE rnk <= 5;

--- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
WITH T1 AS
	(SELECT name, team, COUNT(1) AS total_medals
	FROM olympics_history
	WHERE medal in ('Gold', 'Silver', 'Bronze')
	GROUP BY name, team
	ORDER BY total_medals DESC),
T2 AS
	(SELECT *, dense_rank() OVER(ORDER BY total_medals DESC) AS rnk
	FROM T1)
SELECT name, team, total_medals
FROM T2
WHERE rnk <= 5;
	
--- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
WITH T1 AS
	(SELECT nr.region, COUNT(1) AS total_medals
	FROM olympics_history AS oh
	JOIN olympics_history_noc_regions AS nr
	ON nr.noc = oh.noc
	WHERE medal <> 'NA'
	GROUP BY nr.region
	ORDER BY total_medals DESC),
T2 AS
	(SELECT *, dense_rank() OVER(ORDER BY total_medals DESC) AS rnk
	FROM T1)
SELECT *
FROM T2
WHERE rnk <= 5;

--- List down total gold, silver and broze medals won by each country.
SELECT nr.region AS country,
  SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
  SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
  SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
FROM olympics_history oh
JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
WHERE medal <> 'NA'
GROUP BY nr.region
ORDER BY gold DESC, silver DESC, bronze DESC;
	
--- List down total gold, silver and broze medals won by each country corresponding to each olympic games.
SELECT concat(games) as games, nr.region, 
    SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
FROM olympics_history oh
JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
WHERE medal <> 'NA'
GROUP BY games, nr.region
ORDER BY games, nr.region;
	
--- Which countries have never won gold medal but have won silver/bronze medals?
SELECT nr.region, 
       SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
       SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
       SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
FROM OLYMPICS_HISTORY oh
JOIN OLYMPICS_HISTORY_NOC_REGIONS nr ON nr.noc = oh.noc
WHERE medal <> 'NA'
GROUP BY nr.region
HAVING SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) = 0 
   AND (SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) > 0 
        OR SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) > 0)
ORDER BY gold DESC NULLS LAST, silver DESC NULLS LAST, bronze DESC NULLS LAST;

--- In which Sport/event, India has won highest medals.
WITH T1 AS 
	(SELECT sport, COUNT(1) AS total_medals
	FROM olympics_history
	WHERE medal <> 'NA'
	AND team = 'India'
	GROUP BY sport
	ORDER BY total_medals DESC),
T2 AS
	(SELECT *,
	RANK() OVER(ORDER BY total_medals DESC) AS rnk
	FROM T1)
SELECT sport, total_medals
FROM T2
WHERE rnk = 1;

--- Break down all olympic games where India won medal for Hockey and how many medals in each olympic games.
SELECT team, sport, games, COUNT(1) AS total_medals
FROM olympics_history
WHERE medal <> 'NA'
AND team = 'India' AND sport = 'Hockey'
GROUP BY team, sport, games
ORDER BY total_medals DESC;