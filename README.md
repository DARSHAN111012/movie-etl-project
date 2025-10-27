# Movie Data Pipeline Data Analysis Project

##  Project Overview
This project demonstrates a complete **ETL (Extract, Transform, Load)** pipeline using **Python**, **MySQL**, and the **OMDb API**.  
The main goal is to:
- Extract movie and rating data from CSV files
- Enrich the movie data with additional details from the OMDb API
- Load the cleaned and enriched data into a MySQL database
- Run SQL analysis queries to gain insights about movies, genres, and ratings

This project helps understand **real-world data engineering concepts** — including data cleaning, transformation, API integration, and database management.


## Tools & Technologies Used
| Tool | Purpose |
| **Python 3** | For ETL automation |
| **Pandas** | Data cleaning and  transformation |
| **Requests** | Accessing the OMDb API |
| **SQLAlchemy** | Connecting Python with MySQL |
| **MySQL / MySQL Workbench** | Storing and analyzing the data |

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

### Verify
After running the ETL:
```sql
USE movie_db;
SELECT COUNT(*) FROM movies;
SELECT COUNT(*) FROM ratings;

Expected output:
Movies → around 200
Ratings → a few thousand (filtered data)