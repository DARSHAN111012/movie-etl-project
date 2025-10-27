# Movie ETL And Data Analysis Project

##  Project Overview
This project demonstrates a complete **ETL (Extract, Transform, Load)** pipeline using **Python**, **MySQL**, and the **OMDb API**.  
The main goal is to:
- Extract movie and rating data from CSV files
- Enrich the movie data with additional details from the OMDb API
- Load the cleaned and enriched data into a MySQL database
- Run SQL analysis queries to gain insights about movies, genres, and ratings

This project helps understand **real-world data engineering concepts** — including data cleaning, transformation, API integration, and database management.


## Tools & Technologies Used
 **Python 3** --> | For ETL automation |
 **Pandas** --> | Data cleaning and  transformation |
 **Requests** --> | Accessing the OMDb API |
 **SQLAlchemy** -->| Connecting Python with MySQL |
 **MySQL / MySQL Workbench** -->| Storing and analyzing the data |

## Project Folder Structure
movie_pipeline/
├── etl.py  *Main ETL Python script*
├── queries.sql *SQL queries for analysis*
├── README.md  *Project documentation*
└── data/
     ├── movies.csv * Input movie data*
     └── ratings.csv * Input ratings data*

## ETL Workflow Explained

### Extract
- Load movie data from `movies.csv`  
- Load rating data from `ratings.csv`
- The datasets are read into Pandas DataFrames

### Transform
- Only the **first 200 movies** are taken for time efficiency  
- Movie titles are cleaned (e.g., `"Matrix, The"` → `"The Matrix"`)
- The `ratings.csv` file is **filtered** to include ratings only for those 200 movies
- The column names are standardized to:user_id, movie_id, rating, timestamp
- For each movie, data is enriched using the **OMDb API** 
— fetching:
- IMDb Rating
- Director
- Actors
- Language
###  Load
- A new MySQL database (`movie_db`) is used  
- Two tables are created:
- `movies` — for enriched movie information  
- `ratings` — for user ratings
- Data is loaded into MySQL using **SQLAlchemy’s `to_sql()`**
- `engine.begin()` ensures automatic commit and reliable saving


---

## Environment Setup & Run Instructions

## Install Dependencies

pip install -r requirements.txt

Dependencies:-->
pandas
sqlalchemy
pymysql
requests

## Setup MySQL

Open MySQL Workbench
Create a new database:
***CREATE DATABASE movie_db;***

## Update credentials in etl.py:

DB_USER = "root"
DB_PASSWORD = "your_password"
DB_HOST = "localhost"
DB_NAME = "movie_db"

## Run the ETL Script
python etl.py
You should see:
ETL process completed successfully! Data loaded into MySQL.
## Run SQL Scripts

In MySQL Workbench:
SOURCE schema.sql;
SOURCE queries.sql;

### Verify
After running the ETL:

USE movie_db;
SELECT COUNT(*) FROM movies;
SELECT COUNT(*) FROM ratings;

Expected output:
Movies → around 200
Ratings → a few thousand (filtered data)

## Design Choices & Assumptions

**Data Limiting for Efficiency**

Only the first 200 movies from movies.csv were processed to save API time.

OMDb API has a rate limit (1 request/second), so this ensures quicker testing.

**Normalized Database Design**

Two related tables:

movies — enriched movie metadata

ratings — user ratings for each movie

movie_id used as the primary key and foreign key for linking.

**Error Handling & Data Cleaning**

Movie titles like "Matrix, The" were cleaned to "The Matrix".

Ratings filtered to include only movies that exist in the selected dataset.

**Automatic Database Commit**

Used engine.begin() from SQLAlchemy to ensure reliable data insertion.

**Reusable Code**

Code organized into functions with clear logic and debug prints.

## Challenges Faced & How They Were Solved

Challenges

OMDb API rate limit
	Description -->API allows ~1 request/sec, making large datasets slow.	Solution-->Limited ETL to 200 movies for demonstration speed.
Empty ratings table in MySQL 
    Description-->	Data not saving even though visible in Python.	
    Solution-->Switched from engine.connect() to engine.begin() for auto-commit.
Column mismatches 
    Description-->UserId and MovieId from CSV didn’t match SQL column names.	Solution-->Renamed columns in Pandas to user_id, movie_id, etc.
Foreign key dependency	
    Description-->Ratings table required existing movie IDs.	
    Solution-->Dropped tables and recreated in correct order (movies → ratings).
Slow enrichment	
    Description-->API lookups took time per movie.	
    Solution-->Added print checkpoints and filtering logic for faster debugging.

## Example Analytical Queries
Top 10 user-rated movies-->
  SELECT m.title, AVG(r.rating) AS avg_rating FROM ratings r JOIN movies m ON r.movie_id=m.movie_id GROUP BY m.title ORDER BY avg_rating DESC LIMIT 10;

Top 10 IMDb-rated movies	
  SELECT title, imdb_rating FROM movies ORDER BY imdb_rating DESC LIMIT 10;

## Conclusion

This project successfully demonstrates how to:

Build a data pipeline using Python + MySQL
Integrate real-time API data enrichment
Perform SQL-based analytics for insights

It reflects real-world data engineering concepts — ETL automation, data cleaning, database design, and analytical querying — making it ideal for academic or professional demonstration.


Project Status

 Completed Successfully
 Last Updated: October 2̣025
 Developed by: Darshan c