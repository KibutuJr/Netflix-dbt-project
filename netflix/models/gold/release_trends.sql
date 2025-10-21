-- ====================================================
-- Analysis: Trends of Movie Releases Over Time
-- ====================================================
{{ config(materialized='view') }}

SELECT
    EXTRACT(YEAR FROM release_date) AS release_year,
    COUNT(DISTINCT movie_id) AS movies_released
FROM {{ ref('seed_movie_release_dates') }}
GROUP BY release_year
ORDER BY release_year ASC

