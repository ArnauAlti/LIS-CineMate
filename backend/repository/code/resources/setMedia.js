const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { promisify } = require('util');
const writeFile = promisify(fs.writeFile);
const userDB = require("./db.js");
const { fail } = require('assert');
const lock_key = require('./data/lock.json');
const patata = require('./data/media.json');

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

async function processMediaItem(content, isMovie) {
   const mediaType = isMovie ? 'movie' : 'tv';
   const details = await fetchTmdbData(`${mediaType}/${content.id}`);
   
   return {
      id: content.id,
      movieDB: isMovie ? ('movie-' + content.id) : ('tv-' + content.id),
      name: isMovie ? content.title : content.name,
      genres: "[" + details.genres.map(g => g.id).join(',') + "]",
      type: isMovie ? 'movie' : 'show',
      description: (content.overview || '').replace(/\n/g, ' ').replace(/"/g, "'"),
      png: content.poster_path ? `https://image.tmdb.org/t/p/w500${content.poster_path}` : null
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
   console.log(details);
   if (isMovie) {
      return {
               id: content.movieDB,
               synopsis: (details.overview || '').replace(/\n/g, ' '),
               season: null,
               episodes: null,
               rating: 0,
               'director': director,
               'cast': cast,
               release: content.release_date
            };
   } else {
      return true;
   }
   // if (isMovie) {
   //    return {
   //       id: content.movieDB,
   //       synopsis: (details.overview || '').replace(/\n/g, ' '),
   //       season: null,
   //       episodes: null,
   //       rating: 0,
   //       'director': director,
   //       'cast': cast,
   //       pegi: await getPegi(content.id), isMovie,
   //       release: content.release_date
   //    };
   // } else {
   //    const seasonsData = await Promise.all(
   //      details.seasons
   //        .filter(s => s.season_number !== 0)
   //        .map(async season => {
   //          const seasonDetails = await fetchTmdbData(`tv/${content.id}/season/${season.season_number}`);
   //          return {
   //            id: content.movieDB,
   //            synopsis: (seasonDetails.overview || '').replace(/\n/g, ' '),
   //            season: season.season_number,
   //            episodes: season.episode_count,
   //            rating: seasonDetails.vote_average,
   //            info_director: director,
   //            info_cast: cast,
   //            info_pegi: await getPegi(content.id, isMovie),
   //            info_release: seasonDetails.air_date
   //          };
   //        })
   //    );
   //    return seasonsData;
   //  }
}

// async function getPegi(contentId, isMovie) {
//    const endpoint = isMovie 
//      ? `movie/${contentId}/release_dates` 
//      : `tv/${contentId}/content_ratings`;
   
//    try {
//      const data = await fetchTmdbData(endpoint);
//      const result = data.results.find(r => r.certification);
//      return result?.certification || null;
//    } catch {
//      return null;
//    }
//  }

async function setMedia(req, res) {
   const client = await userDB.connect();
   try {
      lock_key['lock'] = true;
   
      let mediaData = [];
      let mediaInfoData = [];
      let jumps = patata['jumps'];
      
      // Primero Peliculas
      let start = patata['movies_start'];
      let amount = patata['movies_max_pages'];
      let check = true;
      console.log("------ Movies ------");
      console.log("Movies Starting Page: ", start);
      console.log("Movies Last Page: ", amount);
      console.log("Starting to Fetch Movies Data");
      for (start; start < amount; start++) {
         const [movies] = await Promise.all([
            fetchTmdbData("movie/popular", { page: start }),
         ]);
         
         // console.log(movies);
         
         
         mediaData.push(...await Promise.all(movies.results.map(m => processMediaItem(m, true))));
         mediaInfoData.push(...await Promise.all(movies.results.map(m => processMediaInfo(m, true))));
         

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
      check = true;
      console.log("------ Shows ------");
      console.log("Shows Starting Page: ", start);
      console.log("Shows Last Page: ", amount);
      console.log("Starting to Fetch Shows Data");
      for (start; start < amount; start++) {
         const [shows] = await Promise.all([
            fetchTmdbData("tv/popular", { page: start }),
         ]);
         // console.log(shows);
         mediaData.push(...await Promise.all(shows.results.map(s => processMediaItem(s, false))));
         mediaInfoData.push(...await Promise.all(shows.results.map(s => processMediaInfo(s, false))));
         // showInfoData.push(...await Promise.all(shows.results.map(s => processMediaInfo(s, false))));
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
      const uniqueMediaData = [...await new Map(mediaData.map(m => [`${m.id}_${m.type}`, m])).values()];
      
      
      const quer = 'INSERT INTO media("name", "genres", "type", "moviedb", "description", "png") VALUES ($1, $2, $3, $4, $5, $6) ON CONFLICT (moviedb) DO NOTHING';
      let failed = 0;
      let added = 0;
      for (const element of uniqueMediaData) {
         const result = await client.query(
            quer,
            [element['name'], element['genres'], element['type'], element['movieDB'], element['description'], element['png']]
         );
         if (result.rowCount == 0) {
            console.log(element['name'], " / " + element['id'], " -> Failed");
            failed++;
         } else {
            console.log(element['name'], " / " + element['id'], " -> Success");
            added++;
         }
      }

      lock_key['lock'] = false;
      res.status(200).json({message: "patata", media: mediaData, mediaInfoData: mediaInfoData, failed: failed, inserted: added});
   } catch (error) {
      console.log(error);
      res.status(500).json({error: error, message: "Something Went Horribly Wrong"});
   } finally {
      client.release();
   }
   
}

module.exports = setMedia;