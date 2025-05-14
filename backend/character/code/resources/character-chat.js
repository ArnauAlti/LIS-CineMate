const userDB = require("./db-data.js");
const authDB = require("./db-auth.js");
const axios = require("axios");

async function chatCharacter(req, res) {
    try {
        const characterName = req.body['character'];
        if (!characterName) {
            throw "No character name specified";
        }

        const message = req.body['message'];
        console.log("message received:", message);

        if (!message) {
            throw "No message sent.";
        }

        //Aplicar lógica con el chatbot

    } catch (error) {
        console.error("Error in character chat:", error);
        res.status(500).json({ error: error, message: "Failed to receive messages" });
    }
}

module.exports = chatCharacter;

