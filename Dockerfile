# ---- Dockerfile (uses external requirements.txt and start.sh) ----
FROM python:3.11-slim

LABEL maintainer="you@example.com"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FASTAPI_PORT=8000 \
    STREAMLIT_PORT=8501 \
    APP_HOME=/app

# Install system packages required for Pillow, pdf2image, and builds
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      poppler-utils \
      libjpeg-dev \
      zlib1g-dev \
      libgl1 \
      wget \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Create application directory
WORKDIR $APP_HOME

# Create a non-root user to run the app
RUN useradd --create-home --shell /bin/bash appuser \
 && chown -R appuser:appuser $APP_HOME

# Copy requirements first to leverage Docker layer caching
COPY --chown=appuser:appuser requirements.txt $APP_HOME/requirements.txt

# Install python dependencies as non-root user
USER appuser
RUN python -m pip install --upgrade pip setuptools wheel \
 && pip install --no-cache-dir -r requirements.txt

# Copy application code and start script
# Ensure start.sh exists and has executable permission
COPY --chown=appuser:appuser . $APP_HOME
RUN chmod +x $APP_HOME/start.sh

# Expose ports for FastAPI and Streamlit
EXPOSE 8000 8501

# Use start.sh as entrypoint
ENTRYPOINT ["/app/start.sh"]

