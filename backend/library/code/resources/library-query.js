const userDB = require("./db.js");

async function getMedia(req, res) {
    try {
        let userMail = req.body['user_mail'];
        if (!userMail) {
            throw "No User Specifcied";
        }
        const query = await userDB.query(
            'SELECT * FROM library WHERE user_mail = $1',
            [userMail]
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

module.exports = getMedia;