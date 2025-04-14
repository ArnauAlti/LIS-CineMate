from fastapi import FastAPI
import numpy as np
import pandas as pd
from models import PredictionRequest
    
app = FastAPI(root_path="/api")

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/predict")
def predict(data: PredictionRequest):
    users_df = pd.DataFrame(data.users_df)
    movies_df = pd.DataFrame(data.movies_df)
    
    user_prefs = users_df[users_df['userId'] == data.user_id].iloc[:, 1:].values.flatten()
    movie_genres = movies_df.iloc[:, 1:].values  
    scores = np.dot(movie_genres, user_prefs)
    
    movies_with_scores = movies_df.copy()
    movies_with_scores['score'] = scores
    
    recomendaciones = movies_with_scores.sort_values(by='score', ascending=False).head(data.top_n)
    
    return recomendaciones[['title', 'score']].to_dict(orient="records")
