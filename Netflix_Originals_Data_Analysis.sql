-- FINAL PROJECT

/* Project Title --
Netflix Originals Data Analysis: Exploring Trends and Insights */

CREATE DATABASE FINAL_PROJECT;
USE FINAL_PROJECT;

/* Project Description --
This SQL project analyzes a hypothetical dataset of Netflix Originals to uncover trends in genres, IMDb ratings, runtimes, and more. 
The goal is to demonstrate practical SQL querying skills using a small relational schema with joins, aggregation, window functions, and filtering. */

/* Database Schema -- 
We use two tables:-

Netflix_Originals-
Column			Type			Description
Title			TEXT			Name of the Netflix Original
IMDBScore		DECIMAL			IMDb rating
Runtime			INT				Runtime in minutes
GenreID			INT				Foreign key to Genre_Details table

Genre_Details-
Column			Type			Description
GenreID			INT				Primary key
Genre			TEXT			Name of the genre 
*/

-- Q.1/ What are the average IMDb scores for each genre of Netflix Originals?
SELECT gd.genre, AVG(no.IMDBScore) AS avg_imdb FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID
GROUP BY gd.genre;
 
-- Q.2/ Which genres have an average IMDb score higher than 7.5?
SELECT gd.genre, AVG(no.IMDBScore) AS avg_imdb FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID
GROUP BY gd.genre
HAVING avg_imdb > 7.5;

-- Q.3/ List Netflix Original titles in descending order of their IMDb scores.
SELECT title, IMDBScore FROM Netflix_Originals ORDER BY IMDBScore DESC;
 
-- Q.4/ Retrieve the top 10 longest Netflix Originals by runtime. 
SELECT title, Runtime FROM Netflix_Originals
ORDER BY runtime DESC
LIMIT 10;

-- Q.5/ Retrieve the titles of Netflix Originals along with their respective genres. 
SELECT no.title, gd.genre FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID;

-- Q.6/ RankNetflix Originals based on their IMDb scores within each genre.
SELECT no.title, gd.genre, no.IMDBScore,
    RANK() OVER (PARTITION BY gd.genre ORDER BY no.IMDBScore DESC) AS rank_within_genre
FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID;

-- Q.7/ Which Netflix Originals have IMDb scores higher than the average IMDb score of all titles?
SELECT title, IMDBScore FROM Netflix_Originals
WHERE IMDBScore > (
    SELECT AVG(IMDBScore) FROM Netflix_Originals
);
 
-- Q.8/ HowmanyNetflix Originals are there in each genre? 
SELECT gd.genre, COUNT(*) AS total_titles FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID
GROUP BY gd.genre;

-- Q.9/ Which genres have more than 5 Netflix Originals with an IMDb score higher than 8?
SELECT gd.genre, COUNT(*) AS high_rating_count FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID
WHERE no.IMDBScore > 8
GROUP BY gd.genre
HAVING high_rating_count > 5;

-- Q.10/ Whatare the top 3 genres with the highest average IMDb scores, and how many Netflix Originals do they have?
SELECT genre, ROUND(AVG(IMDBScore), 2) AS avg_score, COUNT(*) AS total_titles FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID
GROUP BY genre
ORDER BY avg_score DESC
LIMIT 3;

-- Q.11/ What is the highest-rated Netflix Original in each genre?
SELECT title, genre, IMDBScore
FROM (
  SELECT no.title, gd.genre, no.IMDBScore,
         ROW_NUMBER() OVER (PARTITION BY gd.genre ORDER BY no.IMDBScore DESC) AS rn
  FROM Netflix_Originals no
  JOIN Genre_Details gd ON no.GenreID = gd.GenreID
) ranked
WHERE rn = 1;

-- Q.12/ What is the total runtime of Netflix Originals per genre?
SELECT gd.genre, SUM(no.Runtime) AS total_runtime_minutes
FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID
GROUP BY gd.genre;

-- Q.13/ List all Netflix Originals with duplicate titles.
SELECT title, COUNT(*) AS duplicate_count
FROM Netflix_Originals
GROUP BY title
HAVING COUNT(*) > 1;

-- Q.14/ Show all titles where the genre name appears in the title (partial match).
SELECT no.title, gd.genre
FROM Netflix_Originals no
JOIN Genre_Details gd ON no.GenreID = gd.GenreID
WHERE no.title LIKE CONCAT('%', gd.genre, '%');

-- Q.15/ How many Netflix Originals have an IMDb score between 7 and 9?
SELECT COUNT(*) AS titles_in_range
FROM Netflix_Originals
WHERE IMDBScore BETWEEN 7 AND 9;
