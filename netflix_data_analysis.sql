-- Step 1: Create Database and Schema
CREATE OR REPLACE DATABASE netflix_db;
USE SCHEMA netflix_db.PUBLIC;

-- Step 2: Create Table
CREATE OR REPLACE TABLE netflix_data (
    show_id STRING,
    type STRING,
    title STRING,
    director STRING,
    cast STRING,
    country STRING,
    date_added STRING,
    release_year INT,
    rating STRING,
    duration STRING,
    listed_in STRING,
    description STRING,
    insertion_timestamp TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Data Transformation - Create a View to Clean and Analyze
-- This view filters nulls, extracts primary genre, and formats country names
CREATE OR REPLACE VIEW cleaned_netflix_data AS
SELECT
    show_id,
    type,
    title,
    COALESCE(NULLIF(director, ''), 'Unknown') AS director,
    COALESCE(NULLIF(country, ''), 'Unknown') AS country,
    TRY_TO_DATE(date_added, 'MMMM d, yyyy') AS added_date,
    release_year,
    rating,
    duration,
    SPLIT_PART(listed_in, ',', 1) AS primary_genre,
    description,
    insertion_timestamp
FROM netflix_data
WHERE show_id IS NOT NULL;

-- Step 4: Sample Queries

-- Top 10 Genres
SELECT primary_genre, COUNT(*) AS total_titles
FROM cleaned_netflix_data
GROUP BY primary_genre
ORDER BY total_titles DESC
LIMIT 10;

-- Content Distribution by Type
SELECT type, COUNT(*) AS total
FROM cleaned_netflix_data
GROUP BY type;

-- Top 5 Countries with Most Titles
SELECT country, COUNT(*) AS total_titles
FROM cleaned_netflix_data
GROUP BY country
ORDER BY total_titles DESC
LIMIT 5;

-- Year-wise Release Trend
SELECT release_year, COUNT(*) AS total_titles
FROM cleaned_netflix_data
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year;
