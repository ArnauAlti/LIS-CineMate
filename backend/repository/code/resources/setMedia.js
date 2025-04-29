const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { promisify } = require('util');
const writeFile = promisify(fs.writeFile);
const userDB = require("./db.js");
const { fail } = require('assert');
const lock_key = require('./data/lock.json');
const patata = require('./data/media.json');
const { release } = require('os');

const API_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZDFkNzYyYzQ3YTI5MjA0MDhhMDE3ZjkzZWMyOTU5YSIsIm5iZiI6MTc0NDgyNzk5Mi4yMywic3ViIjoiNjdmZmY2NTg2MWIxYzRiYjMyOTliZDI0Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.hiW-YBlejzl6mh1srS3OfUeNLfBdAaQjTck9bQrzYgA";
const BASE_URL = "https://api.themoviedb.org/3";
const DATA_DIR = "data";

let checks = 0;

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

async function processMediaItem(content, isMovie) {
   const mediaType = isMovie ? 'movie' : 'tv';
   const details = await fetchTmdbData(`${mediaType}/${content.id}`);
   return {
      id: content.id,
      movie_db: isMovie ? ('movie-' + content.id) : ('tv-' + content.id),
      name: isMovie ? content.title : content.name,
      genres: "[" + details.genres.map(g => g.id).join(',') + "]",
      type: isMovie ? 'movie' : 'show',
      description: (content.overview || '').replace(/\n/g, ' ').replace(/"/g, "'"),
      png: content.poster_path ? `https://image.tmdb.org/t/p/w500${content.poster_path}` : null,
      release_date: content.release_date,
      web_rating: content.vote_average
   };
}

async function processMediaInfo(content, isMovie) {
   const mediaType = isMovie ? 'movie' : 'tv';
   const [details, credits] = await Promise.all([
      fetchTmdbData(`${mediaType}/${content.id}`),
      fetchTmdbData(`${mediaType}/${content.id}/credits`)
   ]);

   const director = credits.crew.find(c => c.job === 'Director')?.name || null;
   const cast = credits.cast.slice(0, 5).map(a => a.name).join(', ');
   if (isMovie) {
      return [{
               movie_db: isMovie ? ('movie-' + content.id) : ('tv-' + content.id),
               synopsis: (details.overview || '').replace(/\n/g, ' '),
               plot: null,
               name: content.name,
               season: null,
               episodes: 1,
               'director': director,
               'cast': cast,
               'release': details.release_date,
            }];
   } else {
      let seasonsData = []
      for (const season of details.seasons) {
         const seasonDetails = await fetchTmdbData(`tv/${content.id}/season/${season.season_number}`);
         const insert = {};
         insert['movie_db'] = isMovie ? ('movie-' + content.id) : ('tv-' + content.id);
         insert['synopsis'] = (seasonDetails.overview || '').replace(/\n/g, ' ');
         insert['plot'] = null;
         insert['name'] = season.name;
         insert['season'] = season.season_number;
         insert['episodes'] = season.episode_count;
         insert['director'] = director;
         insert['cast'] = cast;
         insert['release'] = seasonDetails.first_air_date;
         seasonsData.push(insert);
      }
      // console.log("---------------------------");
      console.log(checks);
      checks++;
      // console.log(seasonsData);
      return seasonsData;

   }
}

async function setMedia(req, res) {
   const client = await userDB.connect();
   try {
      lock_key['lock'] = true;
   
      let mediaData = [];
      let mediaInfoData = [];
      
      // Primero Peliculas
      let start = patata['movies_start'];
      let amount = patata['movies_max_pages'];
      let jumps = 0;
      let check = true;
      console.log("------ Movies ------");
      console.log("Movies Starting Page: ", start);
      console.log("Movies Last Page: ", amount);
      console.log("Starting to Fetch Movies Data");
      for (start; start < amount; start++) {
         jumps++;
         const [movies] = await Promise.all([
            fetchTmdbData("movie/popular", { page: start }),
         ]);
         mediaData.push(...await Promise.all(movies.results.map(m => processMediaItem(m, true))));
         mediaInfoData.push(...(await Promise.all(movies.results.map(m => processMediaInfo(m, true)))).flat());
         if (check) {
            amount = movies['total_pages'] < amount ? movies['total_pages'] : amount;
            check = false;
         }
      }
      console.log("Movies Data Fetched");
      console.log("New Start: " + start);
      console.log("New Amount: " + (amount + jumps));
      patata['movies_start'] = start;
      patata['movies_max_pages'] = amount + jumps;
      console.log("--------------------");

      start = patata['shows_start'];
      amount = patata['shows_max_pages'];
      jumps = 0;
      check = true;
      console.log("------ Shows ------");
      console.log("Shows Starting Page: ", start);
      console.log("Shows Last Page: ", amount);
      console.log("Starting to Fetch Shows Data");
      for (start; start < amount; start++) {
         jumps++;
         const [shows] = await Promise.all([
            fetchTmdbData("tv/popular", { page: start }),
         ]);
         // console.log(shows);
         mediaData.push(...await Promise.all(shows.results.map(s => processMediaItem(s, false))));
         mediaInfoData.push(...(await Promise.all(shows.results.map(s => processMediaInfo(s, false)))).flat());
         if (check) {
            amount = shows['total_pages'] < amount ? shows['total_pages'] : amount;
            check = false;
         }
      }
      console.log("Shows Data Fetched");
      console.log("New Start: " + start);
      console.log("New Amount: " + (amount + jumps));
      patata['shows_start'] = start;
      patata['shows_max_pages'] = amount + jumps;
      console.log("--------------------");
      console.log(mediaData.length);
      console.log(mediaInfoData.length);
      const uniqueMediaData = [...await new Map(mediaData.map(m => [`${m.id}_${m.type}`, m])).values()];
      const uniqueMediaInfo = [...await new Map(mediaInfoData.map(m => [JSON.stringify(m), m])).values()];
      // console.log(uniqueMediaData);
      // console.log(uniqueMediaInfo);
      console.log(uniqueMediaData.length);
      console.log(uniqueMediaInfo.length);
      
      const queryMedia = 'INSERT INTO media("name", "genres", "type", "movie_db", "rating", "description", "png") ' +
         'VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (movie_db) DO NOTHING';
      const queryInfo = 'INSERT INTO info("movie_db", "synopsis", "plot", "season", "episodes", "director", "cast", "release") ' +
         'VALUES ($1, $2, $3, $4, $5, $6, $7, $8) ON CONFLICT (id) DO NOTHING';
      let failedMedia = 0;
      let addedMedia = 0;
      for (const element of uniqueMediaData) {
         const result = await client.query(
            queryMedia,
            [element['name'], element['genres'], element['type'], element['movie_db'], element['web_rating'], element['description'], element['png']]
         );
         if (result.rowCount == 0) {
            console.log(element['name'], " / " + element['id'], " -> Failed");
            failedMedia++;
         } else {
            console.log(element['name'], " / " + element['id'], " -> Success");
            addedMedia++;
         }
      }
      let failedInfo = 0;
      let addedInfo = 0;
      // for (const element of uniqueMediaInfo) {
      //    console.log(element);
      // }
      for (const element of uniqueMediaInfo) {
         console.log(element['movie_db']);
         console.log(element['synopsis']);
         console.log(element['plot']);
         console.log(element['season']);
         console.log(element['episodes']);
         console.log(element['director']);
         console.log(element['cast']);
         console.log(element['release']);
         const result = await client.query(
            queryInfo,
            [element['movie_db'], element['synopsis'], element['plot'], element['season'], element['episodes'], element['director'], element['cast'], element['release']]
         );
         if (result.rowCount == 0) {
            // console.log(element['name'], " / " + element['id'], " -> Failed");
            failedInfo++;
         } else {
            // console.log(element['name'], " / " + element['id'], " -> Success");
            addedInfo++;
         }
      }
      res.status(200).json({
         message: "patata", 
         media: mediaData, 
         mediaInfoData: mediaInfoData, 
         failed_media: failedMedia, 
         inserted_media: addedMedia, 
         failed_info: failedInfo, 
         inserted_info: addedInfo
      });
   } catch (error) {
      console.log(error);
      res.status(500).json({error: error, message: "Something Went Horribly Wrong"});
   } finally {
      lock_key['lock'] = false;
      client.release();
   }
   
}

module.exports = setMedia;