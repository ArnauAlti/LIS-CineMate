import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel

class MovieRecommenderBase:
    def __init__(self, data_path='data/movie.csv'):
        """
        Base class for movie recommenders
        """
        self.movies = self._load_and_preprocess_data(data_path)
        self.tfidf_matrix, self.sim_matrix = self._build_similarity_matrix()
        self.title_to_indices = self._create_title_to_indices_mapping()
    
    def _load_and_preprocess_data(self, data_path):
        """Common data loading and preprocessing"""
        movies = pd.read_csv(data_path)
        movies = self._clean_movie_titles(movies)
        movies = self._clean_movie_genres(movies)
        return movies
    
    def _clean_movie_titles(self, movies):
        """Clean and separate movie titles and years"""
        movies.rename(columns={'title':'title_year'}, inplace=True)
        movies['title_year'] = movies['title_year'].apply(lambda x: x.strip())
        movies['title'] = movies['title_year'].apply(self._extract_title)
        movies['year'] = movies['title_year'].apply(self._extract_year)
        return movies
    
    def _extract_title(self, title):
        """Helper to extract movie title"""
        year = title[len(title)-5:len(title)-1]
        return title[:len(title)-7] if year.isnumeric() else title
    
    def _extract_year(self, title):
        """Helper to extract movie year"""
        year = title[len(title)-5:len(title)-1]
        return int(year) if year.isnumeric() else np.nan
    
    def _clean_movie_genres(self, movies):
        """Clean and standardize movie genres"""
        movies['genres'] = movies['genres'].str.replace('Sci-Fi','SciFi')
        movies['genres'] = movies['genres'].str.replace('Film-Noir','Noir')
        movies = movies[~(movies['genres']=='(no genres listed)')].reset_index(drop=True)
        return movies
    
    def _build_similarity_matrix(self):
        """Build similarity matrices"""
        tfidf_vector = TfidfVectorizer(stop_words='english')
        tfidf_matrix = tfidf_vector.fit_transform(self.movies['genres'])
        sim_matrix = linear_kernel(tfidf_matrix, tfidf_matrix)
        return tfidf_matrix, sim_matrix
    
    def _create_title_to_indices_mapping(self):
        """Create title to indices mapping"""
        return self.movies.groupby('title').apply(lambda x: list(x.index)).to_dict()
    
    def _process_user_preferences(self, user_preferences):
        """
        Process user preferences (to be overridden by child classes)
        """
        raise NotImplementedError("This method should be implemented by child classes")
    
    def _get_all_rated_movies(self, user_preferences):
        """Get all rated movies"""
        all_rated_movies = set()
        for movie in user_preferences.get('liked_movies', []) + user_preferences.get('disliked_movies', []):
            if movie in self.title_to_indices:
                all_rated_movies.add(movie)
        return all_rated_movies
    
    def get_movie_details(self, movie_title):
        """Get details for a specific movie"""
        if movie_title in self.title_to_indices:
            indices = self.title_to_indices[movie_title]
            return self.movies.iloc[indices][['title', 'genres', 'year']]
        return None
