from fastapi import FastAPI
from service.auth_service import router as auth_router
from middleware.cors import add_cors_middleware
import uvicorn

app = FastAPI()

add_cors_middleware(app)

app.include_router(auth_router)

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
