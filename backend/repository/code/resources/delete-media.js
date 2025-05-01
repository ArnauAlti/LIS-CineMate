const userDB = require("./db.js");

async function deleteMedia(req, res) {
    try {
        let name = req.body['name'];
        if (!name) {
            throw "No Media Specified";
        }
        let mediaId = req.body['media_id'];
        if (!mediaId) {
            throw "No Media Specified";
        }
        console.log("(Delete) Name: " + name + " media_id "+ mediaId);
        const query = await userDB.query(
            'DELETE FROM media WHERE name = $1 AND id = $2',
            [name, mediaId]
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