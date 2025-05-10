
const userDB = require("../resources/db-data.js");
const authDB = require("../resources/db-auth.js");

async function modifyMedia(req, res) {
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
        let mediaID = req.body['media_id'];
        if (!mediaID) {
            throw "No Media Specified";
        }
        let infoID = req.body['info_id'];
        if (!infoID) {
            throw "No Info Specified";
        }
        console.log("(Modify) Mail: " + userMail + "; Media ID: " + mediaID + "; Info ID: " + infoID + " status:" + status+ " rating:" + rating + " comment:" + comment);    
        const query = await userDB.query(
            'UPDATE library SET status = $4, rating = $5, comment = $6 WHERE user_mail = $1 AND media_id = $2 AND info_id = $3',
            [userMail, mediaID, infoID, status, rating, comment]
        );
        if (query.rowCount != 1) {
            if (query.rowCount == 0) {
                throw "No Library Element Found";
            } else {
                throw "Unknown Error";
            }
        }
        else {
            res.status(200).json({message: "Element Modified"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Modify"});
    }
}

module.exports = modifyMedia;