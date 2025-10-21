-- ====================================================
-- 1️⃣ Movie Ratings Summary
-- ====================================================
WITH ratings_summary AS (
    SELECT
        movie_id,
        AVG(rating) AS average_rating,
        COUNT(*) AS total_ratings
    FROM MOVIELENS.DEV.fct_ratings
    GROUP BY movie_id
    HAVING COUNT(*) > 100  -- Only movies with at least 100 ratings
)
SELECT
    m.movie_title,
    rs.average_rating,
    rs.total_ratings
FROM ratings_summary rs
JOIN MOVIELENS.DEV.dim_movies m 
    ON m.movie_id = rs.movie_id
ORDER BY rs.average_rating DESC;

-- ====================================================
-- 2️⃣ Analysis: Rating Distribution Across Genres
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

-- ====================================================
-- 3️⃣ Analysis: User Engagement (Ratings per User)
-- ====================================================
SELECT
    user_id,
    COUNT(*) AS number_of_ratings,
    AVG(rating) AS average_rating_given
FROM MOVIELENS.DEV.fct_ratings
GROUP BY user_id
ORDER BY number_of_ratings DESC;


-- ====================================================
-- 4️⃣ Analysis: Trends of Movie Releases Over Time
-- ====================================================
SELECT
    EXTRACT(YEAR FROM release_date) AS release_year,
    COUNT(DISTINCT movie_id) AS movies_released
FROM MOVIELENS.DEV.seed_movie_release_dates
GROUP BY release_year
ORDER BY release_year ASC;


-- ====================================================
-- 5️⃣ Analysis: Tag Relevance
-- ====================================================
SELECT
    t.tag_name,
    AVG(gs.relevance_score) AS avg_relevance,
    COUNT(DISTINCT gs.movie_id) AS movies_tagged
FROM MOVIELENS.DEV.fct_genome_scores gs
JOIN MOVIELENS.DEV.dim_genome_tags t 
    ON gs.tag_id = t.tag_id
GROUP BY t.tag_name
ORDER BY avg_relevance DESC;

-- ====================================================
-- 6️⃣ Top 10 Most Rated Movies by Genre
-- ====================================================
WITH genre_ratings AS (
    SELECT
        m.movie_title,
        g.value::string AS genre,
        COUNT(r.rating) AS total_ratings,
        AVG(r.rating) AS avg_rating
    FROM MOVIELENS.DEV.fct_ratings r
    JOIN MOVIELENS.DEV.dim_movies m 
        ON r.movie_id = m.movie_id,
        LATERAL FLATTEN(input => m.genres) g
    GROUP BY m.movie_title, genre
)
SELECT *
FROM (
    SELECT
        genre,
        movie_title,
        total_ratings,
        avg_rating,
        ROW_NUMBER() OVER (PARTITION BY genre ORDER BY total_ratings DESC) AS rank
    FROM genre_ratings
)
WHERE rank <= 10
ORDER BY genre, rank;

-- ====================================================
-- 7️⃣ Monthly User Activity Trends
-- ====================================================
SELECT
    DATE_TRUNC('month', rating_timestamp) AS rating_month,
    COUNT(DISTINCT user_id) AS active_users,
    COUNT(*) AS total_ratings,
    AVG(rating) AS avg_rating
FROM MOVIELENS.DEV.fct_ratings
GROUP BY rating_month
ORDER BY rating_month ASC;


