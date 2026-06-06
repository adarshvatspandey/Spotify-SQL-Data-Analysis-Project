-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
ALTER TABLE spotify
ALTER COLUMN likes TYPE NUMERIC;

ALTER TABLE spotify
ALTER COLUMN comments TYPE NUMERIC;

ALTER TABLE spotify
ALTER COLUMN stream TYPE NUMERIC;

ALTER TABLE spotify
ALTER COLUMN views TYPE NUMERIC;

select * from spotify
limit 5;
copy spotify
from 'D:\Spotify\archive\cleaned_dataset.csv'
delimiter ','
csv header ;

 

## Easy Level

### 1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT track
FROM spotify
WHERE stream > 1000000000;


### 2. List all albums along with their respective artists.

SELECT DISTINCT
    album,
    artist
FROM spotify
ORDER BY artist;


### 3. Get the total number of comments for tracks where licensed = TRUE.


SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;


### 4. Find all tracks that belong to the album type 'single'.


SELECT track
FROM spotify
WHERE album_type = 'single';


### 5. Count the total number of tracks by each artist.


SELECT
    artist,
    COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist
ORDER BY total_tracks DESC;


## Medium Level

### 6. Calculate the average danceability of tracks in each album.


SELECT
    album,
    ROUND(AVG(danceability)::numeric, 3) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;

### 7. Find the top 5 tracks with the highest energy values.


SELECT
    track,
    artist,
    energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;

### 8. List all tracks along with their views and likes where official_video = TRUE.


SELECT
    track,
    views,
    likes
FROM spotify
WHERE official_video = TRUE;

### 9. For each album, calculate the total views of all associated tracks.


SELECT
    album,
    SUM(views) AS total_views
FROM spotify
GROUP BY album
ORDER BY total_views DESC;


### 10. Retrieve the track names that have been streamed on Spotify more than YouTube.


SELECT
    track
FROM spotify
WHERE most_played_on = 'Spotify';


## Advanced Level

### 11. Find the top 3 most-viewed tracks for each artist using window function

WITH RankedTracks AS (
    SELECT
        artist,
        track,
        views,
        RANK() OVER (
            PARTITION BY artist
            ORDER BY views DESC
        ) AS track_rank
    FROM spotify
)

SELECT
    artist,
    track,
    views
FROM RankedTracks
WHERE track_rank <= 3;


### 12. Find tracks where the liveness score is above the average.


SELECT
    track,
    artist,
    liveness
FROM spotify
WHERE liveness >
(
    SELECT AVG(liveness)
    FROM spotify
);


### 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.


WITH EnergyStats AS (
    SELECT
        album,
        MAX(energy) AS max_energy,
        MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)

SELECT
    album,
    max_energy,
    min_energy,
    (max_energy - min_energy) AS energy_difference
FROM EnergyStats
ORDER BY energy_difference DESC;



