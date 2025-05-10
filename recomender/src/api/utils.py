from typing import List, Optional
from .schemas import Rating

def convert_ratings_to_old_format(ratings: Optional[List[Rating]]) -> Optional[List[tuple]]:
        if ratings is None:
            return None
        return [(rating.movie_id, rating.rating) for rating in ratings]