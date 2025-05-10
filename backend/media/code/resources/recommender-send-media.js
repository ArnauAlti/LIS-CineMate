const userDB = require("./db-data.js");
const axios = require('axios');

async function sendMedia(req, res) {
    try {
        const query = await userDB.query(
            'SELECT * FROM recommender_query_media_genres LIMIT 100',
            []
        );
        if (query.rowCount == 0) {
            console.log("No media fetched");
        } else {
            let media = query.rows;
            let fields = Object.keys(media[0]);
            let replacer = function(key, value) {
                return value === null ? '' : value
            }
            let csv = media.map(function(row) {
                return fields.map(function(fieldName) {
                    return JSON.stringify(row[fieldName], replacer)
                }).join(',')
            });
            csv.unshift(fields.join(','));
            csv = csv.join('\r\n');
            // console.log(csv);
            const url = "http://host.docker.internal:12000/load-dataset/";

            const payload = {
                data: csv
            };

            const response = await axios.post(url, payload);
            if (response.data.ok === true) {
            res.status(200).json({ data: response.data });
            } else {
            throw "The dataset was not loaded";
            }
        }
    } catch (error) {
        res.status(500).json({ error: error});
    }

}

module.exports = sendMedia;