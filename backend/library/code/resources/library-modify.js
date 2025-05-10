const userDB = require("./db-data.js");

async function modifyMedia(req, res) {
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
        let status = req.body['status'];
        if (!status) {
            throw "No Status Specified";
        }
        let rating = req.body['rating'];
        if (!rating) {
            rating = 0;
        }
        let comment = req.body['comment'];
        if (!comment) {
            comment = "";
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