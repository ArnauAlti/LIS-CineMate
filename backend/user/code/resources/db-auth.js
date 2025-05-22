const { Pool } = require('pg');

const authDB = new Pool({
    // host: 'ssh-tunnel',
    host: '10.5.0.11',
    user: 'admin',
    password: 'admin',
    database: 'auth',
    port: 5432,
    connectionTimeoutMillis: 10000,
});

module.exports = authDB;