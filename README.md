# 🎬 Netflix Data Analysis — End-to-End Data Engineering Project with DBT, Snowflake & AWS

![Netflix Data Analysis Overview](images/analysis.png)

---

## 🧭 Project Overview

Welcome to the **Netflix Data Analysis DBT Project** — an end-to-end **data engineering and analytics pipeline** built using **AWS S3**, **Snowflake**, and **DBT (Data Build Tool)**.

This project simulates a **modern data stack** setup:
- 📁 **Raw CSV data** stored in **AWS S3**
- ❄️ **Snowflake** for staging, schema creation, and transformation
- 🧱 **DBT** for modular data transformation, testing, and documentation
- 📊 **Final visualizations** built from the **Gold layer**

The goal is to derive insights about **movie performance, user engagement, and tag relevance** on Netflix — transforming raw data into clean, analytics-ready datasets.

---

## 🏗️ Architecture & Workflow

![AWS to Snowflake Architecture](images/AWS_to_Snowflake.png)

### Data Flow:
1. **Source:** Raw CSV files in AWS S3  
2. **Ingestion:** Loaded into Snowflake using `COPY INTO`  
3. **Transformation:** Modeled and tested using DBT  
4. **Analytics:** Visualized through SQL and BI tools  
5. **Documentation:** Auto-generated with `dbt docs`

---

## ⚙️ Snowflake Setup

### 🧍 User, Role & Warehouse Creation
![Snowflake User Creation](images/snowflake_user_creation.png)

### 🪣 Load Data from AWS S3
```sql
COPY INTO raw.movies
FROM @aws_s3_stage
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);
````

![Raw Movies Table](images/raw_movies_table.png)

---

## 🧱 DBT Project Setup

### ⚡ Initialize DBT

```bash
dbt init netflix_project
```

![DBT Initialization](images/dbt_init_netflix.png)

Once initialized:

* Configure **profiles.yml** for Snowflake connection
* Create model folders: `staging/`, `intermediate/`, `gold/`
* Define sources, tests, and macros

---

## 🧩 Staging Layer (Bronze → Silver)

![Source Table Definition](images/src_table.png)

The **staging models**:

* Clean and standardize raw data
* Handle data type casting
* Remove duplicates and invalid entries
* Output **views** (no physical tables yet)

```bash
dbt run
```

![DBT Views](images/views_on_dbt.png)
![Views on Snowflake](images/views_on_snowflake.png)

---

## 🧮 Intermediate & Gold Layers

This is where business transformations happen:

* **Dimension tables:** Movies, Users, Genres
* **Fact tables:** Ratings, Engagement, Trends
* Materialized as **tables** in the **dev schema**

![Views](images/views.png)

---

## 🔁 Incremental Models

Used to improve performance and scalability.
Example: `fct_ratings.sql` loads only new or changed data.

```sql
{{ config(materialized='incremental', unique_key='rating_id') }}
```

---

## 🧬 Slowly Changing Dimensions (SCD)

To preserve history, this project implements:

* **SCD Type 1:** Overwrites data
* **SCD Type 2:** Tracks changes with versioning
* **SCD Type 3 & 6:** Combine multiple change-tracking methods

![Snapshots](images/snapshots.png)
![Snapshot Key Example](images/snaptag.png)

Example surrogate key:

```sql
{{ dbt_utils.generate_surrogate_key(['user_id','movie_id','tag']) }} AS row_key
```

---

## 🌱 Seeds

DBT seeds store small static datasets used during transformations.

```bash
dbt seed
```

![Seed Insert Example](images/insert.png)

---

## 🧠 Macros

Macros are reusable SQL snippets that simplify complex queries.

![DBT Macros Example](images/macros.png)

---

## 🧪 Testing & Documentation

Testing ensures **data quality** with schema and custom SQL tests.

Example test:

```sql
SELECT * FROM {{ ref('fct_ratings') }}
WHERE relevance_score <= 0
```

![DBT Test Results](images/test.png)

### Generate Documentation

```bash
dbt docs generate
dbt docs serve
```

![DBT Docs](images/dbt_docs.png)
![DBT Serve UI](images/dbt_serve.png)
![Lineage Graph](images/Lineage_Graph.png)

---

## 📊 Analytical Models (Gold Layer)

Located in `models/gold/`:

* `movie_analysis.sql`
* `genre_ratings.sql`
* `user_engagement.sql`
* `release_trends.sql`
* `tag_relevance.sql`
* `top10_by_genre.sql`
* `monthly_trends.sql`

These create aggregated tables for business analysis and dashboards.

---

## 📈 Visualization & Insights

### 🎬 1. Movie Title vs Average Ratings

![Title vs Average Ratings](images/title_vs_av_rating.png)

### ⭐ 2. Movie Title vs Total Ratings

![Title vs Total Ratings](images/title_vs_tot_rating.png)

### 🏷️ 3. Tag Relevance Test

![Relevance Score Test](images/relevant_score_test.png)

---

## 🧾 Analytical Highlights

| Category               | Description                             |
| ---------------------- | --------------------------------------- |
| 🎥 **Movie Analysis**  | Focuses on movies with ≥100 ratings     |
| ⭐ **Genre Ratings**    | Shows rating distributions by genre     |
| 👥 **User Engagement** | Analyzes number of ratings per user     |
| 🕒 **Release Trends**  | Trends in movie releases and popularity |
| 🏷️ **Tag Relevance**  | Tag importance and frequency analysis   |
| 📈 **Top 10 by Genre** | Best-performing titles per genre        |
| 📆 **Monthly Trends**  | Seasonal and monthly viewing patterns   |

---

## 💡 Key Learnings

✅ Built an end-to-end **data pipeline** from AWS → Snowflake → DBT
✅ Implemented **incremental models** and **ephemeral logic**
✅ Designed **Slowly Changing Dimensions (SCD 1–6)**
✅ Developed **automated data tests** and **macros**
✅ Generated **data documentation** and lineage graphs
✅ Delivered **actionable insights** via analytics-ready tables

---

## 🧰 Tech Stack

| Tool                                | Purpose                           |
| ----------------------------------- | --------------------------------- |
| 🪣 **AWS S3**                       | Data lake for raw CSV storage     |
| ❄️ **Snowflake**                    | Cloud data warehouse              |
| 🧱 **DBT**                          | Data transformation and testing   |
| 🐍 **Python**                       | Script automation and ETL support |
| 🧾 **SQL**                          | Core transformation logic         |
| 📊 **Power BI / SQL Visualization** | Insight generation and reporting  |

---

## 🚀 Conclusion

This project demonstrates a **production-ready data pipeline** that converts raw streaming data into actionable business insights.

It highlights how **DBT brings modularity, testing, and documentation** to modern data workflows — empowering analytics teams to move faster with confidence.

![Final DBT Overview](images/views_on_dbt.png)

---

## 👨‍💻 Author

**Fred Kibutu**
*Data Engineer • Data Analyst • Web Developer*

> 🚀 Building intelligent pipelines that turn raw data into business gold.

📫 **Connect With Me:**

* 🌐 Portfolio: [https://kibutujr.github.io](https://kibutujr.github.io)
* 💼 LinkedIn: [https://www.linkedin.com/in/fredkibutu](https://www.linkedin.com/in/fredkibutu)
* 📧 Email: [fredkibutu@gmail.com](mailto:fredkibutu@gmail.com)

---

```

Would you like me to add **GitHub badges** (for Python, DBT, Snowflake, AWS, License, etc.) at the top to make it look even more polished like a professional open-source repo?
```
