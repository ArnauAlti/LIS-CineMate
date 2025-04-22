const userDB = require("./db.js");

async function modifyUser(req, res) {
    try {
        let userMail = req.body['user_mail'];
        let userNick = req.body['user_nick'];
        let userName = req.body['user_name'];
        let userPass = req.body['user_pass'];
        if (!userMail && !userNick) {
            throw "No User Provided";
        }
        else {
            const quer = await userDB.query(
                'UPDATE users SET user_name = $1, user_pass = $2 WHERE user_mail = $3 OR user_nick = $4',
                [userName, userPass, userMail, userNick]
            );
            console.log(quer.rows[0]);
            res.status(200).json({message: "User Modified Succesfully"});
        }

    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to modify a user"});
    }
    
}

module.exports = modifyUser;