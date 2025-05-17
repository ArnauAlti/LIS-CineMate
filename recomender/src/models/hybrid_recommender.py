# from .base_recommender import MovieRecommenderBase
from base_recommender import MovieRecommenderBase

import numpy as np
import pandas as pd
import torch
from sklearn.cluster import KMeans

class MatrixFactorization(torch.nn.Module):
    def __init__(self, n_users, n_items, n_factors=20):
        super().__init__()
        # create user embeddings
        print("n_users:", n_users)
        print("n_items:", n_items)
        self.user_factors = torch.nn.Embedding(n_users, n_factors) # think of this as a lookup table for the input.
        # create item embeddings
        self.item_factors = torch.nn.Embedding(n_items, n_factors) # think of this as a lookup table for the input.
        self.user_factors.weight.data.uniform_(0, 0.05)
        self.item_factors.weight.data.uniform_(0, 0.05)
        
    def forward(self, data):
        # matrix multiplication
        users, items = data[:,0], data[:,1]
        return (self.user_factors(users)*self.item_factors(items)).sum(1)
    # def forward(self, user, item):
    # 	# matrix multiplication
    #     return (self.user_factors(user)*self.item_factors(item)).sum(1)
    
    def predict(self, user, item):
        return self.forward(user, item)


from torch.utils.data.dataset import Dataset
from torch.utils.data import DataLoader # package that helps transform your data to machine learning readiness

# Note: This isn't 'good' practice, in a MLops sense but we'll roll with this since the data is already loaded in memory.
class Loader(Dataset):
    def __init__(self, ratings):
        self.ratings = ratings.copy()
        
        # Extract all user IDs and movie IDs
        users = ratings.user_id.unique()
        movies = ratings.movie_id.unique()
        
        #--- Producing new continuous IDs for users and movies ---
        
        # Unique values : index
        self.userid2idx = {o:i for i,o in enumerate(users)}
        self.movieid2idx = {o:i for i,o in enumerate(movies)}
        
        # Obtained continuous ID for users and movies
        self.idx2userid = {i:o for o,i in self.userid2idx.items()}
        self.idx2movieid = {i:o for o,i in self.movieid2idx.items()}
        
        # return the id from the indexed values as noted in the lambda function down below.
        self.ratings['user_id'] = self.ratings['user_id'].map(self.userid2idx)
        self.ratings['movie_id'] = self.ratings['movie_id'].map(self.movieid2idx)
        
        
        self.x = self.ratings[['user_id', 'movie_id']].values
        self.y = self.ratings['rating'].values
        self.x, self.y = torch.tensor(self.x), torch.tensor(self.y) # Transforms the data to tensors (ready for torch models.)

    def __getitem__(self, index):
        return (self.x[index], self.y[index])

    def __len__(self):
        return len(self.ratings)

    
class HybridRecommender(MovieRecommenderBase):
    """Recommender system based on user star ratings (1-5) and genre similarity."""
    
    def __init__(self, data_path='data/movies.csv', ratings_path='data/ratings.csv'):
        super().__init__(data_path, init_all=False)
        self.ratings = pd.read_csv(ratings_path, delimiter=';')
        self.model = None
        self.movie_names = self.movies.set_index('id')['genres'].to_dict()
        self.n_users = len(self.ratings.user_id.unique())
        self.n_items = len(self.ratings.movie_id.unique())
        self.loss_fn = torch.nn.MSELoss()
        self.optimizer = None
        self.train_set = Loader(self.ratings)
        self.train_loader = DataLoader(self.train_set, 128, shuffle=True)
        self.kmeans = None
        
    def set_model(self, n_factors=8):
        """Set the model for matrix factorization."""
        self.model = MatrixFactorization(len(self.ratings.user_id.unique()), len(self.movies.id.unique()), n_factors)
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=1e-3)
        cuda = torch.cuda.is_available()
        if cuda:
            self.model = self.model.cuda()
            
    def train_model(self, epochs=10, cuda=True):
        """Train the model."""
        for it in range(epochs):
            losses = []
            for x, y in self.train_loader:
                if cuda:
                    x, y = x.cuda(), y.cuda()
                    self.optimizer.zero_grad()
                    outputs = self.model(x)
                    
                    loss = self.loss_fn(outputs.squeeze(), y.type(torch.float32))
                    losses.append(loss.item())
                    loss.backward()
                    self.optimizer.step()
            print("iter #{}".format(it), "Loss:", sum(losses) / len(losses))
    
    def make_clusters(self, n_clusters=10):
        """Make clusters of movies based on their genres."""
        c = 0
        uw = 0
        iw = 0
        for name, param in self.model.named_parameters():
            if param.requires_grad:
                print(name, param.data)
                if c == 0:
                    uw = param.data
                    c +=1
                else:
                    iw = param.data
        
        trained_movie_embeddings = self.model.item_factors.weight.data.cpu().numpy()
        
        self.kmeans = KMeans(n_clusters=10, random_state=0).fit(trained_movie_embeddings)

    def make_predictions(self):
        """Make predictions using the trained model."""
        all_movs = []
        for cluster in range(10):
            movs = []
            for movidx in np.where(self.kmeans.labels_ == cluster)[0]:
                movid = self.train_set.idx2movieid[movidx]
                rat_count = len(self.ratings.loc[self.ratings['movie_id'] == movid])
                movs.append((movid, rat_count))
            all_movs.extend(movs)
        return all_movs
    
    def filter_by_genres(self, movie_indices, genre_filter):
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

    def get_personalized_recommendations(self, user_ratings, genre_filter=None, top_n=5, genre_diversity=False):
        """Generate recommendations, optionally filtered by genres.
        
        Args:
            user_ratings (list): List of tuples [(movie_id, rating_1_to_5), ...].
            genre_filter (list): Only include movies with these genres.
            top_n (int): Number of recommendations to return.
            genre_diversity (bool): Enforce genre diversity if True.
        
        Returns:
            pd.DataFrame: Recommended movies with columns ['id', 'genres'].
        """
        self.set_model()
        self.train_model()
        self.make_clusters()
        recommendations = self.make_predictions()
        recommendations = sorted(recommendations, key=lambda x: x[1], reverse=True)
        
        if genre_filter and len(genre_filter) > 0:
            recommendations = [(movid, rat_count) for movid, rat_count in recommendations]
        
        return recommendations
        