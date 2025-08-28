from fastapi_mail import FastMail, MessageSchema, MessageType
from ..config.email_config import conf


async def send_otp_email(to_email: str, otp: str):
    message = MessageSchema(
        subject="OTP Verification",
        recipients=[to_email],
        template_body={"otp": otp},
        subtype=MessageType.html
    )
    fm = FastMail(config=conf)
    await fm.send_message(message=message, template_name="otp_email.html")
