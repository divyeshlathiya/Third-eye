from pydantic import BaseModel, EmailStr
from typing import Literal


class OtpRequest(BaseModel):
    email: EmailStr
    purpose: Literal["signup", "reset"]


class OtpVerifyRequest(BaseModel):
    email: EmailStr
    otp: str
    purpose: Literal["signup", "reset"]
