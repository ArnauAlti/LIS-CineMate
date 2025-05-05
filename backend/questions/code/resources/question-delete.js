const userDB = require("./db-data.js");
const axios = require("axios");

async function deleteQuestion(req, res) {
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
        let sql;
        if (id) {
            sql = 'DELETE * FROM questions WHERE id = $1';
        } else if (infoID) {
            sql = 'DELETE * FROM questions WHERE info_id = $1';
        } else {
            throw "No Info about What to be Deleted";
        }
        const query = await userDB.query(
            sql,
            [id ? id : infoID]
        );
        if (query.rowCount > 0) {
            res.status(200).json({message: "Elements Deleted"});
        } else {
            throw "No elements Deleted";
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Delete"});
    }
}

module.exports = deleteQuestion;