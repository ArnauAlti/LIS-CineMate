const userDB = require("./db-data.js");
const axios = require('axios');

async function recommend(req, res) {
    try {
        // Check if the request body is empty
        if (!req.body)  return res.status(400).json({ error: "Missing request body", message: "Request body must contain user_id" });

        const user_mail = req.body['user_mail'];
        const genre_filter = req.body.genre_filter || [];

        // Check if user_mail is provided
        if (!user_mail) return res.status(400).json({ error: "Missing user_id", message: "user_id is required in request body" });
     
        const query = await userDB.query(
            'SELECT media_id, rating FROM library WHERE user_mail = $1 AND rating IS NOT NULL',
            [user_mail]
        );

        if (query.rowCount == 0) {
            console.log("No media fetched");
            return res.status(200).json({ ok: true, recommendations: [], message: "No rated media found for this user" });
        }
        
        let url = "http://host.docker.internal:12000/recommend/star-rating";
        let message = "Recommendations generated successfully"; // Cambiado de const a let
        const base_payload = {
            ratings: query.rows.map(item => [item.media_id, item.rating]),
            top_n: req.body['top_n'] || 5, // Opcional
            genre_diversity: req.body['genre_diversity'] || false // Opcional
        };
        let payload = base_payload;

        // if genre_filter is provided, use the star-rating-genre endpoint
        if (Array.isArray(genre_filter) && genre_filter.length > 0) {

            console.log("Genre names: ", genre_filter);
            
            url = "http://host.docker.internal:12000/recommend/star-rating-genre";
            payload = {
                ...base_payload,
                genre_filter: genre_filter
            };
            message = `Recommendations filtered by genres: ${genre_filter.join(', ')} generated successfully`;
        }

        // console.log("Payload: ", payload);
        
        const response = await axios.post(url, payload);
        
        if(response.data.ok !== true){
            throw new Error(response.data.message || "Error in recommendation model");
        }

        const recommender_ids = response.data.recommendations;

        console.log("Recommendation model response: ", response.data);
        
        let list_info = [];

        if(recommender_ids.length > 0 ){
            const placeholders = recommender_ids.map((_,i)=>`$${i+1}`).join(',');

            const InfoQuery = await userDB.query(
                `SELECT * FROM media WHERE id IN (${placeholders})`,
                recommender_ids
            );

            list_info = InfoQuery.rows;
        }


        res.status(200).json({
            ok: true,
            recommendations: list_info,
            top_genres: response.data.top_genres,
            message: response.data.message
        } );

    } catch (error) {
        console.log(error);
        res.status(500).json({ ok:false, error: error.message, message: "An error ocurred trying to recommend media"});
    }
}

module.exports = recommend;