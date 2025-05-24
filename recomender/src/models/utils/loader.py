import torch
from torch.utils.data.dataset import Dataset

class Loader(Dataset):
    def __init__(self, ratings):
        self.ratings = ratings.copy()
        
        users = ratings.user_id.unique()
        movies = ratings.movie_id.unique()
        
        self.userid2idx = {o:i for i,o in enumerate(users)}
        self.movieid2idx = {o:i for i,o in enumerate(movies)}
        
        self.idx2userid = {i:o for o,i in self.userid2idx.items()}
        self.idx2movieid = {i:o for o,i in self.movieid2idx.items()}
        
        self.ratings['user_id'] = self.ratings['user_id'].map(self.userid2idx)
        self.ratings['movie_id'] = self.ratings['movie_id'].map(self.movieid2idx)
        
        self.x = self.ratings[['user_id', 'movie_id']].values
        self.y = self.ratings['rating'].values
        self.x, self.y = torch.tensor(self.x), torch.tensor(self.y)

    def __getitem__(self, index):
        return (self.x[index], self.y[index])

    def __len__(self):
        return len(self.ratings)