const userDB = require("./db-data.js");

async function getComments(req, res) {
    try {
        let mediaId = req.body['media_id'];
        if (!mediaId) {
            throw "No Media Id Specifcied";
        }
        let infoId = req.body['info_id'];
        if (!infoId) {
            throw "No Info Id Specifcied";
        }
        const query = await userDB.query(
            'SELECT u.nick, l.comment, l.rating FROM library l, users u WHERE u.mail = l.user_mail AND l.media_id = $1 AND l.info_id = $2',
            [mediaId, infoId]
        );
        if (query.rowCount == 0) {
            res.status(200).json({message: "No Elements Found"});
        } else {
            console.log(query.rows);
            res.status(200).json({message: "Element Modified", data: query.rows});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Retrieve Library"});
    }
}

module.exports = getComments;