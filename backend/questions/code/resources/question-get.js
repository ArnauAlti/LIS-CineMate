const userDB = require("./db-data.js");

async function getQuestions(req, res) {
    try {
        const infoID = req.body['info_id'];
        if (!infoID) {
            throw "No Info ID Provided";
        }
        const query = await userDB.query(
            'SELECT * FROM questions WHERE info_id = $1',
            [infoID]
        );
        if (query.rowCount == 0) {
            throw "No Data Retrieved from This Query";
        }
        res.status(200).json({message: 'Data Retrieved', data: query.rows});
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Retrieve"});
    }
}

module.exports = getQuestions;