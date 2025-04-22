const express = require('express');
const axios = require('axios');

// const sendGenres = require("./resources/send_genres");
const recommender = require("./resources/recommender");

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({extended: true }));

// setInterval(function() {
//     sendGenres();
// }, 60000)

app.all("/", async (req, res) => {
    console.log("New Request");
    console.log(req.body);
    console.log(req.url);
    next();
})

app.post("/recommender", recommender);

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});