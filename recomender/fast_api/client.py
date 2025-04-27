import requests
from pprint import pprint

BASE_URL = "http://localhost:8000"

def test_star_rating():
    payload = {
        "user_id": 123,
        "ratings": [
            {"movie_id": "1", "rating": 1},
            {"movie_id": "2", "rating": 2},
            {"movie_id": "10", "rating": 4},
            {"movie_id": "41", "rating": 5}
        ],
        "top_n": 5,
        "genre_diversity": True
    }
    response = requests.post(f"{BASE_URL}/recommend/star-rating", json=payload)
    pprint(response.json())
    
def test_star_rating_genre():
    payload = {
        "user_id": 123,
        "ratings": [
            {"movie_id": "1", "rating": 1},
            {"movie_id": "2", "rating": 2},
            {"movie_id": "10", "rating": 4},
            {"movie_id": "41", "rating": 5}
        ],
        "top_n": 5,
        "genre_filter": ["Action"],
        "genre_diversity": True
    }
    response = requests.post(f"{BASE_URL}/recommend/star-rating-genre", json=payload)
    pprint(response.json())

if __name__ == '__main__':
    
    print("\nTesting star rating recommender:")
    test_star_rating()
    print("\nTesting star rating genre recommender:")
    test_star_rating_genre()