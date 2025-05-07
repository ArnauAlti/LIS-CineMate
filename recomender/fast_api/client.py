import requests
from pprint import pprint

BASE_URL = "http://localhost:12000/api"

def test_star_rating():
    payload = {
        "user_preferences": {
            "ratings": [("media-1", 5), ("media-10", 2)]
        },
        "top_n": 3
    }
    response = requests.post(f"{BASE_URL}/recommend/star-rating", json=payload)
    pprint(response.json())
    
def test_star_rating_genre():
    payload = {
        "user_preferences": {
            "ratings": [("media-1", 5), ("media-10", 2)]
        },
        "genre_filter": ["Action", "Adventure"],
        "top_n": 3
    }
    response = requests.post(f"{BASE_URL}/recommend/star-rating-genre", json=payload)
    pprint(response.json())

if __name__ == '__main__':
    print("\nTesting star rating recommender:")
    test_star_rating()

    print("\nTesting star rating genre recommender:")
    test_star_rating_genre()