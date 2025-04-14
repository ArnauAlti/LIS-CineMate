from models import BasicRecommender, GenreFilteredRecommender
import warnings
import os

# Suppress warnings for cleaner output
warnings.filterwarnings('ignore')

# Example Usage
if __name__ == "__main__":
    # Get the absolute path to the data file
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, 'data', 'movie.csv')
    
    # Test user preferences
    user_prefs = {
        'liked_movies': ['Toy Story', 'Jumanji'],
        'disliked_movies': ['Richard III', 'GoldenEye']
    }
    
    # 1. Demonstrate Basic Recommender
    print("\n=== BASIC RECOMMENDER ===")
    basic_rec = BasicRecommender(data_path=data_path)
    
    print("\nTop 5 Recommended Movies (all genres):")
    recommendations = basic_rec.get_personalized_recommendations(user_prefs)
    print(recommendations)
    
    # 2. Demonstrate Genre-Filtered Recommender
    print("\n=== GENRE-FILTERED RECOMMENDER ===")
    genre_filter = ['Mystery']
    filtered_rec = GenreFilteredRecommender(data_path=data_path, genre_filter=genre_filter)
    
    print(f"\nTop 5 Recommended Movies (only {', '.join(genre_filter)}):")
    filtered_recommendations = filtered_rec.get_personalized_recommendations(user_prefs)
    print(filtered_recommendations)