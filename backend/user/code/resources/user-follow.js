const userDB = require("./db-data.js");

async function follow(req, res) {
    try {
        let srcNick = req.body['srcNick'];
        let dstNick = req.body['dstNick'];
        if (!srcNick || !dstNick) {
            throw "Missing Information";
        } else {
            const query = await userDB.query(
                'INSERT INTO following(src_nick, dst_nick) VALUES ($1, $2)',
                [srcNick, dstNick]
            );
            if (query.rowCount != 1) {
                throw "Something Unexpected Happened During Insert";
            } else {
                res.status(200).json({ message: "Following User", data: query.rows[0]});
            }
        }
    } catch (error) {
        
    }
}

module.exports = follow;