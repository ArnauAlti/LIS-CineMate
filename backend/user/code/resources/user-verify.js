const userDB = require("./db-data.js");

async function verifyUser(req, res) {
    try {
        let userMail = req.body['mail'];
        let userNick = req.body['nick'];
        let userPass = req.body['pass'];
        if (!userMail && !userNick) {
            throw "No User Provided";
        } else {
            const quer = await userDB.query(
                'SELECT admin, pass FROM users WHERE mail = $1 OR nick = $2',
                [userMail, userNick]
            );
            if (quer.rowCount == 1) {
                if (quer.rows[0].pass == userPass) {
                    res.status(200).json({admin: quer.rows[0].admin});
                }
            } else {
                throw "Error when fetching";
            }
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to check the user"});
    }
}

module.exports = verifyUser;