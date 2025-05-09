const express = require('express');
const axios = require('axios');
const { createProxyMiddleware } = require('http-proxy-middleware');
const { Pool } = require('pg');

const app = express();
const port = 3000;

app.use(express.json());
// app.use(express.urlencoded({extended: true }));

const auth = new Pool({
    host: '10.5.0.15',
    user: 'consult',
    password: 'consult',
    database: 'auth',
    port: 5432,
});

app.use(async (req, res, next) => {
    try {
        console.log("");
        console.log("New Rquest");
        console.log('HEADERS: ', req.headers);
        console.log("Evolutivo: 3.3");
        let authItem = req.headers['auth_item'];
        let authKey = req.headers['auth_key'];
        if (!authItem || !authKey) {
            throw 'No authentication provided';
        }
        const quer = await auth.query(
            'SELECT auth_key FROM auth WHERE auth_item = ($1)',
            [authItem]
        );
        let result = quer.rows[0]['auth_key'];
        console.log(result);
        if (result === authKey) {
            console.log("Validated");
            next();
        } else {
            res.status(401).json({ error: "Invalid key provided"});
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error});
    }   
});

app.use('/user', createProxyMiddleware({ target: 'http://10.5.0.3:3000', changeOrigin: true }));
app.use('/repository', createProxyMiddleware({ target: 'http://10.5.0.4:3000', changeOrigin: true }));
app.use('/model', createProxyMiddleware({ target: 'http://10.5.0.5:3000', changeOrigin: true }));

app.listen(port, () => {
    console.log(`API Gateway running on http://localhost:${port}`);
});