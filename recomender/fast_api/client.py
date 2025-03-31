'''
Script for inferencing the deployed model
'''
import pandas as pd
import os
import numpy as np
import json
import requests

def read_data():
    movies_df = pd.read_csv(r'recomender\data\output_data\movies_genres.csv', header=0, sep=',')
    users_df = pd.read_csv(r'recomender\data\output_data\users.csv', header=0, sep=',')
    return movies_df, users_df

def make_predictions(user_id, users_df, movies_df):
    url = 'http://localhost:8000/predict/'
    payload = {  
        "user_id": user_id,  
        "users_df": users_df.to_dict(),
        "movies_df": movies_df.to_dict(),  
        "top_n": 3  
    }
    response = requests.post(url, json=payload)
    return response

if __name__ == '__main__':
    movies_df, users_df = read_data()

    # Por el momento, solo nos quedaremos con 8 columnas en generos
    genres_to_keep = ['title', 'Drama', 'Comedy', 'Horror', 'Romance', 'Adventure', 'Action', 'War', 'Children']
    movies_df = movies_df[genres_to_keep]
    
    user_id = 5
    response = make_predictions(user_id, users_df, movies_df)
    print(response.json())
