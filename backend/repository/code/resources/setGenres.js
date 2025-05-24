const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { promisify } = require('util');
const writeFile = promisify(fs.writeFile);
const userDB = require("./db.js");
const { fail } = require('assert');
const lock_key = require('./data/lock.json');

const API_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZDFkNzYyYzQ3YTI5MjA0MDhhMDE3ZjkzZWMyOTU5YSIsIm5iZiI6MTc0NDgyNzk5Mi4yMywic3ViIjoiNjdmZmY2NTg2MWIxYzRiYjMyOTliZDI0Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.hiW-YBlejzl6mh1srS3OfUeNLfBdAaQjTck9bQrzYgA";
const BASE_URL = "https://api.themoviedb.org/3";
const DATA_DIR = "data";

const tmdb = axios.create({
   baseURL: BASE_URL,
   headers: {
      "Authorization": `Bearer ${API_TOKEN}`,
      "accept": "application/json"
   }
});

async function fetchTmdbData(endpoint, params = {}) {
   try {
      const response = await tmdb.get(endpoint, { params });
      return response.data;
   } catch (error) {
      console.error(`Error fetching ${endpoint}:`, error.message);
      throw error;
   }
}

async function setGenres(req, res) {
   // Recuperamos los datos
   const [movieGenres, tvGenres] = await Promise.all([
      fetchTmdbData("genre/movie/list"),
      fetchTmdbData("genre/tv/list")
   ]);
   if (!movieGenres || !tvGenres) {
      res.status(500).json({ movie: movieGenres.genres, tv: tvGenres.genres, message: "Request failed due to one or more sets being null"});
   }
   else {
      const allGenres = [...movieGenres.genres, ...tvGenres.genres];
      const uniqueGenres = [...new Map(allGenres.map(g => [g.id, g])).values()];
      console.log(uniqueGenres);
      const client = await userDB.connect();
      try {
         const quer = 'INSERT INTO genres (imdb, name) VALUES ($1, $2) ON CONFLICT (moviedb) DO NOTHING';
         let failed = 0;
         for (const element of uniqueGenres) {
            const value1 = element.id;
            const value2 = element.name;
            const result = await client.query(
               quer,
               [value1, value2]
            );
            if (result.rowCount == 0) {
               failed = failed + 1;
               console.log("Insert for ", value2, " Failed.");
            }
            else {
               console.log(value2, " Inserted in Database");
            }
         }
         console.log("Total-failed = ", failed);
         res.status(200).json({"message": "Request Processed Succesfully", "failed-inserts": failed});
      } catch {
         res.status(500).json({error: error, message: "Request Failed"});
      } finally {
         client.release();
      }
   }
};

module.exports = setGenres;