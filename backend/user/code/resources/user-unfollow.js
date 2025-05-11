const userDB = require("./db-data.js");

async function unfollow(req, res) {
    try {
        let srcMail = req.body['srcMail'];
        let dstMail = req.body['dstMail'];
<<<<<<< HEAD
<<<<<<< HEAD
        if (!srcMail || !dstMail) {
=======
        if (!srcNick || !dstNick) {
>>>>>>> 83c318d (Toyota Corolla - Backend Follow and Unfollow)
=======
        if (!srcMail || !dstMail) {
>>>>>>> 28f6e20 (Funciona follow y unfollow)
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
<<<<<<< HEAD
<<<<<<< HEAD
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to create a user"});
=======
        
>>>>>>> 83c318d (Toyota Corolla - Backend Follow and Unfollow)
=======
        console.log(error);
        res.status(500).json({ error: error, message: "An error ocurred trying to create a user"});
>>>>>>> 28f6e20 (Funciona follow y unfollow)
    }
}

module.exports = unfollow;