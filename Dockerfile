FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .
COPY Config/ ./Config/
COPY Modules/ ./Modules/
COPY data/ ./data/
RUN mkdir -p data
EXPOSE 8080
CMD ["python", "main.py"]
