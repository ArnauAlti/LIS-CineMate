from .base_recommender import MovieRecommenderBase
import numpy as np

class StarRatingRecommender(MovieRecommenderBase):
    """Recommender system based on user star ratings (1-5) and genre similarity."""

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

    def get_personalized_recommendations(self, user_ratings, top_n=5, genre_diversity=False):
        """Generate movie recommendations based on user preferences.
        
        Args:
            user_ratings (list): List of tuples [(movie_id, rating_1_to_5), ...].
            top_n (int): Number of recommendations to return.
            genre_diversity (bool): If True, enforce diversity across genres.
        
        Returns:
            pd.DataFrame: Recommended movies with columns ['id', 'genres'].
        """
        combined_scores = self._process_user_preferences(user_ratings)
        rated_ids = {movie_id for movie_id, _ in user_ratings}
        
        # Sort movies by score (descending)
        sorted_indices = np.argsort(combined_scores)[::-1]

        recommendations = []
        selected_genres = set()
        
        for idx in sorted_indices:
            if len(recommendations) >= top_n:
                break
                
            movie_id = self.movies.iloc[idx]['id']
            genres = set(self.movies.iloc[idx]['genres'].split('|'))
            
            # Skip already rated movies
            if movie_id in rated_ids:
                continue
                
            # Apply genre diversity (add only if genres are new)
            if genre_diversity:
                if not genres.issubset(selected_genres):
                    recommendations.append(idx)
                    selected_genres.update(genres)
            else:
                recommendations.append(idx)

        return self.movies.iloc[recommendations][['id', 'genres']]