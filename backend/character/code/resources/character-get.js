const userDB = require("./db-data.js");

async function getCharacters(req, res) {
    try {
        const movieName = req.body['movie_name'];
        console.log("movie_name received:", movieName);

        if (!movieName) {
            const characterQuery = await userDB.query(
                'SELECT c.name, c.context, c.png, m.name AS movie_name FROM characters c, media m WHERE m.id = c.media_id',
            );

            console.log("Character query result:", characterQuery.rows);

            res.status(200).json({ characters: characterQuery.rows });
            
            return characterQuery.rows;
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
            'SELECT c.name, c.context, c.png, m.name AS movie_name FROM characters c, media m WHERE media_id = $1 AND m.id = c.media_id',
            [mediaId]
        );
        console.log("Character query result:", characterQuery.rows);

        res.status(200).json({ characters: characterQuery.rows });
        
        return characterQuery.rows;

    } catch (error) {
        console.error("Error in getCharacters:", error);
        res.status(500).json({ error: error, message: "Failed to fetch characters" });
    }
}

module.exports = getCharacters;
