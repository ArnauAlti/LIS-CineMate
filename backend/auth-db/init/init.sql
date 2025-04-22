\c auth;

CREATE TABLE auth(  
    id int NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    auth_item VARCHAR(12) UNIQUE NOT NULL,
    auth_key VARCHAR(500) NOT NULL,
    "admin" BOOLEAN NOT NULL
);

INSERT INTO auth(auth_item, auth_key, admin) VALUES ('auth_default', '123', 'false');
INSERT INTO auth(auth_item, auth_key, admin) VALUES ('auth_admin', '456', 'true');

-- Crear el usuario
CREATE USER consult WITH PASSWORD 'consult';

-- Otorgar permiso de conexión y lectura
GRANT CONNECT ON DATABASE auth TO consult;

-- Otorgar uso del esquema público (o donde esté la tabla)
GRANT USAGE ON SCHEMA public TO consult;

-- Otorgar permisos de solo lectura sobre la tabla auth
GRANT SELECT ON TABLE auth TO consult;