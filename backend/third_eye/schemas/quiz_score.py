from pydantic import BaseModel

class QuizScoreRequest(BaseModel):
    quiz_name: str
    score: int
