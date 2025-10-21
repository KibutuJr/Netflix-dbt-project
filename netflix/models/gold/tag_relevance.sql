-- ====================================================
-- Analysis: Tag Relevance
-- ====================================================
{{ config(materialized='view') }}

SELECT
    t.tag_name,
    AVG(gs.relevance_score) AS avg_relevance,
    COUNT(DISTINCT gs.movie_id) AS movie_tagged
FROM {{ ref('fct_genome_scores') }} gs
JOIN {{ ref('dim_genome_tags') }} t 
  ON gs.tag_id = t.tag_id
GROUP BY t.tag_name
ORDER BY avg_relevance DESC

