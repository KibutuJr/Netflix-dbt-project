{{ config(materialized='view') }}

WITH genre_movies AS (
    SELECT
        g.value::string AS genre,
        m.movie_id,
        m.movie_title,
        AVG(f.rating) AS average_rating
    FROM {{ ref('fct_ratings') }} f
    JOIN {{ ref('dim_movies') }} m 
      ON f.movie_id = m.movie_id,
    LATERAL FLATTEN(input => m.genres) g
    GROUP BY genre, m.movie_id, m.movie_title
)
SELECT *
FROM (
    SELECT
        genre,
        movie_title,
        average_rating,
        ROW_NUMBER() OVER (PARTITION BY genre ORDER BY average_rating DESC) AS rank
    FROM genre_movies
)
WHERE rank <= 10
ORDER BY genre, rank
