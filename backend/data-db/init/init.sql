\c cinemate;
CREATE TABLE users (
    user_sec INT UNIQUE NOT NULL,
    user_id VARCHAR(100) PRIMARY KEY,
    user_mail VARCHAR(100) UNIQUE NOT NULL,
    user_nick VARCHAR(50) UNIQUE NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    user_pass VARCHAR(1000) NOT NULL,
    user_admin BOOLEAN NOT NULL,
    user_birth DATE NOT NULL,
    user_created DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE FUNCTION user_id_function() RETURNS TRIGGER AS $$
DECLARE
    next_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(user_sec), 0) + 1 INTO next_id FROM users;
    NEW.user_sec := next_id;
    NEW.user_id := 'user-' || CAST(next_id as text);
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER user_id_trigger
BEFORE INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION user_id_function();

CREATE TABLE genres (
    genre_id INTEGER PRIMARY KEY,
    genre_name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO genres(genre_id, genre_name) VALUES (0, 'action');
INSERT INTO genres(genre_id, genre_name) VALUES (1, 'adventure');
INSERT INTO genres(genre_id, genre_name) VALUES (2, 'animation');
INSERT INTO genres(genre_id, genre_name) VALUES (3, 'children');
INSERT INTO genres(genre_id, genre_name) VALUES (4, 'comedy');
INSERT INTO genres(genre_id, genre_name) VALUES (5, 'crime');
INSERT INTO genres(genre_id, genre_name) VALUES (6, 'documentary');
INSERT INTO genres(genre_id, genre_name) VALUES (7, 'drama');
INSERT INTO genres(genre_id, genre_name) VALUES (8, 'fantasy');
INSERT INTO genres(genre_id, genre_name) VALUES (9, 'horror');
INSERT INTO genres(genre_id, genre_name) VALUES (10, 'imax');
INSERT INTO genres(genre_id, genre_name) VALUES (11, 'musical');
INSERT INTO genres(genre_id, genre_name) VALUES (12, 'mistery');
INSERT INTO genres(genre_id, genre_name) VALUES (13, 'noir');
INSERT INTO genres(genre_id, genre_name) VALUES (14, 'romance');
INSERT INTO genres(genre_id, genre_name) VALUES (15, 'scifi');
INSERT INTO genres(genre_id, genre_name) VALUES (16, 'thriller');
INSERT INTO genres(genre_id, genre_name) VALUES (17, 'war');
INSERT INTO genres(genre_id, genre_name) VALUES (18, 'western');


CREATE TABLE preferences (
    user_id VARCHAR(12) PRIMARY KEY,
    preferences_weights JSONB,
    FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);


CREATE TABLE media_types(
    type_id SERIAL UNIQUE NOT NULL,
    type_name VARCHAR(10) PRIMARY KEY
);

INSERT INTO media_types(type_name) VALUES ('Movie');
INSERT INTO media_types(type_name) VALUES ('Show');


CREATE TABLE media (
    media_sec INT UNIQUE NOT NULL,
    media_id VARCHAR(100) PRIMARY KEY,
    media_name VARCHAR(255) NOT NULL,
    media_genres JSONB NOT NULL,
    media_type VARCHAR(10) NOT NULL,
    media_png VARCHAR(255),
    FOREIGN KEY(media_type)
        REFERENCES media_types(type_name)
        ON DELETE CASCADE
);
CREATE OR REPLACE FUNCTION media_id_function() RETURNS TRIGGER AS $$
DECLARE
    next_id INTEGER;
    patata text;
BEGIN 
    SELECT COALESCE(MAX(media_sec), 0) + 1 INTO next_id FROM media;
    SELECT CAST(to_hex(next_id) as text) INTO patata;
    NEW.media_sec := next_id;
    NEW.media_id := 'media-' || left('000000000000', 12 - length(patata)) || CAST(to_hex(next_id) as text);
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
CREATE OR REPLACE TRIGGER media_id_trigger
BEFORE INSERT ON media
FOR EACH ROW
EXECUTE FUNCTION media_id_function();



CREATE TABLE media_info (
    media_id VARCHAR(100) NOT NULL,
    media_info_id VARCHAR(100) PRIMARY KEY,
    media_info_description TEXT NOT NULL,
    media_info_synopsis TEXT NOT NULL,
    media_info_season INT,
    media_info_rating FLOAT,
    media_info_director VARCHAR(100),
    "media_info_cast" TEXT,
    media_info_pegi INT,
    "media_info_release" DATE,
    FOREIGN KEY(media_id)
        REFERENCES media(media_id)
        ON DELETE CASCADE
);
CREATE OR REPLACE FUNCTION media_info_function() RETURNS TRIGGER as $$
DECLARE
    patata VARCHAR(10);
BEGIN
    SELECT m.media_type INTO patata FROM media m WHERE m.media_id = NEW.media_id;
    RAISE NOTICE 'Value: %', patata;
    IF (patata = 'Show') THEN
        IF NEW.media_info_season IS NULL THEN
            RAISE EXCEPTION 'Season can not be null for a show';
        END IF;
        NEW.media_info_id := NEW.media_id ||'-' || NEW.media_info_season;
    ELSEIF (patata = 'Movie') THEN
        IF NEW.media_info_season IS NOT NULL THEN
            RAISE EXCEPTION 'Season has to be null for a movie';
        END IF;
        NEW.media_info_id := NEW.media_id;
    ELSE
        RAISE EXCEPTION 'No valid type of media provided';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
CREATE TRIGGER media_info_trigger
BEFORE INSERT ON media_info
FOR EACH ROW
EXECUTE FUNCTION media_info_function();

CREATE VIEW media_genres AS SELECT media_id, media_name, media_genres FROM media;

CREATE TABLE "characters" (
    character_id SERIAL PRIMARY KEY,
    media_id VARCHAR(100) NOT NULL,
    character_name VARCHAR(100) NOT NULL,
    character_context TEXT NOT NULL,
    character_image_path VARCHAR(255) NOT NULL,
    FOREIGN KEY(media_id)
        REFERENCES media(media_id)
        ON DELETE CASCADE
);

CREATE TABLE "questionnaries" (
    questionnary_id SERIAL PRIMARY KEY,
    media_info_id VARCHAR(100) NOT NULL,
    questionnary_question TEXT NOT NULL,
    questionary_answers JSONB NOT NULL,
    questionary_valid INT NOT NULL,
    FOREIGN KEY(media_info_id)
        REFERENCES media_info(media_info_id)
        ON DELETE CASCADE
);

CREATE TABLE "library" (
    library_id SERIAL PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    media_info_id VARCHAR(100) NOT NULL,
    library_status VARCHAR(50) NOT NULL,
    library_rating FLOAT,
    library_comment VARCHAR(100),
    FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    FOREIGN KEY(media_info_id)
        REFERENCES media_info(media_info_id)
        ON DELETE CASCADE
);

    
