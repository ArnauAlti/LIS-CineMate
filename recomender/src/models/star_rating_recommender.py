from .base_recommender import MovieRecommenderBase
import numpy as np

class StarRatingRecommender(MovieRecommenderBase):
    def _process_user_preferences(self, user_ratings):
        """
        Procesa las valoraciones directamente usando IDs
        """
        combined_scores = np.zeros(len(self.movies))
        total_weight = 0
        
        for movie_id, rating in user_ratings.get('ratings', []):
            if movie_id in self.id_to_index:
                idx = self.id_to_index[movie_id]
                # Convertir rating 1-5 a peso (-1 a +1)
                weight = (rating - 3) / 2
                combined_scores += self.sim_matrix[idx] * weight
                total_weight += abs(weight)
        
        if total_weight > 0:
            combined_scores /= total_weight
            
        return combined_scores

    def get_personalized_recommendations(self, user_ratings, top_n=5, genre_diversity=True):
        """
        Obtiene recomendaciones basadas en IDs
        """
        combined_scores = self._process_user_preferences(user_ratings)
        rated_ids = {movie_id for movie_id, _ in user_ratings.get('ratings', [])}
        
        # Obtener índices ordenados por puntuación
        sorted_indices = np.argsort(combined_scores)[::-1]
        
        recommendations = []
        selected_genres = set()
        
        for idx in sorted_indices:
            if len(recommendations) >= top_n:
                break
                
            movie_id = self.movies.iloc[idx]['id']
            genres = set(self.movies.iloc[idx]['genres'].split('|'))
            
            # Saltar películas ya valoradas
            if movie_id in rated_ids:
                continue
                
            # Aplicar diversidad de géneros
            if genre_diversity:
                if not genres.issubset(selected_genres):
                    recommendations.append(idx)
                    selected_genres.update(genres)
            else:
                recommendations.append(idx)
        
        return self.movies.iloc[recommendations][['id', 'genres']]