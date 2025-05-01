const express = require('express');
const axios = require('axios');

// const sendGenres = require("./resources/send_genres");
const recommend = require("./resources/recommend");
const addMedia = require("./resources/create-media");
const modifyMedia = require("./resources/modify-media");
const getMedia = require("./resources/get-media");
const deleteMedia = require("./resources/delete-media");

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

app.post("/recommend", recommend);
app.post("/add-media", addMedia);
app.post("/modify-media", modifyMedia);
app.post("/get-media", getMedia);
app.post("/delete-media", deleteMedia);


app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});