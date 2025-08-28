from datetime import timedelta
from firebase_admin import auth, credentials, initialize_app
from fastapi import APIRouter, HTTPException
import firebase_admin
from ..schemas.token import TokenRequest
from ..auth.auth import create_access_token, create_refresh_token


# Only initialize once (you can put this in main.py too)
if not firebase_admin._apps:
    cred = credentials.Certificate("firebase_key.json")
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
