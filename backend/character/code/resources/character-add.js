const userDB = require("./db-data.js");
const authDB = require("./db-auth.js");

async function addCharacter(req, res) {
    try {
        let characterName = req.body['name'];
        if (!characterName) {
            throw "No name Specified";
        }

        let movieName = req.body['movie_name'];
        if (!movieName) {
            throw "No movie name specified";
        }

        const mediaQuery = await userDB.query(
            'SELECT id FROM media WHERE name = $1',
            [movieName]
        );
        if (mediaQuery.rows.length === 0) {
            throw "Movie not found in database";
        }

        let characterMediaID = mediaQuery.rows[0].id;

        let characterPng = req.body['png'];
        if (!characterPng) {
            throw "No png Specified";
        }

        let characterContext = req.body['context'];

        console.log(`(Adding) Name: ${characterName}; Media ID: ${characterMediaID}; Context: ${characterContext}; PNG: ${characterPng}`);

        const query = await userDB.query(
            'INSERT INTO characters("media_id", "name", "context", "png") VALUES ($1, $2, $3, $4)',
            [characterMediaID, characterName, characterContext, characterPng]
        );

        if (query.rowCount != 1) {
            throw "Element couldn't be Added";
        } else {
            res.status(200).json({message: "Element Added"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Create"});
    }
}

module.exports = addCharacter;
