const userDB = require("./db-data.js");
const authDB = require("./db-auth.js");

async function modifyCharacter(req, res) {
    try {
        let characterName = req.body['name'];
        if (!characterName) {
            throw "No name Specifcied";
        }
        const movieName = req.body['movie_name'];
        console.log("movie_name received:", movieName);

        if (!movieName) {
            throw "No movie name specified";
        }

        const mediaQuery = await userDB.query(
            'SELECT id FROM media WHERE name = $1',
            [movieName]
        );
        console.log("Media query result:", mediaQuery.rows);

        if (mediaQuery.rows.length === 0) {
            throw "Movie not found in database";
        }

        const characterMediaID = mediaQuery.rows[0].id;

        let characterPng = req.body['png'];
        if (!characterPng) {
            throw "No png Specified"
        }
        let characterContext = req.body['context'];
        console.log("(Modify) Name: " + characterName + "; Media ID: " + characterMediaID + "; Context: " + characterContext + " png:" + characterPng);    
        const query = await userDB.query(
            'UPDATE characters SET context = $3, png = $4 WHERE name = $1 AND media_id = $2',
            [characterName, characterMediaID, characterContext, characterPng]
        );
        if (query.rowCount != 1) {
            if (query.rowCount == 0) {
                throw "No Library Element Found";
            } else {
                throw "Unknown Error";
            }
        }
        else {
            res.status(200).json({message: "Element Modified"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Modify"});
    }
}

module.exports = modifyCharacter;