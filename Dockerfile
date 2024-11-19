# Base image
FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Copy dependency list and install dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files into the container
COPY . .

# Expose the application port
EXPOSE 8000

# Default command to migrate and run the server
CMD ["sh", "-c", "python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000"]
