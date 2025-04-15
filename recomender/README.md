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
| ├── Dockerfile # Docker configuration
| └── requirements.txt
└── proves # Proves of the src

QUICK START:
1. Build and run:
docker build -f fast_api/Dockerfile -t movie-recommender .
docker run -p 8000:8000 movie-recommender

TESTING OPTIONS:

1. Swagger UI (best option):
Open http://localhost:8000/docs in your browser to try all endpoints interactively

2. Python client:
pip install -r fast_api/requirements.txt
python fast_api/client.py

3. Manual curl commands:

Basic check:
curl http://localhost:8000/

Basic recommendations:
curl -X POST http://localhost:8000/recommend/basic -H "Content-Type: application/json" -d '{"user_preferences":{"liked_movies":["Toy Story"],"disliked_movies":["GoldenEye"]},"top_n":3}'

Genre-filtered:
curl -X POST http://localhost:8000/recommend/genre-filtered -H "Content-Type: application/json" -d '{"user_preferences":{"liked_movies":["Toy Story"]},"genre_filter":["Animation"],"top_n":3}'

Star ratings:
curl -X POST http://localhost:8000/recommend/star-rating -H "Content-Type: application/json" -d '{"user_preferences":{"ratings":[["Toy Story",5],["GoldenEye",2]]},"top_n":3}'

MANAGEMENT:
View containers: docker ps
Stop container: docker stop <container_id>
View logs: docker logs -f <container_id>
Enter container: docker exec -it <container_id> bash
