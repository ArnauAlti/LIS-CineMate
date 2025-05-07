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
│ └── init.py
|── Dockerfile # Docker configuration
|── requirements.txt
└── proves # Proves of the src

QUICK START:
1. Build and run (Make sure to be in the recomender directory):
docker build -f Dockerfile -t movie-recommender .
docker run -it -p 12000:12000 movie-recommender

TESTING OPTIONS:

1. Swagger UI (best option):
Open http://localhost:12000/docs in your browser to try all endpoints interactively

2. Python client:
pip install -r fast_api/requirements.txt
python fast_api/client.py

3. Manual curl commands:

Basic check:
curl http://localhost:12000/

send-data:
curl http://localhost:3000/media/send-media -H "api-key: APIKEY"

star-rating:
curl -X POST http://localhost:3000/library/recommend -H "api-key: APIKEY" -H "Content-Type: application/json" -d "{\"user_mail\": \"1\"}"

star-rating-filter:
curl -X POST http://localhost:3000/library/recommend -H "api-key: APIKEY" -H "Content-Type: application/json" -d "{\"user_mail\": \"1\", \"genre_filter\": [1,2]}"

MANAGEMENT:
View containers: docker ps
Stop container: docker stop <container_id>
View logs: docker logs -f <container_id>
Enter container: docker exec -it <container_id> bash
