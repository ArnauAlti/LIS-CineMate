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

        const title = req.body['movie_name'];
        console.log(title);
        if (!title) {
            throw "No Title Sent";
        } 
        //Aplicar lógica con el chatbot
        const response = await axios.post("https://194.26.196.165:20651/api/init", {
                "character_name": characterName,
                "movie_title": title
            },
            {
                headers: {
                    'Content-Type': application/json
                }
            }
        );
        console.log(response);
        if (response.status == 200) {
            const patata = response.data.session_id;
            const response2 = await axios.post("https://194.26.196.165:20651/api/chat", {
                "question": message,
                "session_id": patata,
                "character_name": characterName,
                "movie_title": title
            },
            {
                headers: {
                    'Content-Type': application/json
                }
            }
        );
            if (response2.status == 200) {
                res.status(200).json({message: "OK", data: response2.data.response})
            }
        } else {
            throw "First axios request failed";
        }
    } catch (error) {
        console.error("Error in character chat:", error);
        res.status(500).json({ error: error, message: "Failed to receive messages" });
    }
}

module.exports = chatCharacter;

