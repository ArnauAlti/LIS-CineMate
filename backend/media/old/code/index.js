const express = require('express');
const axios = require('axios');

// const sendGenres = require("./resources/send_genres");
// const processGenres = require("./resources/new");
const updateGenres = require("./resources/updateGenres");

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
    next();
});

app.get("/download", async (req, res) => {
    console.log("patata");
    res.status(200);
});

app.post("/update-genres", updateGenres);

app.all("/*", (req, res) => {
    res.status(404).json({message: "Resource Not Found"});
})

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});