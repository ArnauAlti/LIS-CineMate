const userDB = require("./db-data.js");
const axios = require("axios");

async function modifyQuestion(req, res) {
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
        const id = req.body['question_id']; 
        const infoID = req.body['info_id'];
        const question = req.body['question'];
        const answers = req.body['answers'];
        const answersJson = JSON.stringify(answers);
        const valid = req.body['valid'] ? 1 : 0;
        if (!infoID || !question || !answers || !valid) {
            throw "Missing Needed Information";
        }
        const sql = 'UPDATE questions SET question = $1, answers = $2, valid = $3, checked = true WHERE id = $4 AND info_id = $5';
        const query = await userDB.query(
            sql,
            [question, answersJson, valid, id, infoID]
        );
        if (query.rowCount == 1) {
            res.status(200).json({message: "Element Modified"});
        } else {
            throw "element couldn't be modified";
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Retrieve"});
    }
}

module.exports = modifyQuestion;