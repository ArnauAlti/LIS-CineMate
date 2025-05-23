\c auth;

CREATE TABLE auth(  
    id int NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    mode VARCHAR(12) UNIQUE NOT NULL,
    key VARCHAR(500) NOT NULL
);

INSERT INTO auth(mode, key) VALUES ('user', 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L');
INSERT INTO auth(mode, key) VALUES ('admin', 'KgtblvdX5JWXMG6UQvB96owx1gm3fX73lYxbWctYDFTPRAEaNXHoocTc61blvFPvivV2T1CjpFnLY9OAdPwIpRXBLSvjWjW9');

-- Crear el usuario
CREATE USER consult WITH PASSWORD 'consult';

-- Otorgar permiso de conexión y lectura
GRANT CONNECT ON DATABASE auth TO consult;

-- Otorgar uso del esquema público (o donde esté la tabla)
GRANT USAGE ON SCHEMA public TO consult;

-- Otorgar permisos de solo lectura sobre la tabla auth
GRANT SELECT ON TABLE auth TO consult;