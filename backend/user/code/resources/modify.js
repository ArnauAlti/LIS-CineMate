const userDB = require("./db.js");

async function modifyUser(params) {
    let userMail = req.body['user_mail'];
    let userNick = req.body['user_nick'];
    if (!userMail && !userNick) {
        
    }
}

module.exports = modifyUser;