\c cinemate;
CREATE TABLE users (
    "sec" INT UNIQUE NOT NULL,
    "id" VARCHAR(100) PRIMARY KEY,
    "mail" VARCHAR(100) UNIQUE NOT NULL,
    "nick" VARCHAR(50) UNIQUE NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "pass" VARCHAR(1000) NOT NULL,
    "admin" BOOLEAN NOT NULL,
    "birth" DATE NOT NULL,
    "created" DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE FUNCTION user_id_function() RETURNS TRIGGER AS $$
DECLARE
    next_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(sec), 0) + 1 INTO next_id FROM users;
    NEW.sec := next_id;
    NEW.id := 'user-' || CAST(next_id as text);
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
    "imdb" INTEGER UNIQUE NOT NULL
);

-- INSERT INTO genres(genre_id, genre_name) VALUES (0, 'action');
-- INSERT INTO genres(genre_id, genre_name) VALUES (1, 'adventure');
-- INSERT INTO genres(genre_id, genre_name) VALUES (2, 'animation');
-- INSERT INTO genres(genre_id, genre_name) VALUES (3, 'children');
-- INSERT INTO genres(genre_id, genre_name) VALUES (4, 'comedy');
-- INSERT INTO genres(genre_id, genre_name) VALUES (5, 'crime');
-- INSERT INTO genres(genre_id, genre_name) VALUES (6, 'documentary');
-- INSERT INTO genres(genre_id, genre_name) VALUES (7, 'drama');
-- INSERT INTO genres(genre_id, genre_name) VALUES (8, 'fantasy');
-- INSERT INTO genres(genre_id, genre_name) VALUES (9, 'horror');
-- INSERT INTO genres(genre_id, genre_name) VALUES (10, 'imax');
-- INSERT INTO genres(genre_id, genre_name) VALUES (11, 'musical');
-- INSERT INTO genres(genre_id, genre_name) VALUES (12, 'mistery');
-- INSERT INTO genres(genre_id, genre_name) VALUES (13, 'noir');
-- INSERT INTO genres(genre_id, genre_name) VALUES (14, 'romance');
-- INSERT INTO genres(genre_id, genre_name) VALUES (15, 'scifi');
-- INSERT INTO genres(genre_id, genre_name) VALUES (16, 'thriller');
-- INSERT INTO genres(genre_id, genre_name) VALUES (17, 'war');
-- INSERT INTO genres(genre_id, genre_name) VALUES (18, 'western');

-- CREATE TABLE media_types(
--     type_id SERIAL UNIQUE NOT NULL,
--     type_name VARCHAR(10) PRIMARY KEY
-- );

-- INSERT INTO media_types(type_name) VALUES ('Movie');
-- INSERT INTO media_types(type_name) VALUES ('Show');


CREATE TABLE media (
    "sec" INT UNIQUE NOT NULL,
    "id" VARCHAR(100) PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "genres" JSONB NOT NULL,
    "type" VARCHAR(10) NOT NULL,
    "imdb" INTEGER UNIQUE NOT NULL,
    "png" VARCHAR(255)
);
CREATE OR REPLACE FUNCTION media_id_function() RETURNS TRIGGER AS $$
DECLARE
    next_id INTEGER;
    patata text;
BEGIN 
    SELECT COALESCE(MAX(sec), 0) + 1 INTO next_id FROM media;
    SELECT CAST(to_hex(next_id) as text) INTO patata;
    NEW.sec := next_id;
    NEW.id := 'media-' || left('000000000000', 12 - length(patata)) || CAST(to_hex(next_id) as text);
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
CREATE OR REPLACE TRIGGER media_id_trigger
BEFORE INSERT ON media
FOR EACH ROW
EXECUTE FUNCTION media_id_function();



CREATE TABLE info (
    "media_id" VARCHAR(100) NOT NULL,
    "id" VARCHAR(100) PRIMARY KEY,
    "description" TEXT NOT NULL,
    "synopsis" TEXT NOT NULL,
    "season" INT,
    "rating" FLOAT,
    "director" VARCHAR(100),
    "cast" TEXT,
    "pegi" INT,
    "release" DATE,
    FOREIGN KEY(media_id)
        REFERENCES media("id")
        ON DELETE CASCADE
);
CREATE OR REPLACE FUNCTION info_function() RETURNS TRIGGER as $$
DECLARE
    patata VARCHAR(10);
BEGIN
    SELECT m.type INTO patata FROM media m WHERE m.id = NEW.media_id;
    RAISE NOTICE 'Value: %', patata;
    IF (patata = 'Show') THEN
        IF NEW.season IS NULL THEN
            RAISE EXCEPTION 'Season can not be null for a show';
        END IF;
        NEW.id := NEW.media_id ||'-' || NEW.season;
    ELSEIF (patata = 'Movie') THEN
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

CREATE VIEW media_genres AS SELECT id, name, genres FROM media;

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
    "id" SERIAL PRIMARY KEY,
    "user_id" VARCHAR(100) NOT NULL,
    "media_id" VARCHAR(100) NOT NULL,
    "info_id" VARCHAR(100) NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "rating" FLOAT,
    "comment" VARCHAR(100),
    FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    FOREIGN KEY(info_id)
        REFERENCES info(id)
        ON DELETE CASCADE,
    FOREIGN KEY(media_id)
        REFERENCES media(id)
        ON DELETE CASCADE
);

    
