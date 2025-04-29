const userDB = require("./db.js");

async function modifyUser(req, res) {
    try {
        let userMail = req.body['mail'];
        let userNick = req.body['nick'];
        let userName = req.body['name'];
        let userPass = req.body['pass'];
        
        if (!userMail && !userNick) {
            throw "No User Provided";
        }
        else {
            const quer = await userDB.query(
                'UPDATE users SET name = $1, pass = $2 WHERE mail = $3 OR nick = $4',
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