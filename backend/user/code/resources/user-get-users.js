const userDB = require("./db-data.js");

async function getFollows(userMail) {
    try {
        let srcNick = req.body['srcNick'];
        if (!srcNick) {
            throw "No Nick Provided";
        } else {
            const query = await userDB.query(
                "SELECT * FROM following_query WHERE src_nick = ($1)",
                [srcNick]
            );
            if (query.rowCount < 1) {
                throw "No Data Fetched";
            } else {
                res.status(200).json({ message: "Data Fetched", data: query.rows});
            }
        }
    } catch (error) {
        res.status(500).json({ message: "Bad Request", error: error });
    }
}

async function getUserBySearch(search, userMail) {
    let filter = false;
    let filterCount = 0;
    let filterConcat = "AND ";
    let filters = [];

    if (search) {
        filter = true;
        filterCount++;
        filters.push(`nick ILIKE '%${search}%'`);
    }

    for (let index = 0; index < filterCount; index++) {
        if (index === 0) {
            filterConcat += filters[index];
        } else {
            filterConcat += " AND " + filters[index];
        }
    }

    const queryText = 'SELECT nick, png FROM users WHERE admin = false AND mail <> ($1) ' + (filter ? filterConcat + ' ' : '') + 'LIMIT 20';

    console.log(queryText);

    const query = await userDB.query(queryText, [userMail]);
    return query.rows;
}

async function getUsers(req, res) {
    try {
        const userMail = req.query.user_mail;
        const search = req.query.search;

        let nurl = String(req.url).split("?")[0].split("/")[2];
        console.log(nurl);

        let data;

        if (nurl === "search") {
            data = await getUserBySearch(search, userMail);
            res.status(200).json({ message: "Good Request", data: data });
        } else if (nurl === "follows") {
            data = await getFollows(userMail);
            res.status(200).json({ message: "Good Request", data: data });
        } else {
            throw "Wrong Request";
        }
    } catch (error) {
        console.error("Error in getUsers:", error);
        res.status(500).json({ message: "Bad Request", error: error });
    }
}

module.exports = getUsers;
