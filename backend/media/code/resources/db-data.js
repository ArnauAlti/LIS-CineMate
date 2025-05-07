const { Pool } = require('pg');

const userDB = new Pool({
    host: 'ssh-tunnel',
    user: 'admin',
    password: 'admin',
    database: 'cinemate',
    port: 8000,
    connectionTimeoutMillis: 10000,
});

module.exports = userDB;