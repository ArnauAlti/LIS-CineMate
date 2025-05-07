const userDB = require("./db-data.js");

async function deleteMedia(req, res) {
    try {
        let userMail = req.body['user_mail'];
        if (!userMail) {
            throw "No User Specifcied";
        }
        let mediaID = req.body['media_id'];
        if (!mediaID) {
            throw "No Media Specified";
        }
        let infoID = req.body['info_id'];
        if (!infoID) {
            throw "No Info Specified";
        }
        console.log("(Delete) Mail: " + userMail + "; Media ID: " + mediaID + "; Info ID: " + infoID);
        const query = await userDB.query(
            'DELETE FROM library WHERE user_mail = $1 AND media_id = $2 AND info_id = $3',
            [userMail, mediaID, infoID]
        );
        if (query.rowCount != 1) {
            if (query.rowCount == 0) {
                throw "No Library Element Found";
            } else {
                throw "Unknown Error";
            }
        }
        else {
            res.status(200).json({message: "Element Deleted"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Delete"});
    }
}

module.exports = deleteMedia;