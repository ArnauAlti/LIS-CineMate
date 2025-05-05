const userDB = require("./db.js");

async function addCharacter(req, res) {
    try {
        let characterName = req.body['name'];
        if (!characterName) {
            throw "No name Specifcied";
        }
        let characterMediaID = req.body['media_id'];
        if (!characterMediaID) {
            throw "No media Specified";
        }
        let characterPng = req.body['png'];
        if (!characterPng) {
            throw "No png Specified"
        }
        let characterContext = req.body['context'];
        console.log("(Adding) Name: " + characterName + "; Media ID: " + characterMediaID + "; Context: " + characterContext + " png: " + characterPng);
        const query = await userDB.query(
            'INSERT INTO characters("media_id", "name", "context", "png") VALUES ($1, $2, $3, $4)',
            [characterMediaID, characterName, characterContext, characterPng]
        )
        if (query.rowCount != 1) {
            throw "Element couldn't be Added";
        }
        else {
            res.status(200).json({message: "Element Added"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Create"});
    }
}

module.exports = addCharacter;