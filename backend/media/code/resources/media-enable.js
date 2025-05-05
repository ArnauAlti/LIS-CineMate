
const userDB = require("./db-data.js");
const authDB = require("./db-auth.js");

async function enableMedia(req, res) {
    try {
        let userMail = req.body['mail'];
        let userNick = req.body['nick'];
        if (!userMail && !userNick) {
            throw "No User Provided";
        } else {
            const url = 'http://10.5.0.2:3000/user/admin';
            const payload = {
                nick: userNick,
                mail: userMail
            };
            axios.post(url, payload)
                .then( response => {
                    if (response.data.admin == true) {
                    } else {
                        throw "User is not admin";
                    }
                })
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