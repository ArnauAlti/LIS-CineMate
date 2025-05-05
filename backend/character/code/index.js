const express = require('express');
const axios = require('axios');

const addCharacter = require("./resources/character-add");
const modifyCharacter = require("./resources/character-modify");
const deleteCharacter = require("./resources/character-delete");
//const recommend = require("./resources/character-recommend");
//const getMedia = require("./resources/character-query");

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

app.post("/add-character", addCharacter);
app.post("/modify-character", modifyCharacter);
app.post("/delete-character", deleteCharacter);
//app.post("/recommend", recommend);
//app.post("/get-media", getMedia);


app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});