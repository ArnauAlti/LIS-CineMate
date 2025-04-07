import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
import warnings

# Suppress warnings for cleaner output
warnings.filterwarnings('ignore')

class MovieRecommender:
    def __init__(self, data_path='data/movie.csv'):
        """
        Initialize the recommender system with movie data
        """
        self.movies = self._load_and_preprocess_data(data_path)
        self.tfidf_matrix, self.sim_matrix = self._build_similarity_matrix()
        # Create a mapping from title to list of indices (for duplicate titles)
        self.title_to_indices = self.movies.groupby('title').apply(lambda x: list(x.index)).to_dict()
    
    def _load_and_preprocess_data(self, data_path):
        """
        Load and preprocess the movie data
        """
        # Helper functions
        def extract_title(title):
            year = title[len(title)-5:len(title)-1]
            return title[:len(title)-7] if year.isnumeric() else title
        
        def extract_year(title):
            year = title[len(title)-5:len(title)-1]
            return int(year) if year.isnumeric() else np.nan
        
        # Load and transform data
        movies = pd.read_csv(data_path)
        movies.rename(columns={'title':'title_year'}, inplace=True)
        movies['title_year'] = movies['title_year'].apply(lambda x: x.strip())
        movies['title'] = movies['title_year'].apply(extract_title)
        movies['year'] = movies['title_year'].apply(extract_year)
        
        # Clean genres
        movies['genres'] = movies['genres'].str.replace('Sci-Fi','SciFi')
        movies['genres'] = movies['genres'].str.replace('Film-Noir','Noir')
        movies = movies[~(movies['genres']=='(no genres listed)')].reset_index(drop=True)
        
        return movies
    
    def _build_similarity_matrix(self):
        """
        Build TF-IDF matrix and cosine similarity matrix
        """
        tfidf_vector = TfidfVectorizer(stop_words='english')
        tfidf_matrix = tfidf_vector.fit_transform(self.movies['genres'])
        sim_matrix = linear_kernel(tfidf_matrix, tfidf_matrix)
        return tfidf_matrix, sim_matrix
    
    def get_personalized_recommendations(self, user_preferences, top_n=5, genre_diversity=True):
        """
        Get personalized movie recommendations based on user preferences
        
        Parameters:
        - user_preferences: dict with 'liked_movies' and 'disliked_movies' lists
        - top_n: number of recommendations to return (default: 5)
        - genre_diversity: whether to ensure genre variety (default: True)
        
        Returns:
        - DataFrame with recommended movies including title, genres, and year
        """
        # Initialize similarity scores
        combined_sim_scores = np.zeros(self.sim_matrix.shape[0])
        total_rated = 0
        
        # Process liked movies (positive influence)
        liked_movies = user_preferences.get('liked_movies', [])
        for movie in liked_movies:
            if movie in self.title_to_indices:
                for idx in self.title_to_indices[movie]:
                    combined_sim_scores += self.sim_matrix[idx]
                    total_rated += 1
        
        # Process disliked movies (negative influence)
        disliked_movies = user_preferences.get('disliked_movies', [])
        for movie in disliked_movies:
            if movie in self.title_to_indices:
                for idx in self.title_to_indices[movie]:
                    combined_sim_scores -= self.sim_matrix[idx]
                    total_rated += 1
        
        # Normalize by number of rated movies (all versions of rated movies)
        if total_rated > 0:
            combined_sim_scores /= total_rated
        
        # Get top recommendations
        recommendations = []
        sim_scores = list(enumerate(combined_sim_scores))
        sim_scores.sort(key=lambda x: x[1], reverse=True)
        
        # Track selected genres for diversity
        selected_genres = set()
        
        # Get all rated movie titles (including all versions)
        all_rated_movies = set()
        for movie in liked_movies + disliked_movies:
            if movie in self.title_to_indices:
                all_rated_movies.add(movie)
        
        for i, score in sim_scores:
            if len(recommendations) >= top_n:
                break
                
            movie_data = self.movies.iloc[i]
            title = movie_data['title']
            genres = set(movie_data['genres'].split('|'))
            
            # Skip already rated movies (any version)
            if title in all_rated_movies:
                continue
                
            # Apply genre diversity if enabled
            if genre_diversity:
                if not genres.issubset(selected_genres):
                    recommendations.append(i)
                    selected_genres.update(genres)
            else:
                recommendations.append(i)
        
        # Return recommendations with relevant columns
        return self.movies.iloc[recommendations][['title', 'genres', 'year']].reset_index(drop=True)
    
    def get_movie_details(self, movie_title):
        """
        Helper function to get details about a specific movie
        Returns all versions if there are duplicates
        """
        if movie_title in self.title_to_indices:
            indices = self.title_to_indices[movie_title]
            return self.movies.iloc[indices][['title', 'genres', 'year']]
        return None


# Example Usage
if __name__ == "__main__":
    # Initialize the recommender system
    recommender = MovieRecommender(data_path=r'C:\Users\alvar\Desktop\LIS\LIS-CineMate\recomender\src\data\movie.csv')
    
    # Test with duplicate movies
    user_prefs = {
        'liked_movies': ['Toy Story', 'Jumanji'],
        'disliked_movies': ['Richard III', 'GoldenEye']
    }
    
    print("Top 5 Recommended Movies:")
    recommendations = recommender.get_personalized_recommendations(user_prefs)
    print(recommendations)
    
    print("\nAll versions of 'Richard III':")
    print(recommender.get_movie_details('Richard III'))
