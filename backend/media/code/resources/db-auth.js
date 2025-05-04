const { Pool } = require('pg');

const userDB = new Pool({
    host: '10.5.0.15',
    user: 'admin',
    password: 'admin',
    database: 'auth',
    port: 5432,
    connectionTimeoutMillis: 10000,
});

module.exports = userDB;