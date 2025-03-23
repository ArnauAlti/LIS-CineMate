from fastapi import FastAPI
import httpx

app = FastAPI()

@app.get("/hello")
async def root():
    return {"message": "Hello World from Python"}