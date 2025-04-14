import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel

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
        """Process user preferences"""
        combined_sim_scores = np.zeros(self.sim_matrix.shape[0])
        total_rated = 0
        
        # Process liked movies
        liked_movies = user_preferences.get('liked_movies', [])
        for movie in liked_movies:
            if movie in self.title_to_indices:
                for idx in self.title_to_indices[movie]:
                    combined_sim_scores += self.sim_matrix[idx]
                    total_rated += 1
        
        # Process disliked movies
        disliked_movies = user_preferences.get('disliked_movies', [])
        for movie in disliked_movies:
            if movie in self.title_to_indices:
                for idx in self.title_to_indices[movie]:
                    combined_sim_scores -= self.sim_matrix[idx]
                    total_rated += 1
        
        if total_rated > 0:
            combined_sim_scores /= total_rated
            
        return combined_sim_scores, total_rated
    
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









# class MovieRecommender:
#     def __init__(self, data_path='data/movie.csv'):
#         """
#         Initialize the recommender system with movie data
#         """
#         self.movies = self._load_and_preprocess_data(data_path)
#         self.tfidf_matrix, self.sim_matrix = self._build_similarity_matrix()
#         self.title_to_indices = self._create_title_to_indices_mapping()
    
#     def _load_and_preprocess_data(self, data_path):
#         """
#         Load and preprocess the movie data from CSV file
#         Returns cleaned and transformed movie data
#         """
#         movies = pd.read_csv(data_path)
#         movies = self._clean_movie_titles(movies)
#         movies = self._clean_movie_genres(movies)
#         return movies
    
#     def _clean_movie_titles(self, movies):
#         """
#         Clean and separate movie titles and years
#         Returns DataFrame with cleaned titles and extracted years
#         """
#         movies.rename(columns={'title':'title_year'}, inplace=True)
#         movies['title_year'] = movies['title_year'].apply(lambda x: x.strip())
#         movies['title'] = movies['title_year'].apply(self._extract_title)
#         movies['year'] = movies['title_year'].apply(self._extract_year)
#         return movies
    
#     def _extract_title(self, title):
#         """
#         Helper function to extract movie title from title_year string
#         """
#         year = title[len(title)-5:len(title)-1]
#         return title[:len(title)-7] if year.isnumeric() else title
    
#     def _extract_year(self, title):
#         """
#         Helper function to extract movie year from title_year string
#         """
#         year = title[len(title)-5:len(title)-1]
#         return int(year) if year.isnumeric() else np.nan
    
#     def _clean_movie_genres(self, movies):
#         """
#         Clean and standardize movie genres
#         Returns DataFrame with cleaned genres
#         """
#         movies['genres'] = movies['genres'].str.replace('Sci-Fi','SciFi')
#         movies['genres'] = movies['genres'].str.replace('Film-Noir','Noir')
#         movies = movies[~(movies['genres']=='(no genres listed)')].reset_index(drop=True)
#         return movies
    
#     def _build_similarity_matrix(self):
#         """
#         Build TF-IDF matrix and cosine similarity matrix based on genres
#         Returns tuple of (TF-IDF matrix, similarity matrix)
#         """
#         tfidf_vector = TfidfVectorizer(stop_words='english')
#         tfidf_matrix = tfidf_vector.fit_transform(self.movies['genres'])
#         sim_matrix = linear_kernel(tfidf_matrix, tfidf_matrix)
#         return tfidf_matrix, sim_matrix
    
#     def _create_title_to_indices_mapping(self):
#         """
#         Create mapping from movie title to list of indices (for duplicate titles)
#         Returns dictionary of {title: [indices]}
#         """
#         return self.movies.groupby('title').apply(lambda x: list(x.index)).to_dict()
    
#     def _process_user_preferences(self, user_preferences):
#         """
#         Process user liked and disliked movies to calculate combined similarity scores
#         Returns tuple of (combined_sim_scores, total_rated)
#         """
#         combined_sim_scores = np.zeros(self.sim_matrix.shape[0])
#         total_rated = 0
        
#         # Process liked movies (positive influence)
#         liked_movies = user_preferences.get('liked_movies', [])
#         for movie in liked_movies:
#             if movie in self.title_to_indices:
#                 for idx in self.title_to_indices[movie]:
#                     combined_sim_scores += self.sim_matrix[idx]
#                     total_rated += 1
        
#         # Process disliked movies (negative influence)
#         disliked_movies = user_preferences.get('disliked_movies', [])
#         for movie in disliked_movies:
#             if movie in self.title_to_indices:
#                 for idx in self.title_to_indices[movie]:
#                     combined_sim_scores -= self.sim_matrix[idx]
#                     total_rated += 1
        
#         # Normalize by number of rated movies
#         if total_rated > 0:
#             combined_sim_scores /= total_rated
            
#         return combined_sim_scores, total_rated
    
#     def _get_all_rated_movies(self, user_preferences):
#         """
#         Get set of all rated movie titles (including all versions)
#         Returns set of movie titles
#         """
#         all_rated_movies = set()
#         liked_movies = user_preferences.get('liked_movies', [])
#         disliked_movies = user_preferences.get('disliked_movies', [])
        
#         for movie in liked_movies + disliked_movies:
#             if movie in self.title_to_indices:
#                 all_rated_movies.add(movie)
                
#         return all_rated_movies
    
#     def _generate_recommendations(self, sim_scores, all_rated_movies, top_n, genre_diversity):
#         """
#         Generate recommendations based on similarity scores and filters
#         Returns list of recommended movie indices
#         """
#         recommendations = []
#         selected_genres = set()
        
#         for i, score in sim_scores:
#             if len(recommendations) >= top_n:
#                 break
                
#             movie_data = self.movies.iloc[i]
#             title = movie_data['title']
#             genres = set(movie_data['genres'].split('|'))
            
#             # Skip already rated movies
#             if title in all_rated_movies:
#                 continue
                
#             # Apply genre diversity if enabled
#             if genre_diversity:
#                 if not genres.issubset(selected_genres):
#                     recommendations.append(i)
#                     selected_genres.update(genres)
#             else:
#                 recommendations.append(i)
                
#         return recommendations
    
#     def get_personalized_recommendations(self, user_preferences, top_n=5, genre_diversity=True):
#         """
#         Get personalized movie recommendations based on user preferences
        
#         Parameters:
#         - user_preferences: dict with 'liked_movies' and 'disliked_movies' lists
#         - top_n: number of recommendations to return (default: 5)
#         - genre_diversity: whether to ensure genre variety (default: True)
        
#         Returns:
#         - DataFrame with recommended movies including title, genres, and year
#         """
#         # Process user preferences to get similarity scores
#         combined_sim_scores, _ = self._process_user_preferences(user_preferences)
        
#         # Get all rated movies to exclude from recommendations
#         all_rated_movies = self._get_all_rated_movies(user_preferences)
        
#         # Sort movies by similarity score
#         sim_scores = list(enumerate(combined_sim_scores))
#         sim_scores.sort(key=lambda x: x[1], reverse=True)
        
#         # Generate recommendations
#         recommendations = self._generate_recommendations(
#             sim_scores, all_rated_movies, top_n, genre_diversity
#         )
        
#         # Return recommendations with relevant columns
#         return self.movies.iloc[recommendations][['title', 'genres', 'year']].reset_index(drop=True)
    
#     def get_movie_details(self, movie_title):
#         """
#         Helper function to get details about a specific movie
#         Returns all versions if there are duplicates
        
#         Parameters:
#         - movie_title: title of the movie to look up
        
#         Returns:
#         - DataFrame with movie details or None if not found
#         """
#         if movie_title in self.title_to_indices:
#             indices = self.title_to_indices[movie_title]
#             return self.movies.iloc[indices][['title', 'genres', 'year']]
#         return None