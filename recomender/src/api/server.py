from fastapi import FastAPI, HTTPException
from ..models import (
    StarRatingRecommender,
    StarRatingGenreFilteredRecommender
)
from .schemas import RecommendationRequest, MovieRecommendation
from typing import List
import pandas as pd
import os

app = FastAPI(root_path="/api")

# Initialize recommenders
DATA_PATH = os.path.join(os.path.dirname(__file__), '../data/movie.csv')

@app.get("/")
def read_root():
    return {"message": "Movie Recommendation API"}

@app.post("/recommend/star-rating", response_model=List[MovieRecommendation])
def recommend_star_rating(request: RecommendationRequest):
    if not request.ratings:
        raise HTTPException(status_code=400, detail="Star ratings required")
    
    recommender = StarRatingRecommender(DATA_PATH)
    recommendations = recommender.get_personalized_recommendations(
        user_preferences=request.ratings,
        top_n=request.top_n,
        genre_diversity=request.genre_diversity
    )
    return recommendations.to_dict('records')

@app.post("/recommend/star-rating-genre", response_model=List[MovieRecommendation])
def recommend_star_rating_genre(request: RecommendationRequest):
    if not request.ratings or not request.genre_filter:
        raise HTTPException(status_code=400, detail="Both ratings and genre filter required")
    
    recommender = StarRatingGenreFilteredRecommender(
        data_path=DATA_PATH,
        genre_filter=request.genre_filter
    )
    recommendations = recommender.get_personalized_recommendations(
        user_preferences=request.ratings,
        top_n=request.top_n,
        genre_diversity=request.genre_diversity
    )
    return recommendations.to_dict('records')