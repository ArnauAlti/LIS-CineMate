from models import StarRatingRecommender, StarRatingGenreFilteredRecommender
import warnings
import os

# Suppress warnings for cleaner output
warnings.filterwarnings('ignore')

# Example Usage
if __name__ == "__main__":
    # Get the absolute path to the data file
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, 'data', 'movie_2.csv')
    
    # 1. Demonstrate Star Rating Recommender
    print("\n=== STAR RATING RECOMMENDER ===")
    star_rec = StarRatingRecommender(data_path=data_path)

    user_ratings = {
        'ratings': [
            ('media-1', 5),  # Máxima preferencia
            ('media-3', 1),  # Máximo rechazo
            ('media-9', 4)
        ]
    }
    
    print("\nTop 5 Recommended Movies (based on star ratings):")
    star_recommendations = star_rec.get_personalized_recommendations(user_ratings)
    print(star_recommendations)
    
    # 2. Demonstrate Star Rating Genre Filtered Recommender
    print("\n=== STAR RATING GENRE FILTERED RECOMMENDER ===")
    star_genre_rec = StarRatingGenreFilteredRecommender(
        data_path=data_path,
    )
    genre_filter = ['Action']

    print(f"\nTop 3 Recommended {', '.join(genre_filter)} Movies (star ratings):")
    print(star_genre_rec.get_personalized_recommendations(user_ratings, top_n=3))