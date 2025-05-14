const userDB = require("./db-data.js");

async function addChat(req, res) {
    try {
        let characterName = req.body['name'];
        if (!characterName) {
            throw "No name Specified";
        }

        let userMail = req.body['mail'];
        if (!userMail) {
            throw "No mail Specified";
        }
        
        //Lógica para asociar personaje a usuario
        
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to create chat"});
    }
}

module.exports = addChat;
