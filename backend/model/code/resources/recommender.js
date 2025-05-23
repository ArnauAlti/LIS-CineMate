const userDB = require("./db.js");

async function recommender(req, res) {
    try {
        let userID = req.body['user_id'];
        if (!userID) {
            throw "No User ID Provided";
        }
        const quer = await userDB.query(
            'SELECT media_id, media_info_id, library_rating FROM library WHERE user_id = $1',
            userID
        );
        log.console(quer.rows[0]);
        // TODO: Parte de enviar datos al modelo
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to create a user"});
    }
}

module.exports = recommender;