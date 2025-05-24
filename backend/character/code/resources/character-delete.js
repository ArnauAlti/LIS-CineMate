const userDB = require("./db-data.js");
const authDB = require("./db-auth.js");

async function deleteCharacter(req, res) {
    try {
        let characterName = req.body['name'];
        if (!characterName) {
            throw "No User Specifcied";
        }
        let characterMediaID = req.body['media_id'];
        if (!characterMediaID) {
            throw "No Media Specified";
        }
        console.log("(Delete) Name: " + characterName + "; Media ID: " + characterMediaID);
        const query = await userDB.query(
            'DELETE FROM characters WHERE name = $1 AND media_id = $2',
            [characterName, characterMediaID]
        );
        if (query.rowCount != 1) {
            if (query.rowCount == 0) {
                throw "No Library Element Found";
            } else {
                throw "Unknown Error";
            }
        }
        else {
            res.status(200).json({message: "Element Deleted"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Delete"});
    }
}

module.exports = deleteCharacter;