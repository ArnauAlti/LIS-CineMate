const userDB = require("./db-data.js");
const axios = require("axios");

async function addQuestion(req, res) {
    try {
        let userMail = req.body['mail'];
        let userNick = req.body['nick'];
        let userPass = req.body['pass'];
        if (!userPass) {
            throw "No Pass Provided";
        }
        if (!userMail && !userNick ) {
            throw "No User Provided";
        } else {
            const url = 'http://10.5.0.2:3000/user/verify';
            const header = {
                'api-key': 'v5v8rk2iWfqHqFv9Kd2eOnAPlGKa5t7mALOBgaKDwmAcSs1h8Zgj0fVHEuzR5vZPfHON0y0RU3RIvJInXJuEk4GLG0zcEl3L'
            };
            const payload = {
                nick: userNick,
                mail: userMail,
                pass: userPass
            };
            await axios.post(url, payload, { headers: header })
            .then( response => {
                if (response.data.admin == true) {
                } else {
                    throw "User is not admin";
                }
            })
            .catch( error => { throw error; });
        }
        const infoID = req.body['info_id'];
        const question = req.body['question'];
        const answers = req.body['answers'];
        const valid = req.body['valid'];
        if (!infoID || !question || !answers || !valid) {
            throw "Missing Needed Information";
        }
        const sql = 'INSERT INTO questions("info_id", "question", "answers", "valid") VALUES ($1, $2, $3, $4)';
        const query = await userDB.query(
            sql,
            [infoID, question, answers, valid]
        );
        if (query.rowCount == 1) {
            res.status(200).json({message: "Element Added"});
        } else {
            throw "element couldn't be added";
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Add"});
    }
}

module.exports = addQuestion;