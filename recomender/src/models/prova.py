from hybrid_recommender import HybridRecommender

# Ruta a los datos (ajusta si están en otro sitio)
movies_path = 'recomender\src\data\movie.csv'
ratings_path = 'recomender\src\data\generated_ratings.csv'

# Inicializa el recomendador
recommender = HybridRecommender(data_path=movies_path, ratings_path=ratings_path)

# Crea el modelo
recommender.set_model(n_factors=8)

# Entrena el modelo
recommender.train_model(epochs=10, cuda=True)  # Usa False si no tienes GPU

# Crea los clusters
recommender.make_clusters(n_clusters=10)

# Obtiene predicciones básicas (ordenadas por número de valoraciones)
recommendations = recommender.make_predictions()

print("\nTop 10 recomendaciones por cantidad de valoraciones:")
for i, (movid, count) in enumerate(recommendations[:10]):
    print(f"{i+1}. Movie ID: {movid}, Ratings count: {count}")

# Test de filtrado por género
filtered = recommender.filter_by_genres([movid for movid, _ in recommendations], genre_filter=['Action'])
print(f"\nPelículas filtradas por género 'Action': {filtered[:10]}")

# Simula input de usuario
user_ratings = [(1, 5), (10, 4), (20, 3)]  # IDs de películas que el usuario valoró (reemplaza con válidos)
personalized = recommender.get_personalized_recommendations(user_ratings, genre_filter=['Action'], top_n=5)
print(f"\nRecomendaciones personalizadas: {personalized[:5]}")
