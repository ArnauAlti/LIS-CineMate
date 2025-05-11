const userDB = require("./db-data.js");

async function follow(req, res) {
    try {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        let srcMail = req.body['srcMail'];
        let dstMail = req.body['dstMail'];
        if (!srcMail || !dstMail) {
            throw "Missing Information";
        } else {
            const query = await userDB.query(
                'INSERT INTO following(src_mail, dst_mail) VALUES ($1, $2)',
                [srcMail, dstMail]
=======
        let srcNick = req.body['srcNick'];
        let dstNick = req.body['dstNick'];
=======
        let srcNick = req.body['srcMail'];
        let dstNick = req.body['dstMail'];
>>>>>>> 9caeb69 (Començar a fer el follow)
=======
        let srcMail = req.body['srcMail'];
        let dstMail = req.body['dstMail'];
>>>>>>> aca64d9 (Follow i unfollow fetes, falta comprovar funcionament)
        if (!srcNick || !dstNick) {
            throw "Missing Information";
        } else {
            const query = await userDB.query(
                'INSERT INTO following(src_mail, dst_mail) VALUES ($1, $2)',
<<<<<<< HEAD
                [srcNick, dstNick]
>>>>>>> 88bba61 (Query de folling + Implementación de Follow)
=======
                [srcMail, dstMail]
>>>>>>> aca64d9 (Follow i unfollow fetes, falta comprovar funcionament)
            );
            if (query.rowCount != 1) {
                throw "Something Unexpected Happened During Insert";
            } else {
                res.status(200).json({ message: "Following User", data: query.rows[0]});
            }
        }
    } catch (error) {
<<<<<<< HEAD
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to create a user"});
=======
        
>>>>>>> 88bba61 (Query de folling + Implementación de Follow)
    }
}

module.exports = follow;