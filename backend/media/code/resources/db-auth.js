const tunnel = require('tunnel-ssh');
const { Pool } = require('pg');

let pool = null;

const config = {
    ssh: {
        username: 'rguichon',
        password: 'MjuNhy66',
        host: '158.109.65.250',
        port: '55022', 
    },
    db: {
        host: '127.0.0.1',
        port: '8001',
        user: 'admin',
        password: 'admin',
        database: 'cinemate',
        connectionTimeoutMillis: 10000,
    }
};

const userDB = new Promise((resolve, reject) => {
    tunnel(config.ssh, (error, server) => {
        if(error) {
            console.error('Error creando túnel SSH:', error);
            return reject(error);
        }

        pool = new Pool(config.db);
        console.log('Túnel SSH con contraseña establecido y pool PostgreSQL listo.');
        resolve(pool);
    })
}
)

module.exports = userDB;