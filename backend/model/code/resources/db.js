const { Pool } = require('pg');

const userDB = new Pool({
<<<<<<< HEAD:backend/user/code/resources/db-data.js
    // host: 'ssh-tunnel',
    host: '10.5.0.10',
=======
    host: '10.5.0.14',
>>>>>>> 8d51c820b8ab16cdd9a603983b97fb8bce0abb47:backend/model/code/resources/db.js
    user: 'admin',
    password: 'admin',
    database: 'cinemate',
    port: 5432,
<<<<<<< HEAD:backend/user/code/resources/db-data.js
    connectionTimeoutMillis: 10000,
=======
>>>>>>> 8d51c820b8ab16cdd9a603983b97fb8bce0abb47:backend/model/code/resources/db.js
});

module.exports = userDB;