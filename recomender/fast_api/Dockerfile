FROM python:3.10-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY ../src ./../src

# Set Python path
ENV PYTHONPATH=/app

CMD ["uvicorn", "src.api.server:app", "--host", "0.0.0.0", "--port", "8000"]