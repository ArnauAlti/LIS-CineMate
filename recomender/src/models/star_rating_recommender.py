from .base_recommender import MovieRecommenderBase
import numpy as np

class StarRatingRecommender(MovieRecommenderBase):
    """Recommender system based on user star ratings (1-5) and genre similarity."""
    
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
        combined_scores = self._process_user_preferences(user_ratings)
        rated_ids = {movie_id for movie_id, _ in user_ratings}
        
        # Get sorted indices by score
        sim_scores = list(enumerate(combined_scores))
        sim_scores.sort(key=lambda x: x[1], reverse=True)
        
        # Get potential recommendations (unrated movies)
        potential_recs = [i for i, _ in sim_scores 
                         if self.movies.iloc[i]['id'] not in rated_ids]
        
        # Apply genre filter if specified
        if genre_filter and len(genre_filter) > 0:
            potential_recs = self._filter_by_genres(potential_recs, genre_filter)
        
        # Select final recommendations
        recommendations = []
        selected_genres = set()
        genre_counter = {}
        
        for idx in potential_recs:
            if len(recommendations) >= top_n:
                break
                
            genres = set(self.movies.iloc[idx]['genres'].split('|'))

            for genre in genres:
                genre_counter[genre] = genre_counter.get(genre, 0) + 1
            
            if genre_diversity:
                if not genres.issubset(selected_genres):
                    recommendations.append(idx)
                    selected_genres.update(genres)
            else:
                recommendations.append(idx)
        
        top_genres = sorted(genre_counter.items(), key=lambda x: x[1], reverse=True)[:2]
        top_genres = [genre for genre, count in top_genres]

        return {
            'recommendations': self.movies.iloc[recommendations]['id'].tolist(),
            'top_genres': top_genres
        }