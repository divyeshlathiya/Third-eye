from pydantic import BaseModel, EmailStr


class CreateUser(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    password: str


class LoginUser(BaseModel):
    email: EmailStr
    password: str


class ShowUser(BaseModel):
    id: int
    first_name: str
    last_name: str
    email: EmailStr

    class Config:
        from_attributes = True
