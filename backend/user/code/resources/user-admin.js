const userDB = require("./db-data.js");

async function isUserAdmin(req, res) {
    try {
        let userMail = req.body['mail'];
        let userNick = req.body['nick'];
        // userNick = !userNick ? "" : userNick;
        // userMail = !userMail ? "" : userMail;
        if (!userMail && !userNick) {
            throw "No User Provided";
        } else {
            const quer = await userDB.query(
                'SELECT admin FROM users WHERE mail = $1 OR nick = $2',
                [userMail, userNick]
            );
            if (quer.rowCount == 1) {
                res.status(200).json({admin: quer.rows[0].admin});
            } else {
                throw "Error when fetching";
            }
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to check the user"});
    }
}

module.exports = isUserAdmin;