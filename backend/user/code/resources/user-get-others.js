const userDB = require("./db-data.js");

async function getUsers(req, res) {
    try {
        const userMail = req.body['user_mail'];
        console.log("movie_name received:", userMail);

        if (!movieName) {
            throw "No user mail specified";
        }

        const UserQuery = await userDB.query(
            'SELECT id, username, profile_picture FROM users WHERE admin=false'
        );
        console.log("User query result:", UserQuery.rows);

        res.status(200).json({ users: UserQuery.rows });
        
        return UserQuery.rows;

    } catch (error) {
        console.error("Error in getCharacters:", error);
        res.status(500).json({ error: error, message: "Failed to fetch characters" });
    }
}

module.exports = getUsers;