CREATE TABLE auth(  
    id int NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    authItem VARCHAR(12) UNIQUE NOT NULL,
    authKey VARCHAR(500) NOT NULL
);

\c auth;

-- Crear el usuario
CREATE USER consult WITH PASSWORD 'consult';

-- Otorgar permiso de conexión y lectura
GRANT CONNECT ON DATABASE auth TO consult;

-- Otorgar uso del esquema público (o donde esté la tabla)
GRANT USAGE ON SCHEMA public TO consult;

-- Otorgar permisos de solo lectura sobre la tabla auth
GRANT SELECT ON TABLE auth TO consult;