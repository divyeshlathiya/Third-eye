from datetime import datetime, timedelta
import json
from firebase_admin import auth, credentials, initialize_app
from fastapi import APIRouter, Depends, HTTPException
import firebase_admin
from requests import Session

from ..database.database import get_db
from ..models.user import User
from ..schemas.token import TokenRequest
from ..auth.jwt import create_access_token, create_refresh_token, hash_password
import os


# Initialize Firebase only once
if not firebase_admin._apps:
    firebase_key = os.getenv("FIREBASE_KEY")
    if not firebase_key:
        raise RuntimeError("FIREBASE_KEY env variable not set")

    firebase_dict = json.loads(firebase_key)  # Parse JSON string
    cred = credentials.Certificate(firebase_dict)
    initialize_app(cred)

router = APIRouter(prefix="/api/auth")


@router.post("/google-sign-in")
async def auth_firebase(data: TokenRequest, db: Session = Depends(get_db)):
    try:
        # 1. Verify Google token
        decoded_token = auth.verify_id_token(data.id_token)
        email = decoded_token.get("email")
        name = decoded_token.get("name")
        google_pic = decoded_token.get("picture")

        # 2. Name handling
        first_name = data.first_name or (name.split(" ")[0] if name else None)
        last_name = data.last_name or (
            name.split(" ")[1] if name and len(name.split(" ")) > 1 else None
        )

        # 3. Other fields
        profile_pic = data.profile_pic or google_pic
        dob = None
        if data.dob:
            dob = datetime.strptime(data.dob, "%Y-%m-%d").date()
        gender = data.gender

        # 4. Get or create user
        user = db.query(User).filter(User.email == email).first()
        if not user:
            user = User(
                first_name=first_name,
                last_name=last_name,
                email=email,
                dob=dob,
                gender=gender,
                profile_pic=profile_pic,
                # no password for google auth
                password=hash_password(os.getenv("GOOGLE_PASS")),
                provider="google",
            )
            db.add(user)
            db.commit()
            db.refresh(user)

        # 5. Create JWT tokens
        payload = {
            "sub": user.email,
            "email": user.email,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "dob": user.dob.isoformat() if user.dob else None,
            "gender": user.gender,
            "profile_pic": user.profile_pic,
        }

        access_token = create_access_token(
            data=payload, expire_delta=timedelta(minutes=30))
        refresh_token = create_refresh_token(
            data=payload, expire_delta=timedelta(days=7))

        return {
            "status": "success",
            "uid": str(user.id),
            "email": user.email,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "dob": user.dob.isoformat() if user.dob else None,
            "gender": user.gender,
            "profile_pic": user.profile_pic,
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "Bearer",
        }

    except Exception as e:
        raise HTTPException(status_code=401, detail=f"Invalid token: {str(e)}")
