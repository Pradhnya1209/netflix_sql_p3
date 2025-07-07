DROP TABLE IF EXISTS netflix_data;
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

select*
from netflix_data

--TASKS
-- 1. Count the Number of Movies vs TV Shows
SELECT
	type,
	COUNT(type)
FROM
	netflix_data
GROUP BY 1;

--2. Find the Most Common Rating for Movies and TV Shows

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

--3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT
	title,
	release_year
FROM
	netflix_data
WHERE
	TYPE='Movie'
	AND
	release_year='2020';

--4. Find the Top 5 Countries with the Most Content on Netflix
SELECT*
FROM
(
SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	count(show_id) as total_content
FROM
	netflix_data
GROUP BY 1
) AS t1
WHERE new_country is NOT NULL
ORDER BY total_content DESC
LIMIT 5;

--5. Identify the Longest Movie

SELECT 
    *
FROM netflix_data
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;

--6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix_data
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT*
FROM
(SELECT
	*,
	UNNEST(STRING_TO_ARRAY(director,',')) as director_name
FROM
	netflix_data) AS T
WHERE
	director_name = 'Rajiv Chilaka'


--8. List All TV Shows with More Than 5 Seasons

SELECT*	
FROM
	netflix_data
WHERE type = 'TV Show'
	AND SPLIT_PART(duration, ' ', 1)::INT > 5;

--9. Count the Number of Content Items in Each Genre
SELECT
	COUNT(*) AS total_content,
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre
FROM
	netflix_data
GROUP BY 2
ORDER BY 1 DESC;

--10.Find each year and the average numbers of content release in India on netflix.
--return top 5 year with highest avg content release!

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

--11. List All Movies that are Documentaries
SELECT*
FROM
	netflix_data
WHERE
	listed_in LIKE '%Documentaries%';

--12. Find All Content Without a Director
SELECT*
FROM
	netflix_data
WHERE director IS NULL;

--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT*
FROM
	netflix_data
WHERE casts LIKE '%Salman Khan%'
	AND release_year>= EXTRACT(YEAR FROM CURRENT_DATE)-10;


--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	COUNT(*)
FROM
	netflix_data
WHERE country = 'India'
GROUP BY 1
ORDER BY COUNT(*) DESC
LIMIT 10;

--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT
	category,
	COUNT (*) AS Content_count
FROM
(
	SELECT
		CASE
			WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
			ELSE 'Good'
			END AS category
	FROM
		netflix_data
) AS categorized_content
GROUP BY 1;

