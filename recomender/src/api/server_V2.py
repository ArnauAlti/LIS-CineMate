from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi import UploadFile, File
from ..models import (
    StarRatingRecommender,
    StarRatingGenreFilteredRecommender
)
from .schemas import MovieRecommendation, RecommendationRequest, Rating
from typing import List
import pandas as pd
import os
from typing import List
from .utils import convert_ratings_to_old_format


app = FastAPI()

recommender_instance = None
genre_recommender_instance = None

# Initialize recommenders

@app.get("/")
def read_root():
    return {"message": "Movie Recommendation API"}


DATA_PATH = os.path.join(os.path.dirname(__file__), '../data/movie.csv')

@app.post("/load-dataset/")
def load_dataset(file: UploadFile = File(...)):
    global recommender_instance

    # Asegurarse de que el directorio existe
    data_dir = os.path.dirname(DATA_PATH)
    os.makedirs(data_dir, exist_ok=True)

    # Sobrescribir el archivo CSV
    with open(DATA_PATH, "wb") as f:
        f.write(file.file.read())

    # Inicializar el recomendador con el nuevo archivo
    recommender_instance = StarRatingRecommender(data_path=DATA_PATH)

    return {"message": "Recommender loaded successfully"}


@app.post("/recommend/star-rating", response_model=List[MovieRecommendation])
def recommend_star_rating(request: RecommendationRequest):

    if not request.ratings:
        raise HTTPException(status_code=400, detail="Star ratings required")
    
    request.ratings = convert_ratings_to_old_format(request.ratings)
    
    recommendations =  recommender_instance.get_personalized_recommendations(
        user_preferences=request.ratings,
        top_n=request.top_n,
        genre_diversity=request.genre_diversity
    )
    return recommendations.to_dict('records')

@app.post("/recommend/star-rating-genre", response_model=List[MovieRecommendation])
def recommend_star_rating_genre(request: RecommendationRequest):
    if not request.ratings or not request.genre_filter:
        raise HTTPException(status_code=400, detail="Both ratings and genre filter required")
    
    request.ratings = convert_ratings_to_old_format(request.ratings)
    
    recommendations = genre_recommender_instance.get_personalized_recommendations(
        user_preferences=request.ratings,
        top_n=request.top_n,
        genre_diversity=request.genre_diversity
    )
    return recommendations.to_dict('records')
