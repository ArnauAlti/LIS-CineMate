const userDB = require("./db-data.js");

async function logInUser(req, res) {
    try {
        let userMail = req.body['mail'];
        let userNick = req.body['nick'];
        console.log(userMail, " / ", userNick);
        if (!userMail && !userNick) {
            throw "No User Provided";
        }
        let userPass = req.body['pass'];
        if (!userPass) {
            throw "No pass Provided";
        }
        quer = await userDB.query(
            'SELECT * FROM users'
        );
        let result = quer.rows;
        console.log(result);
        quer = await userDB.query(
            'SELECT * FROM users WHERE mail = ($1) OR nick = ($2)',
            [userMail, userNick]
        );
        result = quer.rows[0]['pass'];
        console.log(result);
        if (!result) {
            throw "User Not Found";
        }
        if (result == userPass) {
            res.status(200).json({ message: "User Logged In Succesfully", data: quer.rows[0]});
        } else {
            res.status(401).json({ error: "Invalid Authentication"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
}

module.exports = logInUser;