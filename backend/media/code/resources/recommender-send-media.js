const userDB = require("./db-data.js");

async function checkDB() {
    try {
        console.log('what')
        const client = await userDB.connect();
        await client.query('SELECT * FROM media_genres');
        client.release();
        return true;
    } catch (error) {
        console.log('Problem with database');
        return false;
    }
}

async function sendGenres() {
    let test_var = await checkDB().valueOf();
    console.log(test_var)
    if (test_var) {
        console.log("Attempting to download genre data from database.");
        let quer = await userDB.query(
            'SELECT * FROM media_genres'
        );
        let result = quer.rows;
        console.log(result);
        console.log(result.map( item => item.genres));
        // TODO: Enviar los datos al modelo
    } else {
    }
}

module.exports = sendGenres;