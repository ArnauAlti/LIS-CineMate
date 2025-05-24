import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel

class MovieRecommenderBase:
    """Base class for movie recommendation systems using TF-IDF and cosine similarity.
    
    Attributes:
        movies (pd.DataFrame): Dataset containing movie metadata.
        tfidf_matrix (scipy.sparse.csr_matrix): TF-IDF feature matrix.
        sim_matrix (np.ndarray): Pairwise cosine similarity matrix.
        id_to_index (dict): Mapping of movie IDs to DataFrame indices.
    """

    def __init__(self, data_path='data/movies.csv', init_all=True):
        """Initialize the recommender with movie data.
        
        Args:
            data_path (str): Path to the CSV file containing movie data.
        """
        self.movies = pd.read_csv(data_path)
        self._preprocess_data()
        if init_all:
            self.tfidf_matrix, self.sim_matrix = self._build_similarity_matrix()
            self.id_to_index = {row['id']: idx for idx, row in self.movies.iterrows()}

    def _preprocess_data(self):
        """Perform basic data cleaning:
        - Remove spaces in genres.
        - Drop rows with empty genres.
        """
        self.movies = self.movies[self.movies['genres'] != '']

    def _build_similarity_matrix(self):
        """Compute the TF-IDF matrix and pairwise similarity between movies based on genres.
        
        Returns:
            tuple: (TF-IDF matrix, cosine similarity matrix).
        """
        tfidf = TfidfVectorizer(
            tokenizer=lambda x: x.split('|'),
            token_pattern=None,
            lowercase=False
        )
        tfidf_matrix = tfidf.fit_transform(self.movies['genres'])
        sim_matrix = linear_kernel(tfidf_matrix, tfidf_matrix)
        return tfidf_matrix, sim_matrix
    
    def _process_user_preferences(self, user_ratings):
        """Convert user ratings into a weighted similarity score vector.
        
        Args:
            user_ratings (list): List of tuples [(movie_id, rating_1_to_5), ...].
        
        Returns:
            np.ndarray: Combined similarity scores normalized by total weight.
        """
        combined_scores = np.zeros(len(self.movies))
        total_weight = 0
        
        for movie_id, rating in user_ratings:
            if movie_id in self.id_to_index:
                idx = self.id_to_index[movie_id]
                # Convert rating (1-5) to weight (-1 to +1)
                weight = (rating - 3) / 2  
                combined_scores += self.sim_matrix[idx] * weight
                total_weight += abs(weight)
        
        return combined_scores / total_weight if total_weight > 0 else combined_scores