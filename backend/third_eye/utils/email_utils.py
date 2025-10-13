import os
import asyncio
from mailjet_rest import Client

api_key = os.getenv("MAILJET_API_KEY")
api_secret = os.getenv("MAILJET_SECRET_KEY")
mail_from = os.getenv("MAIL_FROM")
mail_from_name = os.getenv("MAIL_FROM_NAME", "Third Eye")

client = Client(auth=(api_key, api_secret), version='v3.1')

async def send_otp_email(to_email: str, otp: str):
    data = {
        'Messages': [
            {
                "From": {
                    "Email": mail_from,
                    "Name": mail_from_name
                },
                "To": [
                    {"Email": to_email, "Name": "User"}
                ],
                "Subject": "Your Third Eye OTP Code 🔑",
                "HTMLPart": f"""
                    <h3>OTP Verification</h3>
                    <p>Your OTP is: <b>{otp}</b></p>
                    <p>This code expires in 5 minutes.</p>
                """
            }
        ]
    }

    # Run blocking Mailjet call in a thread so FastAPI doesn’t freeze
    result = await asyncio.to_thread(client.send.create, data=data)

    if result.status_code not in (200, 201):
        raise Exception(f"Email sending failed: {result.text}")


# from fastapi_mail import FastMail, MessageSchema, MessageType
# from ..config.email_config import conf


# async def send_otp_email(to_email: str, otp: str):
#     message = MessageSchema(
#         subject="OTP Verification",
#         recipients=[to_email],
#         template_body={"otp": otp},
#         subtype=MessageType.html
#     )
#     fm = FastMail(config=conf)
#     await fm.send_message(message=message, template_name="otp_email.html")
