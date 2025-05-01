import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel

class MovieRecommenderBase:
    def __init__(self, data_path='data/movie.csv'):
        """
        Base class for movie recommenders
        """
        self.movies = pd.read_csv(data_path)
        self.tfidf_matrix, self.sim_matrix = self._build_similarity_matrix()
    
    def _build_similarity_matrix(self):
        """Build similarity matrices"""
        tfidf_vector = TfidfVectorizer(stop_words='english')
        tfidf_matrix = tfidf_vector.fit_transform(self.movies['genres'])
        sim_matrix = linear_kernel(tfidf_matrix, tfidf_matrix)
        return tfidf_matrix, sim_matrix
    
    def _process_user_preferences(self, user_preferences):
        """
        Process user preferences (to be overridden by child classes)
        """
        raise NotImplementedError("This method should be implemented by child classes")

