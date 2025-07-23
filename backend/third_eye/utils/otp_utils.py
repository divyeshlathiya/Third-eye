import random
import time

otp_store = {}  # for development purpose
verified_emails = set()


def generate_otp(length=6):
    return ''.join(random.sample("0123456789", k=length))


def save_otp(email: str, otp: str, ttl=300):
    otp_store[email] = {"otp": otp, "expires": time.time()+ttl}


def verify_otp(email: str, otp: str):
    record = otp_store.get(email)
    if record and record["otp"] == otp and time.time() < record["expires"]:
        del otp_store[email]
        return True
    return False
