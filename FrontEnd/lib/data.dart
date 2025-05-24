/*
-- Taula: usuaris
CREATE TABLE users (
    user_id VARCHAR(12) PRIMARY KEY,
    user_mail VARCHAR(100) UNIQUE NOT NULL,
    user_nick VARCHAR(50) UNIQUE NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    user_pass VARCHAR(1000) NOT NULL,
    user_admin BOOLEAN NOT NULL,
    user_birth DATE NOT NULL,
    user_created DATE DEFAULT CURRENT_DATE
);

-- Taula: preferences
CREATE TABLE preferences (
    user_id VARCHAR(12) PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    preferences_weights JSON  -- TO_DO
);

-- Taula: repositories
CREATE TABLE repositories (
    repo_id SERIAL PRIMARY KEY,
    repo_season_id INT NOT NULL,
    repo_name VARCHAR(255) NOT NULL,
    repo_release_date DATE,
    repo_director VARCHAR(255),
    repo_cast TEXT,
    repo_description TEXT,
    repo_type VARCHAR(50), -- si es peli o serie? llavors faria BOOLEAN
    repo_image_path VARCHAR(255),
    repo_rating DECIMAL(3,1),
    repo_PEGI INT,
    repo_duration INT,
    repo_season_number INT,
    repo_episode_count INT,
    repo_genre VARCHAR(100) -- es pot eliminar si fem mes d'un genre (fem servir les altres taules)
);

-- Taula: library (relació user-repository amb dades)
CREATE TABLE library (
    library_entry_id SERIAL PRIMARY KEY,
    user_id VARCHAR(12) REFERENCES users(user_id) ON DELETE CASCADE,
    repo_id INT REFERENCES repositories(repo_id) ON DELETE CASCADE,
    library_season_id INT,
    library_rating DECIMAL(3,1),
    library_comment VARCHAR(255)
);

-- Taula: characters
CREATE TABLE characters (
    character_id SERIAL PRIMARY KEY,
    repo_id INT REFERENCES repositories(repo_id) ON DELETE CASCADE,
    characters_name VARCHAR(100) NOT NULL,
    characters_context TEXT,
    characters_image_path VARCHAR(255)
);

-- Taula: questionnaires
CREATE TABLE questionnaires (
    questionnaire_id SERIAL PRIMARY KEY,
    repo_id INT REFERENCES repositories(repo_id) ON DELETE CASCADE,
    season_id INT,
    questionnaires_rating INT,
    questionnaires_comment VARCHAR(255),
    questionnaires_validated BOOLEAN DEFAULT FALSE
);

-- Taula: genres
CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,    -- cada repo te 1 o mes genres? si te mes de un fer una altre taula
    genre_season_id INT,
    repo_id INT REFERENCES repositories(repo_id) ON DELETE CASCADE,
    genre_weights JSON -- TO_DO
);

-- CREATE TABLE genres (
--     genre_id SERIAL PRIMARY KEY,
--     genre_name VARCHAR(100) UNIQUE NOT NULL
-- );

-- CREATE TABLE repo_genres (
--     repo_id INT REFERENCES repositories(repo_id) ON DELETE CASCADE,
--     genre_id INT REFERENCES genres(genre_id) ON DELETE CASCADE,
--     weight DECIMAL(3,2), -- o JSON si vols info extra
--     PRIMARY KEY (repo_id, genre_id)
-- );

*/