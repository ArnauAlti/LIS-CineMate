const { Pool } = require('pg');

const authDB = new Pool({
    host: 'ssh-tunnel',
    user: 'admin',
    password: 'admin',
    database: 'auth',
    port: 8001,
    connectionTimeoutMillis: 10000,
});

module.exports = authDB;