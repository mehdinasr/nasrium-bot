# NASRIUM Dockerfile - Python API + Bot
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first (for caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY main.py .
COPY Config/ ./Config/
COPY Modules/ ./Modules/
COPY data/ ./data/

# Create data directory
RUN mkdir -p data

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD python -c \"import urllib.request; urllib.request.urlopen('http://localhost:8080/')\" || exit 1

# Run application
CMD [\"python\", \"main.py\"]
