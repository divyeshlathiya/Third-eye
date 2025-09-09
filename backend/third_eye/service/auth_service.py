from fastapi import HTTPException, Depends, APIRouter, Body, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from uuid import UUID
from sqlalchemy.orm import Session
from datetime import timedelta

from ..auth.jwt import issue_tokens, ACCESS_TOKEN_EXPIRE_MINUTES, REFRESH_TOKEN_EXPIRE_DAYS, create_access_token, create_refresh_token, decode_access_token, hash_password, verfiy_password, ALGORITHM, SECRET_KEY
from ..database.database import get_db
from ..models.user import User
from ..schemas.user import CreateUser, ShowUser, LoginUser, UpdateDOBGender, RegisterResponce, UpdateProfile
from ..schemas.otp import OtpRequest, OtpVerifyRequest
from ..utils.email_utils import send_otp_email
from ..utils.otp_utils import generate_otp, verify_otp, save_otp, verified_emails


router = APIRouter(prefix="/api/auth", tags=["Authentication"])

user_router = APIRouter(prefix="/api/users")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


@router.get("/health")
def health():
    return {"status": "Ok"}


@user_router.get("")
def get_all_users(db: Session = Depends(get_db)):
    """ fetch all users """
    return db.query(User).all()


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
) -> User:
    payload = decode_access_token(token)
    if payload is None or "sub" not in payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user_email = payload["sub"]
    user = db.query(User).filter(User.email == user_email).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    return user


@router.post("/send-otp")
async def send_otp(data: OtpRequest, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.email == data.email).first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")
    otp = generate_otp()
    save_otp(data.email, otp)
    await send_otp_email(data.email, otp)


@router.post("/verify-otp")
def verify_email_otp(data: OtpVerifyRequest):
    if verify_otp(data.email, data.otp):
        verified_emails.add(data.email)
        return {"message": "Email verified successfully"}
    raise HTTPException(status_code=400, detail="Invalid or expired otp")


@user_router.get("/me")
def get_profile(current_user: User = Depends(get_current_user)):
    if not current_user:
        raise HTTPException(status_code=401, detail="Unauhthrized")

    return {
        "first_name": current_user.first_name,
        "last_name": current_user.last_name,
        "email": current_user.email,
        "dob": current_user.dob.strftime("%d/%m/%Y") if current_user.dob else None,
        "gender": current_user.gender,
        "profile_pic": current_user.profile_pic,  # store Firebase URL in DB
    }


@user_router.patch("/me/profile/dob-gender", response_model=ShowUser)
def update_dob_profile(
    update_data: UpdateDOBGender,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not current_user:
        raise HTTPException(status_code=404, detail="User not found")

    if update_data.dob is not None:
        current_user.dob = update_data.dob
    if update_data.gender is not None:
        current_user.gender = update_data.gender

    db.commit()
    db.refresh(current_user)
    return current_user


@user_router.patch("/me/profile", response_model=ShowUser)
def update_profile(
    update_data: UpdateProfile,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not current_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Update only provided fields
    if update_data.first_name is not None:
        current_user.first_name = update_data.first_name
    if update_data.last_name is not None:
        current_user.last_name = update_data.last_name
    if update_data.dob is not None:
        current_user.dob = update_data.dob
    if update_data.gender is not None:
        current_user.gender = update_data.gender
    if update_data.profile_pic is not None:
        current_user.profile_pic = update_data.profile_pic

    db.commit()
    db.refresh(current_user)
    return current_user


@router.post("/register", response_model=RegisterResponce)
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

        tokens = issue_tokens(new_user.email)

        return {
            "user": new_user,
            "tokens": tokens
        }

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

    tokens = issue_tokens(user.email)

    return {
        "status": "success",
        "id": user.id,
        "email": user.email,
        "first_name": user.first_name,
        "access_token": tokens["access_token"],
        "refresh_token": tokens["refresh_token"],
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
