from .base_recommender import MovieRecommenderBase

class BasicRecommender(MovieRecommenderBase):
    def __init__(self, data_path='data/movie.csv'):
        """Basic recommender without genre filtering"""
        super().__init__(data_path)
    
    def get_personalized_recommendations(self, user_preferences, top_n=5, genre_diversity=True):
        """Get recommendations without genre filtering"""
        combined_sim_scores, _ = self._process_user_preferences(user_preferences)
        all_rated_movies = self._get_all_rated_movies(user_preferences)
        
        sim_scores = list(enumerate(combined_sim_scores))
        sim_scores.sort(key=lambda x: x[1], reverse=True)
        
        recommendations = []
        selected_genres = set()
        for i, score in sim_scores:
            if len(recommendations) >= top_n:
                break
                
            movie_data = self.movies.iloc[i]
            title = movie_data['title']
            genres = set(movie_data['genres'].split('|'))
            
            if title in all_rated_movies:
                continue
                
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