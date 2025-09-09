
import uuid
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from ..database.database import Base


class QuizScore(Base):
    __tablename__ = "quiz_scores"

    id = Column(UUID(as_uuid=True), primary_key=True,
                default=uuid.uuid4, index=True, nullable=False, unique=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey(
        "users.id", ondelete="CASCADE"), nullable=False)
    score = Column(Integer, nullable=False)
    quiz_name = Column(String, nullable=False)
    taken_at = Column(DateTime(timezone=True),
                      server_default=func.now(), nullable=False)

    # create relationship with 'users' table
    user = relationship("User", back_populates="quiz_scores")
