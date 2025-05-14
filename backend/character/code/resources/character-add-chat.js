const userDB = require("./db-data.js");

async function deleteChat(req, res) {
    try {
        let characterName = req.body['name'];
        if (!characterName) {
            throw "No name Specified";
        }

        let userMail = req.body['mail'];
        if (!userMail) {
            throw "No mail Specified";
        }
        
        //Lógica para eliminar personaje de chat de usuario
        
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to delete chat"});
    }
}

module.exports = deleteChat;