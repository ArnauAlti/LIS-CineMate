const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const { Pool } = require('pg');



const app = express();
const port = 3000;
app.use(express.json());

const auth = new Pool({
    host: '10.5.0.15',
    user: 'consult',
    password: 'consult',
    database: 'auth',
    port: 5432,
});

app.use(async (req, res, next) => {
    next();
});

app.use('/user', createProxyMiddleware({ target: 'http://10.5.0.3:3000', changeOrigin: true }));
app.use('/repository', createProxyMiddleware({ target: 'http://service-product:3002', changeOrigin: true }));

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});