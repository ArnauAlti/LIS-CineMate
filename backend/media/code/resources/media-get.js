
const userDB = require("./db-data.js");
const authDB = require("./db-auth.js");

async function all(p, type) {
    if (!p) {
        throw "An argument is missing";
    }
    let filterType = ' ';
    if (type) {
        filterType = " WHERE type = '" + type + "'";
    }
    console.log("p: ", p);
    console.log("type: ", type);
    console.log(filterType)
    let mult = (10 * (p - 1));
    let select = ' SELECT * FROM mediaQuery ' + filterType + ' ORDER BY sec ASC LIMIT 10 OFFSET $1'
    const query = await userDB.query(
        select,
        [mult]
    );
    console.log("Fetched " + query.rowCount + " values.");
    return query.rows;
}

async function details(id) {
    const query = await userDB.query(
        'SELECT * FROM mediainfo WHERE media_id = $1 ORDER BY season ASC',
        [id]
    );
    console.log("Fetched " + query.rowCount + " values.");
    return query.rows;
}

async function getMedia(req, res) {
    try {
        const p = req.query.p;
        const id = req.query.id;
        const type = req.query.type;
        let nurl = String(req.url).split("?")[0].split("/")[2];
        let data;
        if (nurl == "all") {
            data = await all(p, type);
            res.status(200).json({message: "Good Request", data: data});
        } else if (nurl == "details") {
            data = await details(id);
            res.status(200).json({message: "Good Request", data: data});
        } else {
            throw "Wrong Request";
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({message: "Bad Request"});
    }
}

module.exports = getMedia;