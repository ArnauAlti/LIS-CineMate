const axios = require('axios');
const fs = require('fs');
const { promisify } = require('util');
const writeFile = promisify(fs.writeFile);
const userDB = require("./db-data.js");
const authDB = require("./db-auth.js");
const { fail } = require('assert');
const lock_key = require('./data/lock.json');
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
      movie_db: isMovie ? ('movie/' + content.id) : ('tv/' + content.id),
      name: isMovie ? content.title : content.name,
      genres: "[" + details.genres.map(g => g.id).join(',') + "]",
      type: isMovie ? 'movie' : 'show',
      description: (content.overview || '').replace(/\n/g, ' ').replace(/"/g, "'"),
      png: content.poster_path ? `https://image.tmdb.org/t/p/w500${content.poster_path}` : null,
      release_date: content.release_date,
      movie_db_rating: details.vote_average,
      movie_db_votes: details.vote_count
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
         movie_db: isMovie ? ('movie/' + content.id) : ('tv/' + content.id),
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
         insert['movie_db'] = isMovie ? ('movie/' + content.id) : ('tv/' + content.id);
         insert['synopsis'] = (seasonDetails.overview || '').replace(/\n/g, ' ');
         insert['plot'] = null;
         insert['name'] = season.name;
         insert['season'] = season.season_number;
         insert['episodes'] = season.episode_count;
         insert['director'] = director;
         insert['cast'] = cast;
         insert['release'] = isMovie ? details.release_date : season.air_date;
         seasonsData.push(insert);
      }
      return seasonsData;
   }
}

async function setMovies() {
   console.log("------- Setting Media -------")
   const client = await userDB.connect();
   try {
      let va1 = await authDB.query("SELECT quantity FROM data WHERE type = 'movies_db_start'");
      let va2 = await authDB.query("SELECT quantity FROM data WHERE type = 'movies_db_end'");
      let va3 = await authDB.query("SELECT quantity FROM data WHERE type = 'movies_db_jumps'");
      //    let va4 = await authDB.query("SELECT quantity FROM data WHERE type = 'shows_db_start'");
      //    let va5 = await authDB.query("SELECT quantity FROM data WHERE type = 'shows_db_end'");
      //    let va6 = await authDB.query("SELECT quantity FROM data WHERE type = 'shows_db_jumps'");
      
      let movies_start = va1.rows[0]['quantity'];
      let movies_end = va2.rows[0]['quantity'];
      let movies_jumps = va3.rows[0]['quantity'];
      //    let shows_start = va4.rows[0]['quantity'];
      //    let shows_end = va5.rows[0]['quantity'];
      //    let shows_jumps = va6.rows[0]['quantity'];
      
      
      let mediaData = [];
      let mediaInfoData = [];
      
      // Primero Peliculas
      console.log("(Movies) Movies Starting Page: ", movies_start);
      console.log("(Movies) Movies Last Page: ", movies_end);
      console.log("(Movies) Movies Jumps: ", movies_jumps);
      console.log("(Movies) Starting to Fetch Movies Data");
      let check = true;
      for (movies_start; movies_start <= movies_end; movies_start++) {
         console.log("(Movies) Fetching page: " + movies_start);
         const [movies] = await Promise.all([
            fetchTmdbData("movie/popular", { page: movies_start }),
         ]);
         mediaData.push(...await Promise.all(movies.results.map(m => processMediaItem(m, true))));
         mediaInfoData.push(...(await Promise.all(movies.results.map(m => processMediaInfo(m, true)))).flat());
         if (check) {
            if (movies['total_pages'] < movies_end) {
               movies_end = movies['total_pages'];
               const response = await authDB.query("UPDATE data SET bool = false WHERE type = 'movies_db_active'");
               if (response.rowCount == 0) {
                  console("(Shows) Could not deactivate shows fetching");
               }
            }
            check = false;
         }
      }
      console.log("(Movies) Movies Data Fetched");
      console.log("(Movies) New Start: " + movies_start);
      console.log("(Movies) New Amount: " + (movies_end + movies_jumps));
      movies_end += movies_jumps;
      const answer1 = await authDB.query("UPDATE data SET quantity = $1 WHERE type = 'movies_db_start'", [movies_start]);
      const answer2 = await authDB.query("UPDATE data SET quantity = $1 WHERE type = 'movies_db_end'", [movies_end]);
      console.log("(Movies) " + answer1.rowCount + answer2.rowCount);
      //    console.log("------ Shows ------");
      //    console.log("Shows Starting Page: ", shows_start);
      //    console.log("Shows Last Page: ", shows_end);
      //    console.log("Shows Jumps: ", shows_jumps);
      //    console.log("Starting to Fetch Shows Data");
      //    check = true;
      //    for (shows_start; shows_start <= shows_end; shows_start++) {
      //       console.log("Fetching page: " + shows_start);
      //       const [shows] = await Promise.all([
      //          fetchTmdbData("discover/tv", { page: shows_start, sort_by: "popularity.desc", without_genres: "10767, 10763, 10764, 10766" }),
      //       ]);
      //       // console.log(shows);
      //       mediaData.push(...await Promise.all(shows.results.map(s => processMediaItem(s, false))));
      //       mediaInfoData.push(...(await Promise.all(shows.results.map(s => processMediaInfo(s, false)))).flat());
      //       if (check) {
      //          shows_end = shows['total_pages'] < shows_end ? shows['total_pages'] : shows_end;
      //          check = false;
      //       }
      //    }
      //    console.log("Shows Data Fetched");
      //    console.log("New Start: " + shows_start);
      //    console.log("New Amount: " + (shows_end + shows_jumps));
      //    shows_end += shows_jumps;
      //    console.log("--------------------");
      
      const uniqueMediaData = [...await new Map(mediaData.map(m => [`${m.id}_${m.type}`, m])).values()];
      const uniqueMediaInfo = [...await new Map(mediaInfoData.map(m => [JSON.stringify(m), m])).values()];
      
      const queryMedia = 'INSERT INTO media("name", "active", "genres", "type", "movie_db", "movie_use_rating", "movie_db_rating", "movie_db_count", "description", "png") ' +
      'VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) ON CONFLICT (movie_db) DO NOTHING';
      const queryInfo = 'INSERT INTO info("movie_db", "synopsis", "plot", "season", "episodes", "director", "cast", "release", "vote_rating", "vote_count") ' +
      'VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) ON CONFLICT (id) DO NOTHING';
      let failedMedia = 0;
      let addedMedia = 0;
      for (const element of uniqueMediaData) {
         const result = await client.query(
            queryMedia,
            [element['name'], true, element['genres'], element['type'], element['movie_db'], true, element['movie_db_rating'], element['movie_db_votes'], element['description'], element['png']]
         );
         if (result.rowCount == 0) {
            console.log("Data: " + element['name'], " / " + element['movie_db'] + " / " + element['type'] + " -> Failed");
            failedMedia++;
         } else {
            console.log("Data: " + element['name'], " / " + element['movie_db'] + " / " + element['type'] + " -> Success");
            addedMedia++;
         }
      }
      let failedInfo = 0;
      let addedInfo = 0;

      for (const element of uniqueMediaInfo) {
         const result = await client.query(
            queryInfo,
            [element['movie_db'], element['synopsis'], element['plot'], element['season'], element['episodes'], element['director'], element['cast'], element['release'], 0, 0]
         );
         if (result.rowCount == 0) {
            console.log("Info: " + element['movie_db'], " / " + element['season'], " -> Failed");
            failedInfo++;
         } else {
            console.log("Info: " + element['movie_db'], " / " + element['season'], " -> Success");
            addedInfo++;
         }
      }
   } catch (error) {
      console.log("Error trying to fetch Movie Data");
      console.log(error);
   } finally {
      client.release();
   }
   
}

module.exports = setMovies;