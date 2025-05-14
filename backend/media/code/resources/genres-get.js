const userDB = require("./db-data.js");

async function getGenres(req, res) {
    try {
        const query = await userDB.query(
            'SELECT * FROM genres'
        )
        if (query.rowCount == 0) {
            throw 'No Genres Found';
        }
        else {
            res.status(200).json({message: "Returned Genres", data: query.rows});
        }
    } catch {
        console.log(error);
        res.status(500).jsom({error: error, message: "Failed to Get Genres"});
    }
}

module.exports = getGenres;