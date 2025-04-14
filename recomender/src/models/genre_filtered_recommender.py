from .base_recommender import MovieRecommenderBase

class GenreFilteredRecommender(MovieRecommenderBase):
    def __init__(self, data_path='data/movie.csv', genre_filter=None):
        """
        Recommender with genre filtering capability
        Parameters:
            genre_filter: list of genres to filter by
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
    
    def get_personalized_recommendations(self, user_preferences, top_n=5, genre_diversity=True):
        """Get recommendations with genre filtering"""
        combined_sim_scores, _ = self._process_user_preferences(user_preferences)
        all_rated_movies = self._get_all_rated_movies(user_preferences)
        
        # Get all potential recommendations first
        sim_scores = list(enumerate(combined_sim_scores))
        sim_scores.sort(key=lambda x: x[1], reverse=True)
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