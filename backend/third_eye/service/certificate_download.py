import io
import os
import requests
from fastapi import Depends, HTTPException, APIRouter
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from PIL import Image, ImageDraw, ImageFont, UnidentifiedImageError

from third_eye.service.auth_service import get_current_user
from ..database.database import get_db
from ..models.user import User

router = APIRouter(prefix="/api/auth", tags=["Certificate"])


def generate_certificate(template_path, profile_url, name, output_path):
    try:
        # Load certificate template
        cert_template = Image.open(template_path).convert("RGBA")
    except FileNotFoundError:
        raise HTTPException(
            status_code=500, detail="Certificate template not found")
    except UnidentifiedImageError:
        raise HTTPException(
            status_code=500, detail="Invalid certificate template image")

    # Load profile image (from URL)
    if profile_url:
        try:
            resp = requests.get(profile_url, timeout=10)
            resp.raise_for_status()
            profile = Image.open(io.BytesIO(resp.content)).convert("RGBA")
            profile = profile.resize((265, 250))

            # Circular mask
            mask = Image.new("L", profile.size, 0)
            draw_mask = ImageDraw.Draw(mask)
            draw_mask.ellipse(
                (0, 0, profile.size[0], profile.size[1]), fill=255)

            # Paste profile at desired position
            cert_template.paste(profile, (550, 330), mask)
        except (requests.RequestException, UnidentifiedImageError):
            raise HTTPException(
                status_code=400, detail="Failed to load user profile picture")

    # Add name text
    try:
        draw = ImageDraw.Draw(cert_template)

        # Use bundled font (relative path inside your project)
        font_path = os.path.join("third_eye", "fonts", "arial.ttf")
        if not os.path.exists(font_path):
            raise HTTPException(
                status_code=500, detail="Font file missing in server deployment"
            )

        font = ImageFont.truetype(font_path, 60)
        draw.text((700, 1080), name, fill="white", font=font, anchor="mm")
    except OSError as e:
        raise HTTPException(
            status_code=500, detail=f"Font file not found or invalid: {str(e)}"
        )

    try:
        # Save certificate
        cert_template.save(output_path, "PNG")
    except Exception:
        raise HTTPException(
            status_code=500, detail="Failed to generate certificate")

    return output_path


@router.get("/certificate")
def get_certificate(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    name = f"{user.first_name} {user.last_name}"

    # Paths
    template_path = "third_eye/Certificate_temp.png"
    output_path = f"third_eye/{user.id}_certificate.png"

    # Generate certificate
    output_file = generate_certificate(
        template_path, user.profile_pic, name, output_path)

    # Return downloadable file
    return FileResponse(output_file, media_type="image/png", filename="certificate.png")



# @router.get("/certificate")
# def get_certificate(access_token: str = Query(...), db: Session = Depends(get_db)):
#     try:
#         # Authenticate user
#         user = get_current_user(access_token, db)
#         if not user:
#             raise HTTPException(status_code=404, detail="User not found")

#         name = f"{user.first_name} {user.last_name}"

#         # Paths
#         template_path = "third_eye/Certificate_temp.png"
#         output_path = f"third_eye/{user.id}_certificate.png"

#         # Generate certificate
#         output_file = generate_certificate(template_path, user.profile_pic, name, output_path)

#         # Return downloadable file
#         return FileResponse(output_file, media_type="image/png", filename="certificate.png")

#     except HTTPException as e:
#         # Pass through raised exceptions
#         raise e
#     except Exception as e:
#         # Catch any unexpected error
#         raise HTTPException(status_code=500, detail=f"Unexpected error: {str(e)}")
