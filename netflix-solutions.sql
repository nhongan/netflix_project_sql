-- Netflix
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
)

SELECT * FROM netflix;

-- 1. Total number of Movies & TV shows 

SELECT 
	type, 
	COUNT(*) AS total_number
FROM netflix 
GROUP BY type;

-- 2. The most common rating for Movies & TV shows
WITH cte AS (
	SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
	FROM netflix
	GROUP BY 1,2)
SELECT type, rating FROM cte WHERE ranking = 1

-- 3. List All Movies Released in 2021
SELECT 
	title,
	type,
	release_year
FROM netflix
WHERE type = 'Movie' AND release_year = 2021


-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(country,', ')) AS country_formatted,
	COUNT(show_id) AS total_show
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 5. Find the title of Longest Movie
SELECT 
	 title,
	 type,
	 duration
FROM netflix
WHERE 
	type = 'Movie'
	AND duration = (SELECT MAX(duration) FROM netflix)

-- 6. Find Content Added in the Last 5 Years
SELECT 
	*
FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'

-- 7. Find All Movies/TV Shows by Director 'Cristina Jacob'
SELECT * 
FROM netflix
WHERE director LIKE '%Cristina Jacob%'


-- 8. List All TV Shows with More Than 5 Seasons
SELECT * FROM netflix
WHERE 
	type = 'TV Show' 
	AND SPLIT_PART(duration, ' ',1)::numeric > 5

-- 9. Count the Number of Content Items in Each Genre
WITH cte AS (
	SELECT
		show_id,
		UNNEST(STRING_TO_ARRAY(listed_in,', ')) AS genre
	FROM netflix
)
SELECT 
	genre,
	COUNT(*) AS total_content
FROM cte
GROUP BY 1
ORDER BY 2

-- 10. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords in Description
SELECT 
	category,
	COUNT(*) AS content_count
FROM (
	SELECT 
		CASE WHEN description LIKE '%kill%' OR description LIKE 'violence' THEN 'Bad' ELSE 'Good'
		END AS category
	FROM netflix
) AS categorized_content
GROUP BY category
	
