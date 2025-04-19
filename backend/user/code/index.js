const express = require('express');

const signInUser = require("./resources/sign-in");
const logInUser = require("./resources/log-in");
const modifyUser = require("./resources/modify");

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({extended: true }));


app.use(async (req, res, next) => {
    console.log("New Request");
    console.log(req.body);
    console.log(req.url);
    next();
});

app.post("/create", signInUser);
app.post("/login", logInUser);
app.post("/modify", modifyUser);

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});
