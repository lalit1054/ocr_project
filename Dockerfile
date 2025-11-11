# ---- Dockerfile (install dependencies as root, run as non-root) ----
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
      bash \
 && rm -rf /var/lib/apt/lists/*

# Create application directory and non-root user
WORKDIR $APP_HOME
RUN useradd --create-home --shell /bin/bash appuser \
 && chown -R appuser:appuser $APP_HOME

# Copy requirements first (cache layer)
COPY requirements.txt $APP_HOME/requirements.txt

# Install python dependencies AS ROOT so console-scripts install into /usr/local/bin
RUN python -m pip install --upgrade pip setuptools wheel \
 && python -m pip install --no-cache-dir -r $APP_HOME/requirements.txt

# Copy application code and start script
COPY . $APP_HOME
# make sure start.sh is executable
RUN chmod +x $APP_HOME/start.sh \
 && chown -R appuser:appuser $APP_HOME

# Switch to non-root user for runtime
USER appuser

# Expose ports and start
EXPOSE 8000 8501
ENTRYPOINT ["/app/start.sh"]

