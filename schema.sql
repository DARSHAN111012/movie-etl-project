CREATE TABLE IF NOT EXISTS movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255),
    year INT,
    genres VARCHAR(255),
    director VARCHAR(255),
    plot TEXT,
    box_office VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS ratings (
    user_id INT,
    movie_id INT,
    rating FLOAT,
    timestamp BIGINT,
    PRIMARY KEY (user_id, movie_id, timestamp),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);