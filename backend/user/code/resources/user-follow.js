const userDB = require("./db-data.js");

async function follow(req, res) {
    try {
        let srcMail = req.body['srcMail'];
        let dstMail = req.body['dstMail'];
        if (!srcMail || !dstMail) {
            throw "Missing Information";
        } else {
            const query = await userDB.query(
                'INSERT INTO following(src_mail, dst_mail) VALUES ($1, $2)',
                [srcMail, dstMail]
            );
            if (query.rowCount != 1) {
                throw "Something Unexpected Happened During Insert";
            } else {
                res.status(200).json({ message: "Following User", data: query.rows[0]});
            }
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to create a user"});
    }
}

module.exports = follow;