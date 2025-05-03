const userDB = require("./db.js");

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
    console.log(id)
    const query = await userDB.query(
        'SELECT * FROM mediainfo WHERE media_id = $1 ORDER BY season ASC',
        [id]
    );
    console.log("Fetched " + query.rowCount + " values.");
    return query.rows;
}

function isValid(s) {
    return typeof s === 'string' && s.trim().length > 0;
}

async function filteredMedia(p, filters) {
    if (!p) {
        throw "Page argument is missing";
    }

    const conditions = [];
    const values = [];
    let idx = 1;

    if (isValid(filters.search)) {
        conditions.push(`LOWER(m.name) LIKE LOWER($${idx})`);
        values.push(`%${filters.search.trim()}%`);
        idx++;
        console.log(filters.search);
    }

    if (isValid(filters.genere)) {
        conditions.push(
            `EXISTS (SELECT 1 FROM jsonb_array_elements_text(m.genres) AS g WHERE LOWER(g.value) = LOWER($${idx}))`
        );
        values.push(filters.genere.trim());
        idx++;
    }

    if (isValid(filters.director)) {
        conditions.push(`LOWER(mi.director) LIKE LOWER($${idx})`);
        values.push(`%${filters.director.trim()}%`);
        idx++;
    }

    if (isValid(filters.actor)) {
        conditions.push(`LOWER(mi.cast) LIKE LOWER($${idx})`);
        values.push(`%${filters.actor.trim()}%`);
        idx++;
    }

    let filterClause = '';
    if (conditions.length > 0) {
        filterClause = ' WHERE ' + conditions.join(' AND ');
    }

    const mult = 10 * (p - 1);

    const select = `
        SELECT m.sec, mi.*
        FROM media m
        JOIN mediaINFO mi ON m.id = mi.media_id
        ${filterClause}
        ORDER BY m.sec ASC
        LIMIT 10 OFFSET ${mult}
    `;

    console.log("SQL:", select);
    console.log("Values:", values);

    const query = await userDB.query(select, values);
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
        } else if (nurl == "filtered") {
            const filters = req.body || {};
            data = await filteredMedia(p, filters);
            res.status(200).json({ message: "Good Request", data: data });
        } else {
            throw "Wrong Request";
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({message: "Bad Request"});
    }
}

module.exports = getMedia;