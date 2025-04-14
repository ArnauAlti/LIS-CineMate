from typing import List, Optional
from pydantic import BaseModel

class MovieRecommendation(BaseModel):
    title: str
    genres: str
    year: Optional[int] = None
    score: Optional[float] = None

class UserPreferences(BaseModel):
    liked_movies: Optional[List[str]] = None
    disliked_movies: Optional[List[str]] = None
    ratings: Optional[List[tuple[str, int]]] = None

class RecommendationRequest(BaseModel):
    user_id: Optional[int] = None
    user_preferences: UserPreferences
    top_n: int = 5
    genre_filter: Optional[List[str]] = None
    genre_diversity: bool = True