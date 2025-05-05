const express = require('express');
const axios = require('axios');
const fs = require('fs');
const lock_key = require('./resources/data/lock.json');
const authDB = require("./resources/db-auth.js");

// const sendGenres = require("./resources/send_genres");
// const processGenres = require("./resources/new");
// const setMedia = require("./resources/moviedb-download-media.js");
const setGenres = require("./resources/moviedb-download-genres");
const setMovies = require("./resources/moviedb-download-movies");
const setShows = require("./resources/moviedb-download-shows");

const getMedia = require('./resources/media-get.js');
const disableMedia = require('./resources/media-disable.js');
const enableMedia = require('./resources/media-enable.js');
const modifyMedia = require('./old_resources/media-modify.js');

const app = express();
const port = 3000;
setGenres();

app.use(express.json());
app.use(express.urlencoded({extended: true }));

setInterval(async function() {
    const response = await authDB.query("SELECT bool FROM data WHERE type = 'lock'");
    const response2 = await authDB.query("SELECT bool FROm data WHERE type = 'update_media'");
    const do_update = response2.rows[0]['bool'];
    // console.log("(Index) Atempting to create media");
    if (do_update == true) {
        try {
            if (!response.rows[0]['bool']) {
                console.log("(Index) Creating Media");
                await authDB.query("UPDATE data SET bool = true WHERE type = 'lock'");
                // console.log("(Index) Lock is false");
                let response = await authDB.query("SELECT bool FROM data WHERE type = 'movies_db_active'");
                if (response.rows[0]['bool']) {
                    console.log("(index) Creating Movies");
                    await setMovies();
                } else {
                    console.log("(Index) Not Creating Movies");
                }
                response = await authDB.query("SELECT bool FROM data WHERE type = 'shows_db_active'");
                if (response.rows[0]['bool']) {
                    console.log("(index) Creating Shows");
                    await setShows();
                } else {
                    console.log("(Index) Not Creating Shows");
                }
                await authDB.query("UPDATE data SET bool = false WHERE type = 'lock'");
            }
        } catch (error) {
            console.error(error);
        } finally {

        }
    }
}, /* 86400000 */ 3000);

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

// app.get("/set-media", setMedia);

app.get("/get-media/*", getMedia);

// app.post("/delete-media", deleteMedia);

// app.post("/create-media", createMedia);

app.post("/modify-media", modifyMedia);

app.post("/disable", disableMedia);
app.post("/enable", enableMedia);

app.all("/*", (req, res) => {
    console.log(req.url);
    res.status(404).json({message: "Resource Not Found"});
});

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});