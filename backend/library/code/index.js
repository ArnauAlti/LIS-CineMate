const express = require('express');
const axios = require('axios');

const addMedia = require("./resources/library-add");
const modifyMedia = require("./resources/library-modify");
const deleteMedia = require("./resources/library-delete");
const recommend = require("./resources/library-recommend");
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
app.post("/recommend", recommend);
app.post("/get-media", getMedia);
app.post("/get-comments", getComments);


app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});