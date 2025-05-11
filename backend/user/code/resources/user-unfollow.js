const userDB = require("./db-data.js");

async function unfollow(req, res) {
    try {
        let srcMail = req.body['srcMail'];
        let dstMail = req.body['dstMail'];
        if (!srcMail || !dstMail) {
            throw "Missing Information";
        } else {
            const query = await userDB.query(
                'DELETE FROM following WHERE src_mail = $1 AND dst_mail = $2',
                [srcMail, dstMail]
            );
            if (query.rowCount != 1) {
                throw "Something Unexpected Happened During Delete";
            } else {
                res.status(200).json({ message: "User Unfollowed", data: query.rows[0]});
            }
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to create a user"});
    }
}

module.exports = unfollow;