# import random
# import time
# import redis
# from dotenv import load_dotenv
# import os
# from pathlib import Path


# env_path = Path(__file__).parent / ".env"
# load_dotenv(dotenv_path=env_path)

# # Read Redis host and port from env
# REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
# REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
# REDIS_DB = int(os.getenv("REDIS_DB", 0))

# # Connect to Redis (update host/port if needed)
# redis_client = redis.Redis(
#     host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DB, decode_responses=True)

# verified_emails = set()
# reset_verified_emails = set()


# def generate_otp(length=6):
#     """
#     Generate a numeric OTP (allows repeating digits).
#     """
#     return ''.join(random.choices("0123456789", k=length))


# def save_otp(email: str, otp: str, ttl=300):
#     """
#     Save OTP in Redis with TTL (default 5 min).
#     """
#     redis_client.setex(f"otp:{email}", ttl, str(otp))


# def verify_otp(email: str, otp: str):
#     """
#     Verify OTP for an email. Returns True if valid, else False.
#     """
#     stored_otp = redis_client.get(f"otp:{email}")
#     print(f"DEBUG => stored={stored_otp}, provided={otp}")  # Debug log

#     if stored_otp and stored_otp == str(otp):
#         # Delete OTP after successful verification (one-time use)
#         redis_client.delete(f"otp:{email}")
#         return True
#     return False


# def mark_email_verified(email: str, purpose: str, ttl=600):
#     """
#     Mark email as verified in Redis (TTL default 10 min)
#     """
#     key = f"verified_email:{purpose}:{email}"
#     redis_client.setex(key, ttl, "1")


# def is_email_verified(email: str, purpose: str):
#     key = f"verified_email:{purpose}:{email}"
#     return redis_client.get(key) is not None


# def remove_verified_email(email: str, purpose: str):
#     key = f"verified_email:{purpose}:{email}"
#     redis_client.delete(key)


import random
import os
import redis
from dotenv import load_dotenv
from pathlib import Path

# Load environment variables
env_path = Path(__file__).parent / ".env"
load_dotenv(dotenv_path=env_path)

# Connect to Redis
redis_url = os.getenv("REDIS_URL")

if redis_url:
    # Use Render Redis or any Redis URL
    redis_client = redis.from_url(redis_url, decode_responses=True)
else:
    # Fallback for local Redis (e.g., for development)
    REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
    REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
    REDIS_DB = int(os.getenv("REDIS_DB", 0))
    redis_client = redis.Redis(
        host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DB, decode_responses=True
    )

verified_emails = set()
reset_verified_emails = set()

def generate_otp(length=6):
    """Generate a numeric OTP (allows repeating digits)."""
    return ''.join(random.choices("0123456789", k=length))

def save_otp(email: str, otp: str, ttl=300):
    """Save OTP in Redis with TTL (default 5 min)."""
    redis_client.setex(f"otp:{email}", ttl, str(otp))

def verify_otp(email: str, otp: str):
    """Verify OTP for an email. Returns True if valid, else False."""
    stored_otp = redis_client.get(f"otp:{email}")
    print(f"DEBUG => stored={stored_otp}, provided={otp}")
    if stored_otp and stored_otp == str(otp):
        redis_client.delete(f"otp:{email}")
        return True
    return False

def mark_email_verified(email: str, purpose: str, ttl=600):
    """Mark email as verified in Redis (TTL default 10 min)"""
    key = f"verified_email:{purpose}:{email}"
    redis_client.setex(key, ttl, "1")

def is_email_verified(email: str, purpose: str):
    key = f"verified_email:{purpose}:{email}"
    return redis_client.get(key) is not None

def remove_verified_email(email: str, purpose: str):
    key = f"verified_email:{purpose}:{email}"
    redis_client.delete(key)
