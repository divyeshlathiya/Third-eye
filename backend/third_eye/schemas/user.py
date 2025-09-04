from datetime import date, datetime
from pydantic import BaseModel, EmailStr
from uuid import UUID
from typing import Optional
from ..schemas.token import TokenResponce


class CreateUser(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    password: str
    gender: Optional[str] = None
    dob: Optional[date] = None
    profile_pic: Optional[str] = None


class LoginUser(BaseModel):
    email: EmailStr
    password: str


class ShowUser(BaseModel):
    id: UUID
    first_name: str
    last_name: str
    email: EmailStr
    gender: Optional[str] = None
    dob: Optional[date] = None
    profile_pic: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    model_config = {
        "from_attributes": True
    }


class UpdateDOBGender(BaseModel):
    dob: Optional[date] = None
    gender: Optional[str] = None


class RegisterResponce(BaseModel):
    user: ShowUser
    tokens: TokenResponce


class UpdateProfile(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    dob: Optional[date] = None
    gender: Optional[str] = None
    profile_pic: Optional[str] = None  # store Firebase URL
