from datetime import timedelta
import json
from firebase_admin import auth, credentials, initialize_app
from fastapi import APIRouter, HTTPException
import firebase_admin
from ..schemas.token import TokenRequest
from ..auth.jwt import create_access_token, create_refresh_token
import os

# Initialize Firebase only once
if not firebase_admin._apps:
    firebase_key = os.getenv("FIREBASE_KEY")
    if not firebase_key:
        raise RuntimeError("FIREBASE_KEY env variable not set")

    firebase_dict = json.loads(firebase_key)  # Parse JSON string
    cred = credentials.Certificate(firebase_dict)
    initialize_app(cred)

router = APIRouter(prefix="/auth")


@router.post("/google-sign-in")
async def auth_firebase(data: TokenRequest):
    try:
        decoded_token = auth.verify_id_token(data.id_token)
        uid = decoded_token["uid"]
        email = decoded_token.get("email")
        name = decoded_token.get("name")

        payload = {"sub": uid, "email": email, "name": name}

        access_token = create_access_token(
            data=payload,
            expire_delta=timedelta(minutes=30)
        )
        refresh_token = create_refresh_token(
            data=payload,
            expire_delta=timedelta(days=7)
        )

        return {
            "status": "success",
            "uid": uid,
            "email": email,
            "name": name,
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "Bearer"
        }
    except Exception as e:
        raise HTTPException(status_code=401, detail=f"Invalid token: {str(e)}")
