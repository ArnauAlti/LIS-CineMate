from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
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

# Initialize recommenders
DATA_PATH = os.path.join(os.path.dirname(__file__), '../data/movie2.csv')

@app.get("/")
def read_root():
    return {"message": "Movie Recommendation API"}

@app.post("/upload-csv/")
def upload_csv(file: UploadFile = File(...)):
    try:
        if not file.filename.endswith('.csv'):
            raise HTTPException(status_code=400, detail="Only CSV files are allowed")
        
        data_dir = os.path.join(os.path.dirname(__file__), '../data')
        os.makedirs(data_dir, exist_ok=True)
        file_path = os.path.join(data_dir, 'movie.csv')
        
        # Versión sincrónica
        contents = file.file.read()
        with open(file_path, 'wb') as f:
            f.write(contents)
        
        return {"message": f"File uploaded successfully and saved as 'movie.csv'"}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing file: {str(e)}")
    finally:
        file.file.close()

@app.post("/recommend/star-rating", response_model=List[MovieRecommendation])
def recommend_star_rating(request: RecommendationRequest):

    if not request.ratings:
        raise HTTPException(status_code=400, detail="Star ratings required")
    
    request.ratings = convert_ratings_to_old_format(request.ratings)
    
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
    
    request.ratings = convert_ratings_to_old_format(request.ratings)
    
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
