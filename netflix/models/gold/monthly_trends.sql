-- ====================================================
-- Monthly User Activity Trends
-- ====================================================
{{ config(materialized='view') }}

SELECT
    DATE_TRUNC(month, rating_timestamp) AS month,
    COUNT(*) AS total_ratings,
    AVG(rating) AS avg_rating
FROM {{ ref('fct_ratings') }}
GROUP BY month
ORDER BY month

