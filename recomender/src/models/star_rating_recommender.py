from .base_recommender import MovieRecommenderBase
import numpy as np

class StarRatingRecommender(MovieRecommenderBase):
    """Recommender system based on user star ratings (1-5) and genre similarity."""

    def get_personalized_recommendations(self, user_ratings, top_n=5, genre_diversity=False):
        """Generate movie recommendations based on user preferences.
        
        Args:
            user_ratings (list): List of tuples [(movie_id, rating_1_to_5), ...].
            top_n (int): Number of recommendations to return.
            genre_diversity (bool): If True, enforce diversity across genres.
        
        Returns:
            dict: recommendend movies and the common genres.
        """
        combined_scores = self._process_user_preferences(user_ratings)
        rated_ids = {movie_id for movie_id, _ in user_ratings}
        
        # Sort movies by score (descending)
        sorted_indices = np.argsort(combined_scores)[::-1]

        recommendations = []
        selected_genres = set()
        genre_counter = {}

        for idx in sorted_indices:
            if len(recommendations) >= top_n:
                break
                
            movie_id = self.movies.iloc[idx]['id']
            genres = set(self.movies.iloc[idx]['genres'].split('|'))
            
            # Skip already rated movies
            if movie_id in rated_ids:
                continue

            for genre in genres:
                genre_counter[genre] = genre_counter.get(genre, 0) + 1
                
            # Apply genre diversity (add only if genres are new)
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