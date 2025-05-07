const userDB = require("./db-data.js");

async function recommend(req, res) {
    try {
        let userID = req.body['user_id'];
        if (!userID) {
            throw "No User ID Provided";
        }
        const quer = await userDB.query(
            'SELECT media_id, media_info_id, library_rating FROM library WHERE user_id = $1',
            [userID]
        );
        console.log(quer.rows[0]);
        // TODO: Parte de enviar datos al modelo
        



        
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to recommend media"});
    }
}

module.exports = recommend;