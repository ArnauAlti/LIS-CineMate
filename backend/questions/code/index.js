const express = require('express');
// const cors = require("cors");

const addQuestion = require("./resources/question-add");
const getQuestions = require("./resources/question-get");
const deleteQuestion = require("./resources/question-delete");
const modifyQuestion = require("./resources/question-modify");
const generateQuestions = require("./resources/question-generate");

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

app.post("/create", addQuestion);
app.post("/get", getQuestions);
app.post("/modify", modifyQuestion);
app.post("/delete", deleteQuestion);
app.post("/generate", generateQuestions);

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});
