from .base_recommender import MovieRecommenderBase
import numpy as np

class StarRatingGenreFilteredRecommender(MovieRecommenderBase):
    def __init__(self, data_path='data/movie.csv', genre_filter=None):
        """
        Genre-filtered recommender using 5-star rating system
        """
        super().__init__(data_path)
        self.genre_filter = genre_filter if genre_filter else []
    
    def _filter_by_genres(self, movie_indices):
        """Filter movies by specified genres"""
        if not self.genre_filter:
            return movie_indices
            
        filtered_indices = []
        for idx in movie_indices:
            movie_genres = set(self.movies.iloc[idx]['genres'].split('|'))
            if any(genre in movie_genres for genre in self.genre_filter):
                filtered_indices.append(idx)
        return filtered_indices
    
    def _convert_id_to_title(self, user_preferences):
        """
        Convert movie IDs in user preferences to titles
        
        Parameters:
        - user_preferences: dict with 'ratings' as a list of tuples (movie_title, rating)
        
        Returns:
        - user_preferences_filtered: dict with movie titles instead of IDs
        """
        user_preferences_filtered = {}
        user_preferences_filtered['ratings'] = []
        
        for id, rating in user_preferences.get('ratings', []):
            user_preferences_filtered['ratings'].append((self.movies[self.movies['movieId'] == int(id)]['title'].values[0], rating))
        
        return user_preferences_filtered
    
    def _process_user_preferences(self, user_preferences):
        """
        Process user preferences with 5-star ratings
        """
        combined_sim_scores = np.zeros(self.sim_matrix.shape[0])
        total_weight = 0
        
        # Process rated movies
        ratings = user_preferences.get('ratings', [])
        
        for movie_title, rating in ratings:
            if movie_title in self.title_to_indices:
                # Convert rating to weight (1-5 stars to -1 to +1 range)
                influence = (rating - 3) / 2  # 1→-1, 2→-0.5, 3→0, 4→+0.5, 5→+1
                
                for idx in self.title_to_indices[movie_title]:
                    combined_sim_scores += self.sim_matrix[idx] * influence
                    total_weight += abs(influence)
        
        # Normalize by total weight if any ratings were processed
        if total_weight > 0:
            combined_sim_scores /= total_weight
            
        return combined_sim_scores, total_weight
    
    def get_personalized_recommendations(self, user_preferences, top_n=5, genre_diversity=True):
        """Get genre-filtered recommendations with star ratings"""
        user_preferences_filtered = self._convert_id_to_title(user_preferences)
        combined_sim_scores, _ = self._process_user_preferences(user_preferences_filtered)
        
        # Get all rated movie titles to exclude
        all_rated_movies = set()
        for movie_title, _ in user_preferences_filtered.get('ratings', []):
            if movie_title in self.title_to_indices:
                all_rated_movies.add(movie_title)
        
        # Get and sort similarity scores
        sim_scores = list(enumerate(combined_sim_scores))
        sim_scores.sort(key=lambda x: x[1], reverse=True)
        
        # Get all potential recommendations first
        potential_recommendations = [i for i, _ in sim_scores 
                                   if self.movies.iloc[i]['title'] not in all_rated_movies]
        
        # Apply genre filter
        if self.genre_filter:
            potential_recommendations = self._filter_by_genres(potential_recommendations)
        
        # Apply diversity and top_n filtering
        recommendations = []
        selected_genres = set()
        for i in potential_recommendations:
            if len(recommendations) >= top_n:
                break
                
            movie_data = self.movies.iloc[i]
            genres = set(movie_data['genres'].split('|'))
            
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
