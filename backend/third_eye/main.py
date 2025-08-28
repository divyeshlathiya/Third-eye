from fastapi import FastAPI
from .service.auth_service import router as auth_router
from .service.google_auth_service import router as google_auth_router
from .middleware.cors import add_cors_middleware
import uvicorn

app = FastAPI()

# Apply CORS middleware
add_cors_middleware(app)

# Include routers
app.include_router(auth_router)
app.include_router(google_auth_router)

if __name__ == "__main__":
    # Run as module-friendly
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
