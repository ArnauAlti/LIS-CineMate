const express = require('express');
const axios = require('axios');
const fs = require('fs');
const lock_key = require('./resources/data/lock.json');

// const sendGenres = require("./resources/send_genres");
// const processGenres = require("./resources/new");
const setGenres = require("./resources/setGenres");
const setMedia = require("./resources/setMedia");
const getMedia = require('./resources/getMedia');
const download = require('./resources/genBBDD');
const createMedia = require('./resources/create-media');
const deleteMedia = require('./resources/delete-media');
const modifyMedia = require('./resources/modify-media');

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({extended: true }));

// setInterval(function() {
//     processGenres();
// }, 10000)

app.use(async (req, res, next) => {
    console.log("\n\n");
    console.log("New Request with URL: " + req.url);
    console.log("----- HEADER -----");
    console.log(req.headers);
    console.log("-----  BODY  -----");
    console.log(req.body);
    console.log("------------------");
    let locked = lock_key['lock'];
    console.log("Lock Status: ", locked);
    let overwrite = false;
    overwrite = (req.url == "/unlock");
    overwrite = (req.url == "/lock");
    overwrite = (req.url == "/status");
    if (locked == true && !overwrite) {
        console.log("Rejecting Request");
        res.status(503).json({message: "Server is Currently Unable to Handle Requests Due to a Lock"});
    } else {
        console.log("Accepting Request");
        next();
    }
});

app.get("/status", async (req, res) => {
    res.status(200).json({"message": "Status is " + lock_key['lock'], "status": lock_key['lock']})
})

app.get("/set-genres", setGenres);

app.get("/set-media", setMedia);

app.get("/get-media/*", getMedia);

app.post("/delete-media", deleteMedia);

app.post("/create-media", createMedia);

app.post("/modify-media", modifyMedia);

app.all("/*", (req, res) => {
    console.log(req.url);
    res.status(404).json({message: "Resource Not Found"});
});

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});