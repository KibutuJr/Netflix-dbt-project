-- ====================================================
-- Analysis: Rating Distribution Across Genres
-- ====================================================
SELECT
    g.value::string AS genre,
    AVG(r.rating) AS average_rating,
    COUNT(DISTINCT m.movie_id) AS total_movies
FROM MOVIELENS.DEV.fct_ratings r
JOIN MOVIELENS.DEV.dim_movies m 
    ON r.movie_id = m.movie_id,
    LATERAL FLATTEN(input => m.genres) g
GROUP BY genre
ORDER BY average_rating DESC;
