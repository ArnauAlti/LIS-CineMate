import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel

class MovieRecommenderBase:
    def __init__(self, data_path='data/movies.csv'):
        self.movies = pd.read_csv(data_path)
        self._preprocess_data()
        self.tfidf_matrix, self.sim_matrix = self._build_similarity_matrix()
        self.id_to_index = {row['id']: idx for idx, row in self.movies.iterrows()}

    def _preprocess_data(self):
        """Preprocesamiento mínimo necesario"""
        # Limpieza básica de géneros
        self.movies['genres'] = self.movies['genres'].str.replace(' ', '')
        # Eliminar filas sin géneros
        self.movies = self.movies[self.movies['genres'] != '']

    def _build_similarity_matrix(self):
        """Matriz de similitud basada en géneros"""
        tfidf = TfidfVectorizer(
            tokenizer=lambda x: x.split('|'),
            token_pattern=None,
            lowercase=False
        )
        tfidf_matrix = tfidf.fit_transform(self.movies['genres'])
        sim_matrix = linear_kernel(tfidf_matrix, tfidf_matrix)
        return tfidf_matrix, sim_matrix