  # Netflix Movies and TV Shows Data Analysis Using SQL
![Netflix_logo](https://github.com/Pradhnya1209/netflix_sql_p3/blob/main/BrandAssets_Logos_01-Wordmark.jpg)
## Objective
This project xyx

##Schemas
'''sql
  CREATE TABLE Netflix_data
  (
  	show_id VARCHAR(10),
  	type VARCHAR(15),
  	title VARCHAR (200),
  	director VARCHAR(500),
  	casts VARCHAR (1000),
  	country VARCHAR(200),
  	date_added VARCHAR(50),
  	release_year INT,
  	rating VARCHAR (15),
  	duration VARCHAR (20),
  	listed_in VARCHAR (150),
  	description VARCHAR (1000)
  )
'''sql

##Tasks
###1. Count the Number of Movies vs TV Shows
   '''sql
    SELECT
    	type,
    	COUNT(type)
    FROM
    	netflix_data
    GROUP BY 1;
   '''sql

###2. Find the Most Common Rating for Movies and TV Shows
'''sql
  SELECT
	type,
	rating,
	ratingcount
FROM
(
SELECT
	type,
	rating,
	COUNT(rating) AS ratingcount,
	RANK() OVER (PARTITION BY type ORDER BY COUNT(rating) DESC) as ranks
FROM
	netflix_data
GROUP BY 1,2)
AS ranked_data
WHERE
	ranks=1;
'''sql
