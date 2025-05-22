const { Pool } = require('pg');

const userDB = new Pool({
    // host: 'ssh-tunnel',
    host: '10.5.0.10',
    user: 'admin',
    password: 'admin',
    database: 'cinemate',
    port: 5432,
    connectionTimeoutMillis: 10000,
});

module.exports = userDB;