const userDB = require("./db.js");

async function getMedia(req, res) {
    try {
        const quer = await userDB.query('SELECT id, name, genres, type FROM media');
        const result = quer.rows;
        res.status(200).json({message: "Data Retrieved", data: result});
    } catch {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to retrieve media data"});
    }
}

module.exports = getMedia;