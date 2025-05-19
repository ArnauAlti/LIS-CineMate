from models import StarRatingRecommender, HybridRecommender
import warnings
import os

# Suppress warnings for cleaner output
warnings.filterwarnings('ignore')

# Example Usage
if __name__ == "__main__":
    # Get the absolute path to the data file
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_path = os.path.join(current_dir, 'data', 'movie.csv')
    ratings_path = os.path.join(current_dir, 'data', 'generated_ratings.csv')
    
    # # 1. Demonstrate Star Rating Recommender
    # print("\n=== STAR RATING RECOMMENDER ===")
    # star_rec = StarRatingRecommender(data_path=data_path)

    user_ratings = [
            ('media-1', 5),
            ('media-3', 1),
            ('media-9', 4)
        ]
    
    
    print("\nTop 3 Recommended Movies (based on star ratings):")
    # print(star_rec.get_personalized_recommendations(user_ratings, top_n=3))
    
    # 2. Demonstrate Star Rating Genre Filtered Recommender
    print("\n=== STAR RATING GENRE FILTERED RECOMMENDER ===")
    star_genre_rec = HybridRecommender(
        data_path=data_path,
        ratings_path=ratings_path
    )
    genre_filter = ['Action', 'Adventure']  # Example genre filter

    print(f"\nTop 3 Recommended {', '.join(genre_filter)} Movies (star ratings):")
    print(star_genre_rec.get_personalized_recommendations(user_ratings, top_n=3))