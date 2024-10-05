# Use an official Python runtime as a parent image
FROM python:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container
COPY . .

# Define the command to run the application
# CMD ["python", "latex-to-text.py"]
