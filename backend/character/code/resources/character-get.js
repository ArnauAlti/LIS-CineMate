const userDB = require("./db-data.js");

async function getCharacters(req, res) {
    try {
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

        const mediaId = mediaQuery.rows[0].id;
        console.log("Media ID:", mediaId);

        const characterQuery = await userDB.query(
            'SELECT name, context, png, media_id FROM characters WHERE media_id = $1',
            [mediaId]
        );
        console.log("Character query result:", characterQuery.rows);

        res.status(200).json({
            movie_name: movieName,
            characters: characterQuery.rows
        });
        
        // return characterQuery.rows;
        return {
            movie_name: movieName,
            characters: characterQuery.rows
        };
          

    } catch (error) {
        console.error("Error in getCharacters:", error);
        res.status(500).json({ error: error, message: "Failed to fetch characters" });
    }
}

module.exports = getCharacters;
