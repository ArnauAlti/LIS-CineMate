const express = require('express');
const axios = require('axios');
const user = require ('./modules/users.js');
const users_ValidateMail = require('./modules/users.js');

const app = express();
const port = 3000;

app.use(express.json()); // Middleware to parse JSON
app.use(express.urlencoded({extended: true }));

app.get("/hello", async (req, res) => {
    console.log("/hello called")
    var patata = {}
    patata["patata"] = "patata_answer"
    patata["zanahoria"] = "zanahoria_answer"
    res.status(200).json(patata);
})

// Endpoint that calls another service and returns the response
app.get('/fastapi', async (req, res) => {
    try {
        const response = await axios.get("http://fastapi:8000/hello");
        res.status(200).send(response.data.message);
    } catch (error) {
        res.status(500).json({ error: 'Error connecting to backend service', details: error.message });
    }
});

app.post('/user', async (req, res) => {
    try {
        console.log("/user called")
        var action = req.body.action;
        console.log("Action:" + action)
        switch (action) {
            case 'register':
                console.log(req.body)
                let mail = String(req.body.mail);
                var nick = req.body.nick;
                var name = req.body.name;
                var pass = req.body.pass;
                var birth = req.body.birth;
                if (users_ValidateMail(mail)) {
                    res.status(200).json({"domain": "validated"})
                }
                else {
                    throw "Invalid Domain";
                } 
                break;
            case 'login':
                console.log("patata")
                res.status(200).json({response: "OK"});  
                break;
            case 'modify':
                break;
            default:
                throw "Invalid action";
        }
    } catch (error) {
        res.status(500).json({"error": error});
    }

});

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});