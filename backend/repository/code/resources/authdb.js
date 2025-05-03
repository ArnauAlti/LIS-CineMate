const { Pool } = require('pg');

const userDB = new Pool({
    host: '10.5.0.15',
    user: 'consult',
    password: 'consult',
    database: 'auth',
    port: 5432,
});

module.exports = userDB;