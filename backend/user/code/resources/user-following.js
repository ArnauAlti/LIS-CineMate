const userDB = require("./db-data.js");

async function following(req, res) {
    try {
        let srcNick = req.body['srcNick'];
        if (!srcNick) {
            throw "No Nick Provided";
        } else {
            const query = await userDB.query(
                "SELECT * FROM following_query WHERE src_nick = ($1)",
                [srcNick]
            );
            if (query.rowCount < 1) {
                throw "No Data Fetched";
            } else {
                res.status(200).json({ message: "Following User", data: query.rows});
            }
        }
    } catch (error) {
        
    }
}

module.exports = following;