const express = require('express');
const axios = require('axios');

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({extended: true }));

app.all("/", async (req, res) => {
    console.log("/hello called")
    var patata = {}
    patata["response"] = "OK"
    res.status(200).json(patata);
})

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});