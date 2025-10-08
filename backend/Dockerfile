# Use official slim Python image
FROM python:3.11-slim-bookworm

# Prevent Python from writing pyc files & buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set working directory inside container
WORKDIR /app

# Install system dependencies needed for building Python packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker cache
COPY requirements.txt .

# Upgrade pip and install dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy application code
COPY third_eye/ /app/third_eye/

# Copy .env explicitly (important for FastAPI environment variables)
COPY .env /app/.env

# Create non-root user and give permissions
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Expose FastAPI port
EXPOSE 8000

# Use Gunicorn + Uvicorn worker for production
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "third_eye.main:app", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "120"]
