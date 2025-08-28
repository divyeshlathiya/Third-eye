from fastapi import HTTPException, Depends, APIRouter, Body
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from sqlalchemy.orm import Session
from datetime import timedelta

from ..auth.auth import ACCESS_TOKEN_EXPIRE_MINUTES, REFRESH_TOKEN_EXPIRE_DAYS, create_access_token, create_refresh_token, decode_access_token, hash_password, verfiy_password, ALGORITHM, SECRET_KEY
from ..database.database import SessionLocal, engine
from ..models.user import User
from ..schemas.user import CreateUser, ShowUser, LoginUser
from ..schemas.otp import OtpRequest, OtpVerifyRequest
from ..utils.email_utils import send_otp_email
from ..utils.otp_utils import generate_otp, verify_otp, save_otp, verified_emails


router = APIRouter(prefix="/auth", tags=["Authentication"])

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

User.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/health")
def health():
    return {"status": "Ok"}


@router.get("/users")
def get_all_users(db: Session = Depends(get_db)):
    return db.query(User).all()


@router.post("/send-otp")
async def send_otp(data: OtpRequest, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.email == data.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    otp = generate_otp()
    save_otp(data.email, otp)
    await send_otp_email(data.email, otp)


@router.post("/verify-otp")
def verify_email_otp(data: OtpVerifyRequest):
    if verify_otp(data.email, data.otp):
        verified_emails.add(data.email)
        return {"message": "Email verified successfully"}
    raise HTTPException(status_code=400, detail="Invalid or expired otp")


@router.get("/me",)
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    try:
        payload = jwt.decode(token, SECRET_KEY, ALGORITHM=ALGORITHM)
        email = payload.get("sub")
        if email is None:
            raise HTTPException(status_code=401, detail="Invalid token")

        user = db.query(User).filter(User.email == email).first()
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return {"email": user.email, "first_name": user.first_name}
    except JWTError:
        raise HTTPException(status_code=403, detail="Token invalid or expired")


@router.post("/register", response_model=ShowUser)
def register(user: CreateUser, db: Session = Depends(get_db)):
    try:
        existing = db.query(User).filter(User.email == user.email).first()
        if existing:
            raise HTTPException(
                status_code=400, detail="User already registered :)"
            )

        new_user = User(
            first_name=user.first_name,
            last_name=user.last_name,
            email=user.email,
            password=hash_password(user.password)
        )

        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        verified_emails.remove(user.email)
        return new_user

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Something went wrong when registering user: {str(e)}"
        )


@router.post("/login")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == form_data.username).first()

    if not user or not verfiy_password(form_data.password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    access_token = create_access_token(
        data={"sub": user.email}, expire_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    refresh_token = create_refresh_token(
        data={"sub": user.email}, expire_delta=timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    )

    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "Bearer"
    }


@router.post("/refreshToken")
def refresh_token(refresh_token: str = Body(...), db: Session = Depends(get_db)):
    try:
        payload = jwt.decode(refresh_token, SECRET_KEY, algorithms=[ALGORITHM])
        email = payload.get("sub")
        if email is None:
            raise HTTPException(
                status_code=401, detail="Invalid refresh token")

        user = db.query(User).filter(User.email == email).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        # issue new access token
        new_access_token = create_access_token(
            data={"sub": user.email}, expire_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        )

        return {
            "access_token": new_access_token,
            "token_type": "Bearer"
        }

    except JWTError:
        raise HTTPException(
            status_code=401, detail="Refresh token invalid or expired")


# @router.post("/login")
# def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
#     user = db.query(User).filter(User.email == form_data.username).first()

#     if not user or not verfiy_password(form_data.password, user.password):
#         raise HTTPException(status_code=401, detail="Invalid credentials")

#     access_token = create_access_token(
#         data={"sub": user.email}, expire_delta=timedelta(minutes=30))

#     return {"access_token": access_token, "token_type": "Bearer"}
