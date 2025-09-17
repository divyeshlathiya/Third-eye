from typing import Optional
from pydantic import BaseModel


class TokenRequest(BaseModel):
    id_token: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    dob: Optional[str] = None  # "YYYY-MM-DD"
    gender: Optional[str] = None
    profile_pic: Optional[str] = None

class TokenResponce(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"

class RefreshTokenRequest(BaseModel):
    refresh_token: str