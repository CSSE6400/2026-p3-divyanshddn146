# 1. Use a lightweight Python base image
FROM python:3.13-slim

# 2. Install system dependencies (pipx for managing poetry)
RUN apt-get update && apt-get install -y pipx && \
    pipx ensurepath

# 3. Install Poetry via pipx
RUN pipx install poetry

# 4. Set the working directory inside the container
WORKDIR /app

# 5. Optimization: Copy only dependency files first
# This ensures that if you change your code, Docker doesn't 
# have to re-download all your libraries.
COPY pyproject.toml ./
RUN pipx run poetry install --no-root

# 6. Copy your application source code
COPY todo todo

# 7. The "On-Switch"
# We add a 10-second sleep to give the PostgreSQL database 
# time to "wake up" before the Flask app tries to connect.
CMD ["bash", "-c", "sleep 5 && pipx run poetry run flask --app todo run --host 0.0.0.0 --port 6400"]