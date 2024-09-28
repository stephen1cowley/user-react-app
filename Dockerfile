# Base image: Node.js (adjust version as needed)
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
# This allows Docker to cache npm install step, improving build times when dependencies haven't changed
COPY package*.json ./

# Install dependencies (this only happens once at container startup)
RUN npm install

# Copy the rest of your application code
COPY . .

# Make the sync script executable
RUN chmod +x /app/sync_files.sh

# Install AWS CLI (if not included in the base image)
RUN apt-get update && \
    apt-get install -y unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Expose the port the app runs on (e.g., 3000 for React apps)
EXPOSE 3000

# Command to run both the sync_files.sh script and npm start
# /app/sync_files.sh will run in the background with `&`, and npm start will run in the foreground.
CMD ["/bin/sh", "-c", "/app/sync_files.sh & npm start"]
