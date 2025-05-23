\c cinemate;
-- Taula: usuaris
CREATE TABLE users (
    base_id SERIAL PRIMARY KEY,
    user_id VARCHAR(12) UNIQUE,
    user_mail VARCHAR(100) UNIQUE NOT NULL,
    user_nick VARCHAR(50) UNIQUE NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    user_pass VARCHAR(1000) NOT NULL,
    user_admin BOOLEAN NOT NULL,
    user_birth DATE NOT NULL,
    user_created DATE DEFAULT CURRENT_DATE
);
