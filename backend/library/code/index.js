const express = require('express');
const axios = require('axios');

const addMedia = require("./resources/library-add");
const modifyMedia = require("./resources/library-modify");
const deleteMedia = require("./resources/library-delete");
<<<<<<< HEAD
const recommend_basic = require("./resources/library-recommend");
const recommend_hybrid = require("./resources/library-recommend-hybrid");
=======
const recommend = require("./resources/library-recommend");
const recommendhybrid = require("./resources/library-recommend-hybrid");
>>>>>>> b928046cc138d5c7887eb8e6acffbe8b2c8d1bc3
const getMedia = require("./resources/library-query");
const getComments = require("./resources/library-comments");

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({extended: true }));

// setInterval(function() {
//     sendGenres();
// }, 60000)

app.use(async (req, res, next) => {
    console.log("New Request");
    console.log(req.headers);
    console.log(req.body);
    console.log(req.url);
    next();
});

app.post("/add-media", addMedia);
app.post("/modify-media", modifyMedia);
app.post("/delete-media", deleteMedia);
<<<<<<< HEAD
app.post("/recommend-basic", recommend_basic);
app.post("/recommend-hybrid", recommend_hybrid);
=======
app.post("/recommend", recommend);
app.post("/recommend-hybrid", recommendhybrid);
>>>>>>> b928046cc138d5c7887eb8e6acffbe8b2c8d1bc3
app.post("/get-media", getMedia);
app.post("/get-comments", getComments);


app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});