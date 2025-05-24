
const userDB = require("../resources/db-data.js");
const authDB = require("../resources/db-auth.js");

async function createMedia(req, res) {
    try {
        let name = req.body['name'];
        if (!name) {
            throw "No Title Specifcied";
        }
        let type = req.body['type'];
        if (!type) {
            throw "No Type Specified";
        }
        let rating = req.body['rating'];
        if (!rating) {
            throw "No Rating Specified"
        }
        let description = req.body['description'];
        if (!description) {
            throw "No Description Specified"
        }
        let png = req.body['png'];
        if (!png) {
            throw "No Photo Specified"
        }
        let genres = req.body['genres'];
        if (!genres) {
            throw "No rating Specified"
        }
        console.log("(Adding) Name: " + name + "; Type: " + type + "; Rating: " + rating + " Description: " + description + " Png: " + png + " genres: "+ genres);
        const query = await userDB.query(
            'INSERT INTO media("name", "genres","type", "rating", "description", "png") VALUES ($1, $2, $3, $4, $5, $6)',
            [name, genres, type, rating, description, png]
        )
        if (query.rowCount != 1) {
            throw "Element couldn't be Added";
        }
        else {
            res.status(200).json({message: "Element Added"});
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({error: error, message: "Failed to Create"});
    }
}

module.exports = createMedia;