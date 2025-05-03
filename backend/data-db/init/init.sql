\c cinemate;
CREATE TABLE users (
    "id" INTEGER PRIMARY KEY,
    "mail" VARCHAR(100) UNIQUE NOT NULL,
    "nick" VARCHAR(50) UNIQUE NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "pass" VARCHAR(1000) NOT NULL,
    "admin" BOOLEAN NOT NULL,
    "birth" DATE NOT NULL,
    "png" VARCHAR(150),
    "created" DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE FUNCTION user_id_function() RETURNS TRIGGER AS $$
DECLARE
    next_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(id), 0) + 1 INTO next_id FROM users;
    NEW.id := next_id;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER user_id_trigger
BEFORE INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION user_id_function();

CREATE TABLE genres (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(50) UNIQUE NOT NULL,
    "moviedb" INTEGER UNIQUE NOT NULL
);


CREATE TABLE media (
    "sec" INTEGER UNIQUE NOT NULL,
    "id" VARCHAR(150) PRIMARY KEY,
    "active" BOOLEAN NOT NULL, 
    "name" VARCHAR(255) NOT NULL,
    "genres" JSON NOT NULL,
    "type" VARCHAR(10) NOT NULL,
    "movie_db" VARCHAR(100) UNIQUE NOT NULL,
    "movie_db_rating" FLOAT,
    "movie_db_count" INTEGER,
    "description" TEXT,
    "png" VARCHAR(255)
);

CREATE OR REPLACE FUNCTION media_id_function() RETURNS TRIGGER AS $$
DECLARE
    next_id INTEGER;
    patata text;
BEGIN 
    SELECT COALESCE(MAX(sec), 0) + 1 INTO next_id FROM media;
    SELECT CAST(next_id as text) INTO patata;
    NEW.sec := next_id;
    NEW.id := 'media-' || CAST(next_id as text);
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
CREATE OR REPLACE TRIGGER media_id_trigger
BEFORE INSERT ON media
FOR EACH ROW
EXECUTE FUNCTION media_id_function();



CREATE TABLE info (
    "media_id" VARCHAR(100) NOT NULL,
    "movie_db" VARCHAR(100) NOT NULL,
    "id" VARCHAR(150) PRIMARY KEY,
    "active" BOOLEAN NOT NULL,
    "synopsis" TEXT NOT NULL,
    "plot" TEXT,
    "season" INT,
    "episodes" INT NOT NULL,
    "director" VARCHAR(100),
    "cast" TEXT,
    "release" DATE,
    "vote_rating" FLOAT NOT NULL,
    "vote_count" INTEGER NOT NULL,
    FOREIGN KEY(media_id)
        REFERENCES media("id")
        ON DELETE CASCADE,
    FOREIGN KEY(movie_db)
        REFERENCES media("movie_db")
        ON DELETE CASCADE
);
CREATE OR REPLACE FUNCTION info_function() RETURNS TRIGGER as $$
DECLARE
    var1 VARCHAR(100);
    var2 VARCHAR(10);
BEGIN
    RAISE NOTICE 'Value: %', NEW.media_id;
    RAISE NOTICE 'Value: %', NEW.movie_db;
    IF NEW.media_id IS NOT NULL THEN
        SELECT m.id INTO var1 FROM media m WHERE m.id = NEW.media_id; 
        SELECT m.type INTO var2 FROM media m WHERE m.id = NEW.media_id;
    ELSEIF NEW.movie_db IS NOT NULL THEN
        SELECT m.id INTO var1 FROM media m WHERE m.movie_db = NEW.movie_db; 
        SELECT m.type INTO var2 FROM media m WHERE m.movie_db = NEW.movie_db;
        NEW.media_id := var1;
    ELSE 
        RAISE EXCEPTION 'No Identification for media';
    END IF;
    IF (var2 = 'show') THEN
        IF NEW.season IS NULL THEN
            RAISE EXCEPTION 'Season can not be null for a show';
        END IF;
        NEW.id := NEW.media_id ||'-' || NEW.season;
    ELSEIF (var2 = 'movie') THEN
        IF NEW.season IS NOT NULL THEN
            RAISE EXCEPTION 'Season has to be null for a movie';
        END IF;
        NEW.id := NEW.media_id;
    ELSE
        RAISE EXCEPTION 'No valid type of media provided';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
CREATE TRIGGER info_trigger
BEFORE INSERT ON info
FOR EACH ROW
EXECUTE FUNCTION info_function();


CREATE TABLE "characters" (
    "id" SERIAL PRIMARY KEY,
    "media_id" VARCHAR(100) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "context" TEXT NOT NULL,
    "png" VARCHAR(255) NOT NULL,
    FOREIGN KEY(media_id)
        REFERENCES media(id)
        ON DELETE CASCADE
);

CREATE TABLE "questionnaries" (
    "id" SERIAL PRIMARY KEY,
    "info_id" VARCHAR(100) NOT NULL,
    "question" TEXT NOT NULL,
    "answers" JSONB NOT NULL,
    "valid" INT NOT NULL,
    FOREIGN KEY(info_id)
        REFERENCES info(id)
        ON DELETE CASCADE
);


CREATE TABLE "library" (
    "sec" SERIAL PRIMARY KEY,
    "user_mail" VARCHAR(100) NOT NULL,
    "media_id" VARCHAR(100) NOT NULL,
    "info_id" VARCHAR(100) UNIQUE NOT NULL ,
    "status" VARCHAR(50),
    "rating" FLOAT,
    "comment" VARCHAR(100),
    -- "media_name" VARCHAR(255) NOT NULL,
    -- "media_png" VARCHAR(255),
    FOREIGN KEY(user_mail)
        REFERENCES users(mail)
        ON DELETE CASCADE,
    FOREIGN KEY(media_id)
        REFERENCES media(id)
        ON DELETE CASCADE,
    FOREIGN KEY(info_id)
        REFERENCES info(id)
        ON DELETE CASCADE
);

CREATE TABLE "comments" (
    "id" INTEGER UNIQUE NOT NULL,
    "info_id" VARCHAR(100) NOT NULL,
    "user_mail" VARCHAR(100) NOT NULL,
    "response" INTEGER,
    "created" DATE NOT NULL,
    "message" TEXT NOT NULL,
    FOREIGN KEY(info_id)
        REFERENCES info(id)
        ON DELETE CASCADE,
    FOREIGN KEY(user_mail)
        REFERENCES users(mail)
        ON DELETE CASCADE,
    FOREIGN KEY(response)
        REFERENCES comments(id)
        ON DELETE CASCADE
);

CREATE VIEW recommender_query_media_genres AS 
SELECT m.id,  string_agg(g.name, '|' ORDER BY g.name) AS genres
FROM media m,
json_array_elements_text(m.genres) AS genre_id
JOIN genres g ON g.id = genre_id::INTEGER
GROUP BY m.id;

CREATE VIEW view_billboard AS
SELECT m.sec, m.id, m.name, m.png, m.type, m.movie_db_rating, i.release 
FROM media m
JOIN info i ON i.id = m.id OR i.id = m.id || '-1'
WHERE m.active = true;

CREATE VIEW view_billboard_admin AS
SELECT m.sec, m.id, m.name, m.png, m.type, m.movie_db_rating, i.release 
FROM media m
JOIN info i ON i.id = m.id OR i.id = m.id || '-1';

CREATE VIEW "view_library" AS 
SELECT l.sec, l.user_mail, l.media_id, l.info_id, 
l.status, l.rating, l.comment, m.png, 
m.name, m.type
FROM library l
JOIN media m On m.id = l.media_id
GROUP BY l.sec, m.png, m.name, m.type;

CREATE VIEW "view-info" AS 
SELECT m.id media_id, v.id info_id, m.type, v.season, 
v.episodes, m.name, m.png, m.movie_db_rating, 
m.movie_db_count, v.vote_rating, v.vote_count, m.description, 
v.synopsis, v.plot, v.director, v.cast, v.release 
FROM media m, info v 
WHERE m.id = v.media_id AND m.active = true;