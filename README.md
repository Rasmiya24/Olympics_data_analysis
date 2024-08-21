# Olympics_data_analysis
This repository contains a collection of SQL queries that analyze and extract insights from an Olympics database. The database schema consists of two tables: OLYMPICS_HISTORY and OLYMPICS_HISTORY_NOC_REGIONS.

Database Schema
OLYMPICS_HISTORY
Column Name	    Data Type	    Description
id	            INT	          Unique identifier for each athlete
name	          VARCHAR	      Athlete's name
sex	            VARCHAR	      Athlete's sex (Male/Female)
age            	VARCHAR	      Athlete's age
height	        VARCHAR	      Athlete's height
weight	        VARCHAR	      Athlete's weight
team	          VARCHAR	      Athlete's team/country
noc	            VARCHAR	      National Olympic Committee code
games	          VARCHAR	      Olympic games (e.g., Summer/Winter)
year	          INT	          Year of the Olympic games
season	        VARCHAR	      Season of the Olympic games (Summer/Winter)
city	          VARCHAR	      Host city of the Olympic games
sport          	VARCHAR	      Sport played by the athlete
event	          VARCHAR	      Event played by the athlete
medal	          VARCHAR	      Medal won by the athlete (Gold/Silver/Bronze)

OLYMPICS_HISTORY_NOC_REGIONS
Column Name	    Data Type	      Description
noc	            VARCHAR	        National Olympic Committee code
region	        VARCHAR	        Region corresponding to the NOC code
notes	          VARCHAR	        Additional notes about the region

Queries
This contains SQL queries that answer various questions about the Olympics database.
* How many Olympics games have been held?
* List down all Olympics games held so far.
* Mention the total number of nations who participated in each Olympics game.
* Which nation has participated in all of the Olympic games?
* Identify the sport which was played in all summer Olympics.
* Which Sports were just played only once in the Olympics?
* Fetch the total number of sports played in each Olympic game.
* Fetch details of the oldest athletes to win a gold medal.
* Find the Ratio of male and female athletes participated in all Olympic games.
* Fetch the top 5 athletes who have won the most gold medals.
* Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
* Fetch the top 5 most successful countries in Olympics.
* List down total gold, silver, and bronze medals won by each country.
* List down total gold, silver, and bronze medals won by each country corresponding to each Olympic game.
* Which countries have never won a gold medal but have won silver/bronze medals?
* In which Sport/event, India has won the highest medals.
* Break down all Olympic games where India won a medal for Hockey and how many medals in each Olympic game.
