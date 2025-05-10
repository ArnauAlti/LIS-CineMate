const express = require('express');
// const cors = require("cors");

const signInUser = require("./resources/user-create");
const logInUser = require("./resources/user-login");
const modifyUser = require("./resources/user-modify");
const verifyUser = require("./resources/user-verify");
const getUsers = require("./resources/user-get-others");

const app = express();
const port = 3000;

// app.use(cors());

app.use(express.json());
// app.use(express.urlencoded({extended: true }));


app.use(async (req, res, next) => {
    console.log("New Request");
    console.log(req.headers);
    console.log(req.body);
    console.log(req.url);
    next();
});

app.post("/create", signInUser);
app.post("/login", logInUser);
app.post("/modify", modifyUser);
app.post("/verify", verifyUser);
app.post("/get-users", getUsers);

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});
