-- Select database
USE movie_db;

--View available tables
SHOW TABLES;

--Preview data from both tables
SELECT * FROM movies LIMIT 10;
SELECT * FROM ratings LIMIT 10;

--Check total number of records in each table
SELECT 
    (SELECT COUNT(*) FROM movies) AS total_movies,
    (SELECT COUNT(*) FROM ratings) AS total_ratings;

--Show top 10 movies by IMDb rating (from OMDb API)
SELECT 
    title AS Movie_Title, 
    imdb_rating AS IMDb_Rating
FROM movies
WHERE imdb_rating IS NOT NULL
ORDER BY imdb_rating DESC
LIMIT 10;

--Show top 10 movies by average user rating
SELECT 
    m.title AS Movie_Title,
    ROUND(AVG(r.rating), 2) AS Average_User_Rating,
    COUNT(r.user_id) AS Total_Ratings
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY Average_User_Rating DESC
LIMIT 10;

--Compare IMDb Rating vs Average User Rating
SELECT 
    m.title AS Movie_Title,
    m.imdb_rating AS IMDb_Rating,
    ROUND(AVG(r.rating), 2) AS Average_User_Rating
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.title, m.imdb_rating
ORDER BY Average_User_Rating DESC
LIMIT 10;

--Show movies that have no user ratings
SELECT 
    m.title AS Movie_Title
FROM movies m
LEFT JOIN ratings r ON m.movie_id = r.movie_id
WHERE r.movie_id IS NULL;

--Find movies with the most number of ratings
SELECT 
    m.title AS Movie_Title,
    COUNT(r.rating) AS Total_Ratings
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY Total_Ratings DESC
LIMIT 10;

--Average rating by primary genre (first genre listed)
SELECT 
    SUBSTRING_INDEX(m.genre, '|', 1) AS Primary_Genre,
    ROUND(AVG(r.rating), 2) AS Avg_User_Rating
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY Primary_Genre
ORDER BY Avg_User_Rating DESC;

--Count of movies per genre category (based on first genre)
SELECT 
    SUBSTRING_INDEX(genre, '|', 1) AS Primary_Genre,
    COUNT(*) AS Total_Movies
FROM movies
GROUP BY Primary_Genre
ORDER BY Total_Movies DESC;

--Find top 5 directors with highest average IMDb ratings
SELECT 
    director,
    ROUND(AVG(imdb_rating), 2) AS Avg_IMDb_Rating,
    COUNT(*) AS Total_Movies
FROM movies
WHERE imdb_rating IS NOT NULL AND director IS NOT NULL
GROUP BY director
ORDER BY Avg_IMDb_Rating DESC
LIMIT 5;