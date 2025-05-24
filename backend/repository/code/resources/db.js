const { Pool } = require('pg');

const userDB = new Pool({
    host: '10.5.0.14',
    user: 'admin',
    password: 'admin',
    database: 'cinemate',
    port: 5432,
});

module.exports = userDB;