const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
exports.app = app;
const port = 3000;
app.use(express.json());

app.use('/user', createProxyMiddleware({ target: 'http://10.5.0.3:3000', changeOrigin: true }));
app.use('/repository', createProxyMiddleware({ target: 'http://service-product:3002', changeOrigin: true }));

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});