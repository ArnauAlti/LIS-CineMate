const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { promisify } = require('util');
const writeFile = promisify(fs.writeFile);

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


async function processGenres(req, res) {
    const [movieGenres, tvGenres] = await Promise.all([
        fetchTmdbData("genre/movie/list"),
        fetchTmdbData("genre/tv/list")
    ]);
    console.log(movieGenres, tvGenres);
    if (!movieGenres || !tvGenres) {
      res.status(500).json({ movie: movieGenres, tv: tvGenres, message: "Request Failed"});
    }
    const client = await Pool.connect();
    const query = 'INSERT INTO genres '
    res.status(200).json({ movie: movieGenres, tv: tvGenres, message: "Request Completed"});
};

module.exports = processGenres;