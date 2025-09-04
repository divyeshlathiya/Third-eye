from pydantic import BaseModel


class TokenRequest(BaseModel):
    id_token: str

class TokenResponce(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"