-- Represent music artists who can produce albums and perform songs
CREATE TABLE "artists" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT,
    "country" TEXT,
    "birth_date" NUMERIC CHECK ("birth_date" <= CURRENT_TIMESTAMP),
    PRIMARY KEY("id")
);

-- Represent albums by music artists
CREATE TABLE "albums" (
    "id" INTEGER,
    "artist_id" INTEGER,
    "title" TEXT NOT NULL,
    "release_date" NUMERIC CHECK ("release_date" <= CURRENT_TIMESTAMP),
    PRIMARY KEY("id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id")
);

--Represent songs by music artists.
CREATE TABLE "songs" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "release_date" NUMERIC CHECK ("release_date" <= CURRENT_TIMESTAMP),
    "duration" INTEGER CHECK ("duration" > 0),
    "genre" TEXT,
    "album_id" INTEGER,
    "track_number" INTEGER CHECK ("track_number" > 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("album_id") REFERENCES "albums"("id")
);

-- Represent users who can create playlists and add songs to them.
CREATE TABLE "users" (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "username" TEXT UNIQUE NOT NULL,
    "password" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent playlists by users.
CREATE TABLE "playlists" (
    "id" INTEGER,
    "user_id" INTEGER,
    "title" TEXT NOT NULL,
    "created_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id")
);

-- Represent the connection between an artist and a song.
CREATE TABLE "performs" (
    "artist_id" INTEGER,
    "song_id" INTEGER,
    PRIMARY KEY("artist_id", "song_id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id"),
    FOREIGN KEY("song_id") REFERENCES "songs"("id")
);

-- Represent the connection between a song and a playlist.
CREATE TABLE "includes" (
    "playlist_id" INTEGER,
    "song_id" INTEGER,
    PRIMARY KEY("playlist_id", "song_id"),
    FOREIGN KEY("playlist_id") REFERENCES "playlists"("id"),
    FOREIGN KEY("song_id") REFERENCES "songs"("id")
);

-- View that has 2 columns - song title and Artist names concatenated into one column
CREATE VIEW "songs_by_artists" AS
SELECT "songs"."title", COALESCE("artists"."first_name" || ' ' || "artists"."last_name", "artists"."first_name") AS "Artist", "release_date"
FROM "artists" JOIN "performs" ON "artists"."id" = "performs"."artist_id"
JOIN "songs" ON "performs"."song_id" = "songs"."id";

-- view containing song title and artist names of songs from the past year
CREATE VIEW "past_year_songs" AS
SELECT "title", "Artist"
FROM "songs_by_artists"
WHERE "release_date" > date('now','-1 year');

-- Create indexes to speed common searches
CREATE INDEX "artist_index" ON "artists"("first_name", "last_name");
CREATE UNIQUE INDEX "playlists_user_index" ON "playlists"("user_id", "title");
CREATE INDEX "songs_title_index" ON "songs"("title");
CREATE INDEX "songs_album_index" ON "songs"("album_id");
CREATE INDEX "albums_title_index" ON "albums"("title");
CREATE INDEX "albums_artist_index" ON "albums"("artist_id");
