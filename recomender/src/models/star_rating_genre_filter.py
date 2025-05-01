from .base_recommender import MovieRecommenderBase
import numpy as np

class StarRatingGenreFilteredRecommender(MovieRecommenderBase):
    def __init__(self, data_path='data/movies.csv'):
        """
        Initializes the recommender without genre filter
        """
        super().__init__(data_path)
        # Create ID to index mapping
        self.id_to_index = {row['id']: idx for idx, row in self.movies.iterrows()}
    
    def _filter_by_genres(self, movie_indices, genre_filter):
        """Filter movies by specified genres"""
        if not genre_filter:
            return movie_indices
            
        filtered_indices = []
        for idx in movie_indices:
            movie_genres = set(self.movies.iloc[idx]['genres'].split('|'))
            if any(genre in movie_genres for genre in genre_filter):
                filtered_indices.append(idx)
        return filtered_indices
    
    def _process_user_preferences(self, user_ratings):
        """
        Process user ratings (list of tuples: [(media-X, rating)])
        """
        combined_scores = np.zeros(len(self.movies))
        total_weight = 0
        
        for movie_id, rating in user_ratings.get('ratings', []):
            if movie_id in self.id_to_index:
                idx = self.id_to_index[movie_id]
                # Convert rating 1-5 to weight (-1 to +1)
                weight = (rating - 3) / 2
                combined_scores += self.sim_matrix[idx] * weight
                total_weight += abs(weight)
        
        if total_weight > 0:
            combined_scores /= total_weight
            
        return combined_scores
    
    def get_personalized_recommendations(self, user_ratings, genre_filter=None, top_n=5, genre_diversity=True):
        """
        Get recommendations with optional genre filtering
        
        Args:
            user_ratings: List of tuples [(media-X, rating 1-5)]
            genre_filter: Optional list of genres to filter by
            top_n: Number of recommendations
            genre_diversity: Whether to enforce genre diversity
        """
        combined_scores = self._process_user_preferences(user_ratings)
        rated_ids = {movie_id for movie_id, _ in user_ratings}
        
        # Get sorted indices by score
        sim_scores = list(enumerate(combined_scores))
        sim_scores.sort(key=lambda x: x[1], reverse=True)
        
        # Get potential recommendations (unrated movies)
        potential_recs = [i for i, _ in sim_scores 
                         if self.movies.iloc[i]['id'] not in rated_ids]
        
        # Apply genre filter if specified
        if genre_filter:
            potential_recs = self._filter_by_genres(potential_recs, genre_filter)
        
        # Select final recommendations
        recommendations = []
        selected_genres = set()
        
        for idx in potential_recs:
            if len(recommendations) >= top_n:
                break
                
            genres = set(self.movies.iloc[idx]['genres'].split('|'))
            
            if genre_diversity:
                if not genres.issubset(selected_genres):
                    recommendations.append(idx)
                    selected_genres.update(genres)
            else:
                recommendations.append(idx)
        
        return self.movies.iloc[recommendations][['id', 'genres']]