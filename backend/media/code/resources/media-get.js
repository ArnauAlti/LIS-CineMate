
const userDB = require("./db-data.js");
const authDB = require("./db-auth.js");

async function all(p, type, search) {
    if (!p) {
        throw "An argument is missing";
    }
    let filter = false;
    let filterCount = 0;
    let filterConcat = "WHERE ";
    let filters = []
    if (type) {
        filter = true;
        filterCount++;
        filters.push("type = '" + type + "' ");
    }
    if (search) {
        filter = true;
        filterCount++;
        filters.push("name = '" + search + "' ");
    }
    for (let index = 0; index < filterCount; index++) {
        if (index == 0) {
            filterConcat = filterConcat + filters[index];
        } else {
            filterConcat = filterConcat + "AND " + filters[index];
        }
    }
    console.log("p: ", p);
    console.log("type: ", type);
    let mult = (10 * (p - 1));
    let select = 'SELECT * FROM view_media ' + (filter ? filterConcat : "") + 'ORDER BY sec ASC LIMIT 10 OFFSET $1';
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

async function search(p, type, search) {
    
}

async function getMedia(req, res) {
    try {
        const p = req.query.p;
        const id = req.query.id;
        const type = req.query.type;
        const search = req.query.search;
        let nurl = String(req.url).split("?")[0].split("/")[2];
        let data;
        if (nurl == "all") {
            data = await all(p, type, search);
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