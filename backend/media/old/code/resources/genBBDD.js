const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { promisify } = require('util');
const writeFile = promisify(fs.writeFile);

const API_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZDFkNzYyYzQ3YTI5MjA0MDhhMDE3ZjkzZWMyOTU5YSIsIm5iZiI6MTc0NDgyNzk5Mi4yMywic3ViIjoiNjdmZmY2NTg2MWIxYzRiYjMyOTliZDI0Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.hiW-YBlejzl6mh1srS3OfUeNLfBdAaQjTck9bQrzYgA";
const BASE_URL = "https://api.themoviedb.org/3";
const DATA_DIR = "data";

// Configuración de Axios
const tmdb = axios.create({
  baseURL: BASE_URL,
  headers: {
    "Authorization": `Bearer ${API_TOKEN}`,
    "accept": "application/json"
  }
});

// Crear directorio si no existe
if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR);
}

// Función para obtener datos de TMDB con reintentos
async function fetchTmdbData(endpoint, params = {}) {
  try {
    const response = await tmdb.get(endpoint, { params });
    return response.data;
  } catch (error) {
    console.error(`Error fetching ${endpoint}:`, error.message);
    throw error;
  }
}

// Guardar datos en CSV
async function saveToCsv(data, filename) {
  const filePath = path.join(DATA_DIR, filename);
  const header = Object.keys(data[0]).join(',');
  const rows = data.map(obj => Object.values(obj).map(v => `"${v}"`).join(','));
  const csvContent = [header, ...rows].join('\n');
  
  await writeFile(filePath, csvContent, 'utf8');
  console.log(`${filename} generado en ${DATA_DIR}/`);
}

// Procesar géneros
async function processGenres() {
  const [movieGenres, tvGenres] = await Promise.all([
    fetchTmdbData("genre/movie/list"),
    fetchTmdbData("genre/tv/list")
  ]);

  const allGenres = [...movieGenres.genres, ...tvGenres.genres];
  const uniqueGenres = [...new Map(allGenres.map(g => [g.id, g])).values()];

  await saveToCsv(
    uniqueGenres.map(g => ({ genre_id: g.id, genre_name: g.name })),
    'genres.csv'
  );
}

// Procesar media
async function processMediaItem(content, isMovie) {
  const mediaType = isMovie ? 'movie' : 'tv';
  const details = await fetchTmdbData(`${mediaType}/${content.id}`);

  return {
    media_id: content.id,
    media_name: isMovie ? content.title : content.name,
    media_genres: details.genres.map(g => g.id).join(','),
    media_type: isMovie ? 'movie' : 'series',
    media_description: (content.overview || '').replace(/\n/g, ' ').replace(/"/g, "'"),
    media_png: content.poster_path ? `https://image.tmdb.org/t/p/w500${content.poster_path}` : null
  };
}

// Procesar media_info
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
      media_info_id: content.id,
      media_info_synopsis: (details.overview || '').replace(/\n/g, ' '),
      media_info_season: null,
      media_info_episodes: null,
      media_info_rating: content.vote_average,
      media_info_director: director,
      media_info_cast: cast,
      media_info_pegi: await getPegi(content.id, isMovie),
      media_info_release: content.release_date
    }];
  } else {
    const seasonsData = await Promise.all(
      details.seasons
        .filter(s => s.season_number !== 0)
        .map(async season => {
          const seasonDetails = await fetchTmdbData(`tv/${content.id}/season/${season.season_number}`);
          return {
            media_info_id: content.id,
            media_info_synopsis: (seasonDetails.overview || '').replace(/\n/g, ' '),
            media_info_season: season.season_number,
            media_info_episodes: season.episode_count,
            media_info_rating: seasonDetails.vote_average,
            media_info_director: director,
            media_info_cast: cast,
            media_info_pegi: await getPegi(content.id, isMovie),
            media_info_release: seasonDetails.air_date
          };
        })
    );
    return seasonsData;
  }
}

// Procesar personajes
async function processCharacters(content, isMovie) {
  const mediaType = isMovie ? 'movie' : 'tv';
  const credits = await fetchTmdbData(`${mediaType}/${content.id}/credits`);
  
  return credits.cast
    .slice(0, 4)
    .filter(actor => actor.character)
    .map(actor => ({
      character_id: actor.id,
      media_id: content.id,
      character_name: actor.character,
      character_context: null,
      character_image_path: actor.profile_path 
        ? `https://image.tmdb.org/t/p/w500${actor.profile_path}` 
        : null
    }));
}

// Obtener clasificación PEGI
async function getPegi(contentId, isMovie) {
  const endpoint = isMovie 
    ? `movie/${contentId}/release_dates` 
    : `tv/${contentId}/content_ratings`;
  
  try {
    const data = await fetchTmdbData(endpoint);
    const result = data.results.find(r => r.certification);
    return result?.certification || null;
  } catch {
    return null;
  }
}

// Función principal
async function download() {
  try {
    // 1. Procesar géneros
    await processGenres();

    // 2. Obtener contenido popular
    const [movies, tvShows] = await Promise.all([
      fetchTmdbData("movie/popular", { page: 1 }),
      fetchTmdbData("tv/popular", { page: 1 })
    ]);

    // 3. Procesar en paralelo
    const [mediaData, mediaInfoData, charactersData] = await Promise.all([
      Promise.all([...movies.results.map(m => processMediaItem(m, true)),
                  ...tvShows.results.map(tv => processMediaItem(tv, false))]),
      Promise.all([...movies.results.map(m => processMediaInfo(m, true)),
                  ...tvShows.results.map(tv => processMediaInfo(tv, false))]).then(arr => arr.flat()),
      Promise.all([...movies.results.map(m => processCharacters(m, true)),
                  ...tvShows.results.map(tv => processCharacters(tv, false))]).then(arr => arr.flat())
    ]);

    // 4. Eliminar duplicados
    const uniqueMediaData = [...new Map(mediaData.map(m => [`${m.media_id}_${m.media_type}`, m])).values()];
    const uniqueMediaInfo = [...new Map(mediaInfoData.map(m => [JSON.stringify(m), m])).values()];

    // 5. Guardar archivos
    await Promise.all([
      saveToCsv(uniqueMediaData, 'media.csv'),
      saveToCsv(uniqueMediaInfo, 'media_info.csv'),
      saveToCsv(charactersData, 'characters.csv')
    ]);

    console.log("Proceso completado exitosamente!");
    return true;
  } catch (error) {
    console.error("Error en el proceso principal:", error);
    return false;
  }
}

module.exports = download;