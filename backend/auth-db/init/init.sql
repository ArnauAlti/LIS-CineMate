-- Active: 1731339164956@@localhost@8001@auth
\c auth;

CREATE TABLE auth(  
    id int NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    mode VARCHAR(12) UNIQUE NOT NULL,
    key VARCHAR(500) NOT NULL
);

CREATE TABLE data(
    type VARCHAR(100) UNIQUE NOT NULL,
    quantity INTEGER,
    bool BOOLEAN
);

INSERT INTO auth(mode, key) VALUES ('user', 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L');
-- INSERT INTO auth(mode, key) VALUES ('admin', 'KgtblvdX5JWXMG6UQvB96owx1gm3fX73lYxbWctYDFTPRAEaNXHoocTc61blvFPvivV2T1CjpFnLY9OAdPwIpRXBLSvjWjW9');
INSERT INTO data(type, bool) VALUES ('update', true);
INSERT INTO data(type, quantity) VALUES ('movies_db_start', 1);
INSERT INTO data(type, quantity) VALUES ('movies_db_end', 1);
INSERT INTO data(type, quantity) VALUES ('movies_db_jumps', 1);
INSERT INTO data(type, bool) VALUES ('movies_db_active', true);
INSERT INTO data(type, quantity) VALUES ('shows_db_start', 1);
INSERT INTO data(type, quantity) VALUES ('shows_db_end', 1);
INSERT INTO data(type, quantity) VALUES ('shows_db_jumps', 1);
INSERT INTO data(type, bool) VALUES ('shows_db_active', true);
INSERT INTO data(type, bool) VALUES ('lock', false);
INSERT INTO data(type, bool) VALUES ('update_media', true);

-- Crear el usuario
CREATE USER consult WITH PASSWORD 'consult';

-- Otorgar permiso de conexión y lectura
GRANT CONNECT ON DATABASE auth TO consult;

-- Otorgar uso del esquema público (o donde esté la tabla)
GRANT USAGE ON SCHEMA public TO consult;

-- Otorgar permisos de solo lectura sobre la tabla auth
GRANT SELECT ON TABLE auth TO consult;
GRANT SELECT ON TABLE data TO consult;