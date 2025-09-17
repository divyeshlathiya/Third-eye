from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi import FastAPI

def add_cors_middleware(app: FastAPI):
    origins = [
        "http://localhost:8000",         # FastAPI itself (optional)
        "http://localhost:3000",         # React or frontend
        "http://127.0.0.1:8000",
        "http://localhost:xxxx",         # Replace with actual Flutter port if known
        "http://192.168.1.77:xxxx",
        "http://10.47.125.29:8000",
        "http://10.47.125.53:8000",
        "http://192.168.1.159:8000",
        "http://192.168.1.90:8000",
        "*"                              # TEMP: Allow all for dev
    ]

    app.add_middleware(
        CORSMiddleware,
        allow_origins=origins,   # use ["*"] for development, restrict in production
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
