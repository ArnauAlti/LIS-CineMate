from typing import List, Optional
from pydantic import BaseModel

class MovieRecommendation(BaseModel):
    movieId: int
    title: str
    genres: str
    year: Optional[int] = None

class Rating(BaseModel):
    movie_id: str
    rating: int

class RecommendationRequest(BaseModel):
    user_id: int = None
    ratings: Optional[List[Rating]] = None
    top_n: int = 5
    genre_filter: Optional[List[str]] = None
    genre_diversity: bool = True
    