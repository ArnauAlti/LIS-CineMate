# Movie Recommendation API with Docker

This project provides a movie recommendation system with different recommendation algorithms, packaged in a Docker container.

## Prerequisites

- Docker installed
- Python 3.10+ (for client scripts)
- Git (optional)

## Project Structure
recomender/
├── src/ # Source code
│ ├── api/ # API endpoints
│ ├── models/ # Recommendation models
│ ├── data/
│ |── init.py
| └── main.py
|── fast_api/ # Docker/client files
| ├── client.py # Test client
|── Dockerfile # Docker configuration
|── requirements.txt
└── proves # Proves of the src

QUICK START:
1. Build and run (Make sure to be in the recomender directory):
docker build -f Dockerfile -t movie-recommender .
docker run -it -p 8000:8000 movie-recommender

TESTING OPTIONS:

1. Swagger UI (best option):
Open http://localhost:8000/docs in your browser to try all endpoints interactively

2. Python client:
pip install -r fast_api/requirements.txt
python fast_api/client.py

3. Manual curl commands:

Basic check:
curl http://localhost:8000/

Star ratings:
curl -X POST http://localhost:8000/recommend/star-rating -H "Content-Type: application/json" -d 
'{
  "user_id": 123,
  "ratings": [
    {"movie_id": "1", "rating": 1},
    {"movie_id": "2", "rating": 2},
    {"movie_id": "10", "rating": 4},
    {"movie_id": "41", "rating": 5}
  ],
  "top_n": 5,
  "genre_filter": ["Action"],
  "genre_diversity": true
}'

Star ratings with genre filter:
curl -X POST http://localhost:8000/recommend/star-rating-genre -H "Content-Type: application/json" -d 
'{
  "user_id": 123,
  "ratings": [
    {"movie_id": "1", "rating": 1},
    {"movie_id": "2", "rating": 2},
    {"movie_id": "10", "rating": 4},
    {"movie_id": "41", "rating": 5}
  ],
  "top_n": 5,
  "genre_filter": ["Action"],
  "genre_diversity": true
}'

MANAGEMENT:
View containers: docker ps
Stop container: docker stop <container_id>
View logs: docker logs -f <container_id>
Enter container: docker exec -it <container_id> bash
