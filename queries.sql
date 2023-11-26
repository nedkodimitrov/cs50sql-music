-- List all songs by an artist using the "songs_by_artists" view
SELECT "title"
FROM "songs_by_artists"
WHERE "first_name" = 'Ed' AND "last_name" = 'Sheeran';

-- List all songs in a user playlist
SELECT "title"
FROM "songs"
WHERE "id" IN (
    SELECT "song_id"
    FROM "includes"
    WHERE "playlist_id" = (
        SELECT "id"
        FROM "playlists"
        WHERE "user_id" = 1 AND "title" = 'John Smith''s favourite songs'
    )
);

-- List all songs in album
SELECT "title"
FROM "songs"
WHERE "album_id" = (
    SELECT "id"
    FROM "albums"
    WHERE "title" = '÷ (Divide)' AND "artist_id" = 1
);

-- List all the songs released in the past year
SELECT *
FROM "past_year_songs";

-- List all user playlists
SELECT "title"
FROM "playlists"
WHERE "user_id" = 1;

-- Add a new artist
INSERT INTO "artists" ("first_name", "last_name", "country", "birth_date")
VALUES ('Ed', 'Sheeran', 'England', '1991-02-17');

-- Add a new album
INSERT INTO "albums" ("title", "release_date", "artist_id")
VALUES ('÷ (Divide)', '2017-03-03', 1);

-- Add a new song
INSERT INTO "songs" ("title", "release_date", "duration", "genre", "album_id", "track_number")
VALUES ('Shape of You', '2017-01-06', 234, 'pop', 1, 4);

-- Associate a song with an artist
INSERT INTO "performs" ("artist_id", "song_id")
VALUES (1, 1);

-- Add a new user
INSERT INTO "users" ("first_name", "last_name", "username", "password")
VALUES ('John', 'Smith', 'john_smith', 'password');

-- Add a new playlist
INSERT INTO "playlists" ("title", "user_id")
VALUES ('John Smith''s favourite songs', 1);

-- Add a song to a playlist
INSERT INTO "includes" ("playlist_id", "song_id")
VALUES (1, 1);

-- Delete a song from a playlist
DELETE FROM "includes"
WHERE "playlist_id" = 1 AND "song_id" = 1;
