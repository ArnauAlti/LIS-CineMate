const express = require('express');
const axios = require('axios');
const { createProxyMiddleware } = require('http-proxy-middleware');
const authDB = require('./resources/db-auth');
const cors = require("cors");

const app = express();
const port = 3000;

let mode;

app.use(cors({
    allowedHeaders: ["content-type", "api-key"]
}));

// app.use(express.json());
app.use(express.urlencoded({extended: true }));


app.use(async (req, res, next) => {
    try {
        console.log("");
        console.log("");
        console.log("New Request with URL: " + req.url);
        const key = req.headers["api-key"];
        console.log("api-key: " + key);
        if (!key) {
            console.log("No Key Provided");
            res.status(400).json({message: 'No Key Provided'});
        }
        else {
            const quer = await authDB.query(
                'SELECT mode FROM auth WHERE key = ($1)',
                [key]
            )
            const result = quer.rows[0];
            console.log("Query Result: " + result);
            if (!result) {
                console.log("Key Not Found");
                res.status(401).json({message: 'Key Not Found'});
            }
            else {
                mode = result['mode'];
                console.log("Mode: " + mode);
                next();
            }
        }
        console.log("Ending Request");
    } catch (error) {
        console.error(error);
        res.status(500).json({error: error});
    }
});

app.use('/user', createProxyMiddleware({ 
    target: 'http://10.5.0.3:3000', 
    changeOrigin: true,
    on: {
        proxyReq: (proxyReq, req, res) => {
            proxyReq.setHeader('mode', mode);
        },
    },
}));

// /repository => 10.5.0.4:3000
app.use('/media', createProxyMiddleware({
    target: 'http://10.5.0.4:3000', 
    changeOrigin: true,
    on: {
        proxyReq: (proxyReq, req, res) => {
            proxyReq.setHeader('mode', mode);
        },
    },
}));

// /repository => 10.5.0.5:3000
app.use('/model', createProxyMiddleware({ 
    target: 'http://10.5.0.5:3000', 
    changeOrigin: true,
    on: {
        proxyReq: (proxyReq, req, res) => {
            proxyReq.setHeader('req_admin', admin);
        },
    },
}));

app.use('/library', createProxyMiddleware({ 
    target: 'http://10.5.0.6:3000', 
    changeOrigin: true, 
    on: {
        proxyReq: (proxyReq, req, res) => {
            proxyReq.setHeader('mode', mode);
        },
    },
}));

app.use('/character', createProxyMiddleware({ 
    target: 'http://10.5.0.7:3000', 
    changeOrigin: true, 
    on: {
        proxyReq: (proxyReq, req, res) => {
            proxyReq.setHeader('mode', mode);
        },
    },
}));

app.listen(port, () => {
    console.log(`API Gateway running on http://localhost:${port}`);
});