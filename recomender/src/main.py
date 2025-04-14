from models import BasicRecommender, GenreFilteredRecommender, StarRatingRecommender, StarRatingGenreFilteredRecommender
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
        'liked_movies': ['Richard III', 'GoldenEye'],
        'disliked_movies': ['Toy Story', 'Jumanji']
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
    
    # 3. Demonstrate Star Rating Recommender
    print("\n=== STAR RATING RECOMMENDER ===")
    star_rec = StarRatingRecommender(data_path=data_path)

    # Example ratings (movie_title, rating) where rating is 1-5 stars
    user_ratings = {
        'ratings': [
            ('Toy Story', 1),  # Loved it
            ('Jumanji', 2),    # Liked it
            ('GoldenEye', 4),   # Didn't like it
            ('Richard III', 5)  # Hated it
        ]
    }

    print("\nTop 5 Recommended Movies (based on star ratings):")
    star_recommendations = star_rec.get_personalized_recommendations(user_ratings)
    print(star_recommendations)
    
    # 4. Demonstrate Star Rating Genre Filtered Recommender
    print("\n=== STAR RATING GENRE FILTERED RECOMMENDER ===")
    genre_filter = ['Action', 'Adventure']
    star_genre_rec = StarRatingGenreFilteredRecommender(
        data_path=data_path,
        genre_filter=genre_filter
    )

    user_ratings = {
        'ratings': [
            ('GoldenEye', 5),  # Loved this action movie
            ('Toy Story', 4),  # Liked this animated movie (but won't affect action recs)
            ('Richard III', 1) # Hated this
        ]
    }

    print(f"\nTop 3 Recommended {', '.join(genre_filter)} Movies (star ratings):")
    print(star_genre_rec.get_personalized_recommendations(user_ratings, top_n=3))