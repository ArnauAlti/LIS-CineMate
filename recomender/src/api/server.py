from fastapi import FastAPI, HTTPException
from pathlib import Path
from io import StringIO
import pandas as pd
from ..models import (
    MovieRecommenderBase,
    StarRatingRecommender,
    HybridRecommender,
)
from .schemas import (
    RecommendationResponse,
    RecommendationRequest,
    BodyData,
)

app = FastAPI(root_path="/api")

# Constants
DATA_FOLDER = Path("/app/src/data")  # Absolute path inside container
DATA_FOLDER.mkdir(exist_ok=True, parents=True)
DATA_PATH = DATA_FOLDER / "movie.csv"  # Consistent filename
RATINGS_PATH = DATA_FOLDER / "generated_ratings.csv"  # Consistent filename

# Initialize recommenders
app.state.basic_recommender = MovieRecommenderBase(DATA_PATH)
recommender_hybrid = HybridRecommender(
    data_path=DATA_PATH,
    ratings_path=RATINGS_PATH
)
recommender_hybrid.train_model()
recommender_hybrid.cluster_movies()

@app.get("/")
def read_root():
    """Health check endpoint.
    
    Returns:
        dict: Simple status message.
    """
    return {"message": "Movie Recommendation API"}


@app.post("/load-dataset/")
async def load_dataset(csv_data: BodyData = None):
    """Load or update the movie dataset from provided CSV data.
    
    Args:
        csv_data (BodyData): CSV content as string in the request body.
        
    Returns:
        dict: Operation status with success message.
        
    Raises:
        HTTPException: 400 for invalid CSV, 500 for processing errors.
    """
    try:
        # Validate and parse CSV
        try:
            df = pd.read_csv(StringIO(csv_data.data))
        except pd.errors.ParserError as e:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid CSV format: {str(e)}"
            )
        
        # Save dataset and reinitialize recommender
        df.to_csv(DATA_PATH, index=False)
        app.state.basic_recommender = MovieRecommenderBase(DATA_PATH)

        return {
            "message": "Dataset loaded and recommender reinitialized successfully",
            "ok": True
        }
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Dataset loading failed: {str(e)}"
        )


@app.post("/recommend/star-rating", response_model=RecommendationResponse)
def recommend_star_rating(request: RecommendationRequest):
    """Generate recommendations based on user star ratings (1-5 scale).
    
    Args:
        request (RecommendationRequest): Contains ratings, genre filter,
                                         top_n, and diversity flag.
        
    Returns:
        RecommendationResponse: Structured response with recommendations.
        
    Raises:
        HTTPException: 400 for missing ratings, 500 for processing errors.
    """
    try:
        if not request.ratings:
            raise HTTPException(
                status_code=400,
                detail="At least one star rating is required"
            )

        recommender = StarRatingRecommender(DATA_PATH)
        result = recommender.get_personalized_recommendations(
            user_ratings=request.ratings,
            top_n=request.top_n,
            genre_filter=request.genre_filter if request.genre_filter else None
        )

        return {
            "ok": True,
            "recommendations": result['recommendations'],
            "top_genres": result['top_genres'],
            "message": "Recommendations generated successfully"
        }
        
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail={
                "ok": False,
                "message": f"Recommendation failed: {str(e)}",
                "recommendations": []
            }
        )


@app.post("/recommend/hybrid-recommendation", response_model=RecommendationResponse)
def recommend_star_rating_genre(request: RecommendationRequest):
    """Generate genre-filtered recommendations based on star ratings.
    
    Args:
        request (RecommendationRequest): Contains ratings, genre filter, 
                                         top_n, and diversity flag.
                                         
    Returns:
        RecommendationResponse: Structured response with filtered recommendations.
        
    Raises:
        HTTPException: 400 for missing params, 500 for processing errors.
    """
    try:
        if not request.ratings:
            raise HTTPException(400, "At least one star rating is required")

        result = recommender_hybrid.get_personalized_recommendations(
            user_ratings=request.ratings,
            genre_filter=request.genre_filter if request.genre_filter else None,
            top_n=request.top_n,
        )

        return {
            "ok": True,
            "recommendations": result['recommendations'],
            "top_genres":   result['top_genres'],
            "message":      "Recommendations generated successfully"
        }
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail={
                "ok": False,
                "message": f"Filtered recommendation failed: {str(e)}",
                "recommendations": []
            }
        )