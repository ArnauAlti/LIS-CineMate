from typing import List, Optional, Tuple, Union
from pydantic import BaseModel

class MovieRecommendation(BaseModel):
    id: str

class RecommendationResponse(BaseModel):
    ok: bool
    recommendations: List[str]
    top_genres: List[str]
    message: Union[str, None] = None

class RecommendationRequest(BaseModel):
    ok: bool = True

class RecommendationRequest(BaseModel):
    ratings: List[Tuple[str, int]]  
    top_n: int = 5
    genre_diversity: bool = False

class StarRatingGenreRequest(RecommendationRequest):
    genre_filter: List[str]

class BodyData(BaseModel):
    data: str
