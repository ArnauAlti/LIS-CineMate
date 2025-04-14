from .base_recommender import MovieRecommenderBase
import numpy as np

class StarRatingRecommender(MovieRecommenderBase):
    def __init__(self, data_path='data/movie.csv'):
        """
        Recommender that uses 5-star rating system
        """
        super().__init__(data_path)
    
    def _process_user_preferences(self, user_preferences):
        """
        Process user preferences with 5-star ratings
        
        Parameters:
        - user_preferences: dict with 'ratings' as a list of tuples (movie_title, rating)
                           where rating is 1-5 stars
        
        Returns:
        - combined_sim_scores: numpy array of combined similarity scores
        - total_weight: total weight of all ratings
        """
        combined_sim_scores = np.zeros(self.sim_matrix.shape[0])
        total_weight = 0
        
        # Process rated movies
        ratings = user_preferences.get('ratings', [])
        
        for movie_title, rating in ratings:
            if movie_title in self.title_to_indices:
                # Convert rating to weight (1-5 stars to 0.2-1.0 scale)
                weight = (rating - 1) / 4  # Normalize to 0-1 range
                
                for idx in self.title_to_indices[movie_title]:
                    # Apply weighted influence (positive for ratings > 3, negative for < 3)
                    influence = (weight - 0.5) * 2  # Convert to -1 to +1 range
                    combined_sim_scores += self.sim_matrix[idx] * influence
                    total_weight += abs(influence)
        
        # Normalize by total weight if any ratings were processed
        if total_weight > 0:
            combined_sim_scores /= total_weight
            
        return combined_sim_scores, total_weight
    
    def get_personalized_recommendations(self, user_preferences, top_n=5, genre_diversity=True):
        """
        Get recommendations based on star ratings
        
        Parameters:
        - user_preferences: dict with 'ratings' list of (movie_title, rating) tuples
        - top_n: number of recommendations
        - genre_diversity: whether to ensure genre variety
        
        Returns:
        - DataFrame with recommended movies
        """
        combined_sim_scores, _ = self._process_user_preferences(user_preferences)
        
        # Get all rated movie titles to exclude from recommendations
        all_rated_movies = set()
        for movie_title, _ in user_preferences.get('ratings', []):
            if movie_title in self.title_to_indices:
                all_rated_movies.add(movie_title)
        
        # Get and sort similarity scores
        sim_scores = list(enumerate(combined_sim_scores))
        sim_scores.sort(key=lambda x: x[1], reverse=True)
        
        # Generate recommendations
        recommendations = []
        selected_genres = set()
        
        for i, score in sim_scores:
            if len(recommendations) >= top_n:
                break
                
            movie_data = self.movies.iloc[i]
            title = movie_data['title']
            genres = set(movie_data['genres'].split('|'))
            
            # Skip already rated movies
            if title in all_rated_movies:
                continue
                
            # Apply genre diversity if enabled
            if genre_diversity:
                if not genres.issubset(selected_genres):
                    recommendations.append(i)
                    selected_genres.update(genres)
            else:
                recommendations.append(i)
        
        # Format output
        result = self.movies.iloc[recommendations][['title', 'genres', 'year']]
        result['genres'] = result['genres'].str.replace('|', ', ')
        return result.reset_index(drop=True)