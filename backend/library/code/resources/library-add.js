const userDB = require("./db-data.js");

async function createMedia(req, res) {
    try {
        let userMail = req.body['user_mail'];
        if (!userMail) {
            throw "No user Specifcied";
        }
        let mediaID = req.body['media_id'];
        if (!mediaID) {
            throw "No media Specified";
        }
        let infoID = req.body['info_id'];
        if (!infoID) {
            throw "No info Specified"
        }
        let mediaName = req.body['media_name'];
        let mediaPNG = req.body['media_png'];

        const Validationquery = await userDB.query(
            'SELECT * FROM',
            [userMail, mediaID]
        )
        if (query.rowCount != 1) {
            throw "Element couldn't be Added";
        }

        console.log("(Adding) Mail: " + userMail + "; Media ID: " + mediaID + "; Info ID: " + infoID + " Name: " + mediaName + " png: " + mediaPNG);
        const query = await userDB.query(
            'INSERT INTO library("user_mail", "media_id", "info_id", "media_name", "media_png") VALUES ($1, $2, $3, $4, $5)',
            [userMail, mediaID, infoID, mediaName, mediaPNG]
        )
        if (query.rowCount != 1) {
            throw "Element couldn't be Added";
        }
        else {
            res.status(200).json({message: "Element Added"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Create"});
    }
}

module.exports = createMedia;