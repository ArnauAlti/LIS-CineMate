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
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO genres(genre_name) VALUES ('action');
INSERT INTO genres(genre_name) VALUES ('adventure');
INSERT INTO genres(genre_name) VALUES ('animation');
INSERT INTO genres(genre_name) VALUES ('children');
INSERT INTO genres(genre_name) VALUES ('comedy');
INSERT INTO genres(genre_name) VALUES ('crime');
INSERT INTO genres(genre_name) VALUES ('documentary');
INSERT INTO genres(genre_name) VALUES ('drama');
INSERT INTO genres(genre_name) VALUES ('fantasy');
INSERT INTO genres(genre_name) VALUES ('horror');
INSERT INTO genres(genre_name) VALUES ('imax');
INSERT INTO genres(genre_name) VALUES ('musical');
INSERT INTO genres(genre_name) VALUES ('mistery');
INSERT INTO genres(genre_name) VALUES ('noir');
INSERT INTO genres(genre_name) VALUES ('romance');
INSERT INTO genres(genre_name) VALUES ('scifi');
INSERT INTO genres(genre_name) VALUES ('thriller');
INSERT INTO genres(genre_name) VALUES ('war');
INSERT INTO genres(genre_name) VALUES ('western');


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
    sec INT UNIQUE NOT NULL,
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    rating FLOAT,
    genres JSONB NOT NULL,
    director VARCHAR(100),
    "cast" TEXT,
    pegi INT,
    release DATE,
    png VARCHAR(255)
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



CREATE TABLE media_info (
    media_id VARCHAR(100) NOT NULL,
    id VARCHAR(100) PRIMARY KEY,
    type VARCHAR(10) NOT NULL,
    description TEXT NOT NULL,
    synopsis TEXT NOT NULL,
    season INT,
    FOREIGN KEY(type)
        REFERENCES media_types(type_name)
        ON DELETE CASCADE,
    FOREIGN KEY(media_id)
        REFERENCES media(id)
        ON DELETE CASCADE
);
CREATE OR REPLACE FUNCTION media_info_function() RETURNS TRIGGER as $$
BEGIN
    IF (NEW.type = 'Show') THEN
        IF NEW.season IS NULL THEN
            RAISE EXCEPTION 'Season can not be null for a show';
        END IF;
        NEW.id := NEW.media_id ||'-' || NEW.season;
    ELSEIF (NEW.type = 'Movie') THEN
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
CREATE TRIGGER media_info_trigger
BEFORE INSERT ON media_info
FOR EACH ROW
EXECUTE FUNCTION media_info_function();

INSERT INTO media(name, genres) VALUES ('The Blacklist', '[1,2,3]');
INSERT INTO media(name, genres) VALUES ('Avengers: Endgame', '[1,2,3]');

INSERT INTO media_info(media_id, type, description, synopsis, season) values ('media-000000000001','Show','template','template',1);
INSERT INTO media_info(media_id, type, description, synopsis, season) values ('media-000000000001','Show','template','template',2);
INSERT INTO media_info(media_id, type, description, synopsis) values ('media-000000000001','Show','template','template');
INSERT INTO media_info(media_id, type, description, synopsis) values ('media-000000000002','Movie','template','template');
    

-- CREATE TABLE media (
--     sec INT UNIQUE NOT NULL,
--     id VARCHAR(100) PRIMARY KEY,
--     general VARCHAR(100) NOT NULL,
--     name VARCHAR(255) NOT NULL,
--     type VARCHAR(10) NOT NULL,
--     rating INT,
--     genres JSONB NOT NULL,
--     director VARCHAR(100),
--     "cast" TEXT,
--     description TEXT NOT NULL,
--     synopsis TEXT NOT NULL,
--     pegi INT,
--     season INT,
--     release DATE,
--     png VARCHAR(255),
--     FOREIGN KEY(type)
--         REFERENCES media_types(type_name)
--         ON DELETE CASCADE
-- );
-- CREATE OR REPLACE FUNCTION media_id_function() RETURNS TRIGGER AS $$
-- DECLARE
--     next_id INTEGER;
--     patata text;
-- BEGIN
--     SELECT COALESCE(MAX(sec), 0) + 1 INTO next_id FROM media;
--     SELECT CAST(to_hex(next_id) as text) INTO patata;
--     IF (NEW.type = 'Show') THEN
--         IF NEW.season IS NULL THEN
--             RAISE EXCEPTION 'Season can not be null for a show';
--         END IF;
--         NEW.sec := next_id;
--         NEW.id :='media-' || left('000000000000', 12 - length(patata)) || CAST(to_hex(next_id) as text) || '-' || NEW.season;
--         NEW.general := 'media-' || left('000000000000', 12 - length(patata)) || CAST(to_hex(next_id) as text);
--     ELSEIF (NEW.type = 'Movie') THEN
--         IF NEW.season IS NOT NULL THEN
--             RAISE EXCEPTION 'Season has to be null for a movie';
--         END IF;
--         NEW.sec := next_id;
--         NEW.id :='media-' || left('000000000000', 12 - length(patata)) || CAST(to_hex(next_id) as text);
--         NEW.general :='media-' || left('000000000000', 12 - length(patata)) || CAST(to_hex(next_id) as text);
--     END IF;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE PLPGSQL;
-- CREATE TRIGGER media_id_trigger
-- BEFORE INSERT ON media
-- FOR EACH ROW
-- EXECUTE FUNCTION media_id_function();

-- INSERT INTO media(name, type, genres, description, synopsis, season) VALUES ('The Blacklist', 'Show', '[1,2,3]', 'Patata', 'Patata', 1);
-- INSERT INTO media(name, type, genres, description, synopsis) VALUES ('The Blacklist', 'Show', '[1,2,3]', 'Patata', 'Patata');
-- INSERT INTO media(name, type, genres, description, synopsis, season) VALUES ('Avengers: Endgame', 'Movie', '[1,2,3]', 'Patata', 'Patata', 1);
-- INSERT INTO media(name, type, genres, description, synopsis) VALUES ('Avengers: Endgame', 'Movie', '[1,2,3]', 'Patata', 'Patata');





-- CREATE TABLE information (
--     media_id VARCHAR(100) NOT NULL,
--     id PRIMARY KEY,
--     duration INTEGER NOT NULL,
--     synopsis TEXT NULL,
--     season INT NOT NULL,
--     description TEXT NOT NULL,
--     FOREIGN KEY(media_id)
--         REFERENCES media(media_id)
--         ON DELETE CASCADE

-- );
-- CREATE OR replace FUNCTION information_function() RETURNS TRIGGER as $$
-- BEGIN
--     IF ()
--     -- NEW.show_id := NEW.media_id || '-' || NEW.show_season;
--     -- RETURN NEW;
-- END;
-- $$ LANGUAGE PLPGSQL;
-- CREATE TRIGGER information_trigger
-- BEFORE INSERT ON show
-- FOR EACH ROW
-- EXECUTE FUNCTION information_function();
