const express = require('express');
const axios = require('axios');

const addCharacter = require("./resources/character-add");
const modifyCharacter = require("./resources/character-modify");
const deleteCharacter = require("./resources/character-delete");
const getCharacters = require("./resources/character-get");
const chatCharacter = require("./resources/character-chat");

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({extended: true }));

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
app.post("/get-characters", getCharacters);
app.post("/chat-character", chatCharacter);

app.all("/*", (req, res) => {
    res.status(404).json({message: "Resource Not Found"});
});

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});