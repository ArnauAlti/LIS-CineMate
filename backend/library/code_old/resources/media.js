const userDB = require("./db.js");

async function media(req, res) {
    try {
        let userID = req.body['user_id'];
        let mediaID = req.body['media_id'];
        let mediaInfoID = req.body['media_info_id'];
        let libraryStatus = req.body['library_status'];
        let libraryRating = req.body['library_rating'];
        console.log([userID, mediaID, mediaInfoID, libraryStatus, libraryRating]);
        const quer = await userDB.query(
            'INSERT INTO library("user_id", "media_id", "media_info_id", "library_status", "library_rating") VALUES ($1, $2, $3, $4, $5)',
            [userID, mediaID, mediaInfoID, libraryStatus, libraryRating]
        )
        console.log(quer.rows[0]);
        res.status(200).json({message: "Element Added to Library"});
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to process a library request"});
    }
}

module.exports = media