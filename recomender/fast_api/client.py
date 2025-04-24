import requests
from pprint import pprint

BASE_URL = "http://localhost:8000/api"

def test_star_rating():
    payload = {
        "user_preferences": {
            "ratings": [("Toy Story", 5), ("GoldenEye", 2)]
        },
        "top_n": 3
    }
    response = requests.post(f"{BASE_URL}/recommend/star-rating", json=payload)
    pprint(response.json())

if __name__ == '__main__':
    print("Testing basic recommender:")
    test_basic_recommender()
    
    print("\nTesting genre-filtered recommender:")
    test_genre_filtered()
    
    print("\nTesting star rating recommender:")
    test_star_rating()