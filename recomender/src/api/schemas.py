from typing import List, Optional, Tuple, Union
from pydantic import BaseModel

class RecommendationResponse(BaseModel):
    ok: bool
    recommendations: List[str]
    top_genres: List[str]
    message: Union[str, None] = None

class RecommendationRequest(BaseModel):
    ratings: List[Tuple[str, float]]
    top_n: int = 5
    genre_filter: Optional[List[str]] = None

class BodyData(BaseModel):
    data: str
