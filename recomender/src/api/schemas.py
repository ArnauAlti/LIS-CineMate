from typing import List, Optional, Tuple, Union
from pydantic import BaseModel

class MovieRecommendation(BaseModel):
    id: str
    genres: str
    year: Optional[int] = None
    score: Optional[float] = None

class RecommendationResponse(BaseModel):
    ok: bool
    recommendations: List[MovieRecommendation]
    message: Union[str, None] = None

class RecommendationRequest(BaseModel):
    ratings: List[Tuple[str, int]]  
    top_n: int = 5
    genre_diversity: bool = False

class StarRatingGenreRequest(RecommendationRequest):
    genre_filter: List[str]

class BodyData(BaseModel):
    data: str
