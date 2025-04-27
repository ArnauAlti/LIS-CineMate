import requests
from pprint import pprint

BASE_URL = "http://localhost:8000/api"

def test_star_rating():
    payload = {
        "user_id": 4324,
        "ratings": [
            ["1", 1],
            ["2", 2],
            ["10", 4],
            ["41", 5]
        ],
        "top_n": 5,
        "genre_filter": None,
        "genre_diversity": True
    }
    response = requests.post(f"{BASE_URL}/recommend/star-rating", json=payload)
    pprint(response.json())

if __name__ == '__main__':
    
    print("\nTesting star rating recommender:")
    test_star_rating()