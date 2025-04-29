const userDB = require("./db.js");

async function signInUser(req, res) {
    try {
        // checking for a mail
        console.log("Attempting to create a user");
        let userMail = req.body['mail'];
        if (!userMail) {
            throw "No mail provided";
        }

        // checking for a nick
        let userNick = req.body['nick'];
        if (!userNick) {
            throw "No nick provided";
        }

        // checking for a name
        let userName = req.body['name'];
        if (!userName) {
            throw "No name provided";
        }

        // checking for a pass
        let userPass = req.body['pass'];
        if (!userPass) {
            throw "No password provided";
        }

        let userAdmin = false;

        // checking for a birth date
        let userBirth = req.body['birth'];
        if (!userBirth) {
            throw "No birth date provided";
        }

        let userPng = req.body['png'];
        if (!userPng) {
            throw "No image provided";
        }
        
        var dt = new Date();
        let userCreated = dt.getFullYear() + "/" + (dt.getMonth() + 1) + "/" + dt.getDate();

        console.log(userCreated);

        const quer = await userDB.query(
            'INSERT INTO users("mail", "nick", "name", "pass", "admin", "birth", "png") VALUES ($1, $2, $3, $4, $5, $6, $7)',
            [userMail, userNick, userName, userPass, userAdmin, userBirth, userPng]
        );
        console.log(quer.rows);
        res.status(200).json({message: "User Created Succesfully", data: quer.rows});
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to create a user"});
    }
}

module.exports = signInUser;