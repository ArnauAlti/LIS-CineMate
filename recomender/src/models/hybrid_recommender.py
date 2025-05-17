# from .base_recommender import MovieRecommenderBase
from base_recommender import MovieRecommenderBase
import pandas as pd
import torch
import numpy as np
from torch.utils.data import DataLoader
from sklearn.cluster import KMeans
from utils.matrixfactoritzation import MatrixFactorization
from utils.loader import Loader

class HybridRecommender(MovieRecommenderBase):
    """Recommender system based on user star ratings (1-5) and genre similarity + matrix factorization."""
    
    def __init__(self, data_path='data/movies.csv', ratings_path='data/ratings.csv', n_factors=8, num_epochs=128):
        super().__init__(data_path, init_all=False)
        self.ratings = pd.read_csv(ratings_path, delimiter=';')
        self.n_users = self.ratings['user_id'].nunique()
        self.n_items = self.ratings['movie_id'].nunique()
        self.n_factors = n_factors
        self.num_epochs = num_epochs
        self.cuda = torch.cuda.is_available()

        self.train_set = Loader(self.ratings)
        self.train_loader = DataLoader(self.train_set, batch_size=128, shuffle=True)

        self.model = MatrixFactorization(self.n_users, self.n_items, n_factors=self.n_factors)
        if self.cuda:
            self.model = self.model.cuda()

        self.loss_fn = torch.nn.MSELoss()
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=1e-3)

    def train_model(self):
        for epoch in range(self.num_epochs):
            losses = []
            for x, y in self.train_loader:
                if self.cuda:
                    x, y = x.cuda(), y.cuda()
                self.optimizer.zero_grad()
                outputs = self.model(x)
                loss = self.loss_fn(outputs.squeeze(), y.float())
                losses.append(loss.item())
                loss.backward()
                self.optimizer.step()

    def cluster_movies(self, n_clusters=10):
        movie_embeddings = self.model.item_factors.weight.data.cpu().numpy()
        self.kmeans = KMeans(n_clusters=n_clusters, random_state=0).fit(movie_embeddings)
        self.movie_clusters = {}

        for cluster in range(n_clusters):
            cluster_movies = []
            for idx in np.where(self.kmeans.labels_ == cluster)[0]:
                movid = self.train_set.idx2movieid[idx]
                rating_count = len(self.ratings[self.ratings['movie_id'] == movid])
                cluster_movies.append((movid, rating_count))
            sorted_movies = sorted(cluster_movies, key=lambda x: x[1], reverse=True)[:10]
            self.movie_clusters[cluster] = sorted_movies
    
    def _filter_by_genres(self, movie_indices, genre_filter):
        """Filter movies to include only those matching at least one genre in the filter.
        
        Args:
            movie_indices (list): Indices of candidate movies.
            genre_filter (list): Genres to include (e.g., ['Action', 'Adventure']).
        
        Returns:
            list: Indices of movies passing the genre filter.
        """
        if not genre_filter:
            return movie_indices
            
        filtered_indices = []
        for idx in movie_indices:
            movie_genres = set(self.movies.iloc[idx]['genres'].split('|'))
            if any(genre in movie_genres for genre in genre_filter):
                filtered_indices.append(idx)
        return filtered_indices
  
    def get_personalized_recommendations(self, user_ratings=None, genre_filter=None, top_n=5, genre_diversity=False):
        """Generate recommendations, optionally filtered by genres.
        
        Args:
            user_ratings (list): List of tuples [(movie_id, rating_1_to_5), ...].
            genre_filter (list): Only include movies with these genres.
            top_n (int): Number of recommendations to return.
            genre_diversity (bool): Enforce genre diversity if True.
        
        Returns:
            pd.DataFrame: Recommended movies with columns ['id', 'genres'].
        """
        self.train_model()
        self.cluster_movies()
        print(self.movie_clusters)
        
        #TODO: Falta el filtro de generes i formatewjar la sortida per enviar al back
        
        return self.movie_clusters
        