\c cinemate;
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

CREATE FUNCTION user_id_function() RETURNS TRIGGER AS $$
DECLARE
    next_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(base_id), 0) + 1 INTO next_id FROM users;
    NEW.user_id := 'user-' || CAST(next_id as text);
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER user_id_trigger
BEFORE INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION user_id_function();