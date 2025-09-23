from datetime import datetime, timezone, timedelta
from datetime import timedelta, datetime, timezone
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database.database import get_db
from ..models.quiz_score import QuizScore
from ..models.user import User
from ..schemas.quiz_score import QuizScoreRequest
from ..service.auth_service import get_current_user
from ..models.user_streak import UserStreak

router = APIRouter(prefix="/api/quiz", tags=["Quiz"])


def can_take_quiz(db: Session, user_id: str) -> bool:
    last_quiz = (
        db.query(QuizScore)
        .filter(QuizScore.user_id == user_id)
        .order_by(QuizScore.taken_at.desc())
        .first()
    )

    if not last_quiz:
        return True  # No quiz taken yet → allow

    # Normalize datetime (handle SQLite naive case)
    last_taken = last_quiz.taken_at
    if last_taken.tzinfo is None:
        last_taken = last_taken.replace(tzinfo=timezone.utc)

    now = datetime.now(timezone.utc)

    if now - last_taken < timedelta(days=1):
        return False

    return True


def update_streak(db: Session, user_id: str) -> UserStreak:
    today = datetime.now(timezone.utc).date()
    streak = db.query(UserStreak).filter(UserStreak.user_id == user_id).first()

    if not streak:
        streak = UserStreak(user_id=user_id, current_streak=1,
                            longest_streak=1, last_quiz_date=today)
        db.add(streak)
    else:
        last_date = streak.last_quiz_date
        if last_date == today:
            return streak  # already taken quiz today
        elif last_date == today - timedelta(days=1):
            streak.current_streak += 1
            streak.longest_streak = max(
                streak.longest_streak, streak.current_streak)
        else:
            streak.current_streak = 1
        streak.last_quiz_date = today

    db.commit()
    db.refresh(streak)
    return streak


@router.post("/add-score")
def add_score(
    score_data: QuizScoreRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Check 24-hour rule
    if not can_take_quiz(db, current_user.id):
        raise HTTPException(
            status_code=400, detail="You can take the next quiz after 24 hours")

    # Add quiz score
    quiz_score = QuizScore(
        user_id=current_user.id,
        quiz_name=score_data.quiz_name,
        score=score_data.score,
        taken_at=datetime.now(timezone.utc)
    )
    db.add(quiz_score)
    db.commit()
    db.refresh(quiz_score)

    # Update streak
    streak = update_streak(db, current_user.id)

    return {
        "status": "success",
        "quiz_score_id": str(quiz_score.id),
        "current_streak": streak.current_streak,
        "longest_streak": streak.longest_streak
    }


@router.get("/my-scores")
def get_my_scores(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    scores = db.query(QuizScore).filter(
        QuizScore.user_id == current_user.id).all()
    streak = db.query(UserStreak).filter(
        UserStreak.user_id == current_user.id).first()
    return {
        "email": current_user.email,
        "scores": scores,
        "current_streak": streak.current_streak if streak else 0,
        "longest_streak": streak.longest_streak if streak else 0
    }
