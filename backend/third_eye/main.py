from fastapi import FastAPI
from .service.auth_service import router as auth_router, user_router
from .service.google_auth_service import router as google_auth_router
from .service.quiz_service import router as quiz_router
from .service.certificate_download import router as certificate_router
from .middleware.cors import add_cors_middleware
import uvicorn
from .database.database import Base, engine
from .models.user import User
from .models.quiz_score import QuizScore
from .models.user_streak import UserStreak


app = FastAPI()

add_cors_middleware(app)

# create table once at startup
Base.metadata.create_all(bind=engine)

# Include routers
app.include_router(auth_router)
app.include_router(google_auth_router)
app.include_router(user_router)
app.include_router(quiz_router)
app.include_router(certificate_router)


if __name__ == "__main__":
    uvicorn.run("third_eye.main:app", host="0.0.0.0", port=8000, reload=True)
