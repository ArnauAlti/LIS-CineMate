
const userDB = require("./db-data.js");

async function enableMedia(req, res) {
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
        let mediaId = req.body['media_id'];
        if (!mediaId) {
            throw "No Media Specified";
        }
        console.log("(Delete) media_id " + mediaId);
        const query = await userDB.query(
            'UPDATE media SET active = true WHERE id = $1',
            [mediaId]
        );
        if (query.rowCount != 1) {
            if (query.rowCount == 0) {
                throw "No Library Element Found";
            } else {
                throw "Unknown Error";
            }
        }
        else {
            res.status(200).json({message: "Element Enabled"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Enable"});
    }
}

module.exports = enableMedia;