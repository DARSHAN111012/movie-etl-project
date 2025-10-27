import pandas as pd
import requests
from sqlalchemy import create_engine, text

#  Database and API Setup

DB_USER = "root"
DB_PASSWORD = "darshansql"   
DB_HOST = "localhost"
DB_NAME = "movie_db"
OMDB_API_KEY = "9aae7bec"

# Create MySQL connection
engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}")

# CSV file paths
MOVIES_CSV = "data/movies.csv"
RATINGS_CSV = "data/ratings.csv"


def parse_title_and_year(title):
    if "(" in title:
        parts = title.split("(")
        title_clean = parts[0].strip()
        year = parts[-1].replace(")", "").strip()
    else:
        title_clean = title
        year = None
    # Fix titles like "Matrix, The"
    title_clean = title_clean.replace(", The", "").replace(", A", "").replace(", An", "")
    return title_clean, year

# ETL Main Function

def run_etl():
    print(" Starting ETL process...")

    # Step 1: Load CSVs
    movies_df = pd.read_csv(MOVIES_CSV)
    ratings_df = pd.read_csv(RATINGS_CSV)

    # Rename columns for MySQL compatibility
    ratings_df.columns = ["user_id", "movie_id", "rating", "timestamp"]
    movies_df = movies_df.head(100)
    ratings_df = ratings_df[ratings_df["movie_id"].isin(movies_df["movieId"])]
    print("Movies loaded:", len(movies_df))
    print("Ratings loaded (filtered):", len(ratings_df))
    print(ratings_df.head())

    # Step 2: Enrich Movies with OMDb API
    movie_data = []
    for _, row in movies_df.iterrows():
        title, year = parse_title_and_year(row["title"])
        movie_id = row["movieId"]
        genres = row["genres"]

        url = f"http://www.omdbapi.com/?t={title}&y={year}&apikey={OMDB_API_KEY}"
        response = requests.get(url)
        data = response.json()

        if data.get("Response") == "True":
            movie_data.append({
                "movie_id": movie_id,
                "title": title,
                "year": year,
                "genre": genres,
                "imdb_rating": data.get("imdbRating"),
                "director": data.get("Director"),
                "actors": data.get("Actors"),
                "language": data.get("Language")
            })
        else:
            print(f"Not found in OMDb- '{title}'")

    movies_final = pd.DataFrame(movie_data)
    print(" Total movies enriched:", len(movies_final))

    # Step 3: Save to MySQL Database

    with engine.begin() as conn: 
        print("Resetting database tables...")
        conn.execute(text("SET FOREIGN_KEY_CHECKS=0;"))
        conn.execute(text("DROP TABLE IF EXISTS ratings;"))
        conn.execute(text("DROP TABLE IF EXISTS movies;"))
        conn.execute(text("SET FOREIGN_KEY_CHECKS=1;"))

        print("Inserting movies into MySQL...")
        movies_final.to_sql("movies", conn, if_exists="replace", index=False)

        print("Inserting ratings into MySQL...")
        ratings_df.to_sql("ratings", conn, if_exists="replace", index=False)

    print("ETL process completed successfully! Data loaded into MySQL.")

#  Run the ETL
if __name__ == "__main__":
    run_etl()