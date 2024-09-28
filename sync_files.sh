#!/bin/bash

# Configuration
S3_BUCKET_URL="https://test-stack-bucket-program-agent.s3.eu-west-2.amazonaws.com"
TARGET_DIR="/app/src"
POLL_INTERVAL=5 # seconds

# Files you want to sync (e.g., React build files)
FILES=("react-app-src/App.js" "react-app-src/App.css")

curl -s "$S3_BUCKET_URL/react-app-src/App.js" -o "/app/src/App.js" || echo "Failed to fetch $file"

# Infinite loop to check for updated files
while true; do
    echo "Checking for updates from S3 bucket..."

    curl -s "$S3_BUCKET_URL/react-app-src/App.js" -o "/app/src/App.js" || echo "Failed to fetch $file"

    # Loop through the files you want to sync
    # for file in "${FILES[@]}"; do
    #     echo "Fetching $file from $S3_BUCKET_URL/$file"
        
    #     # Fetch the file and save it to the target directory
    #     curl -s "$S3_BUCKET_URL/$file" -o "$TARGET_DIR/$file" || echo "Failed to fetch $file"
        
    #     # Optionally, use wget instead of curl:
    #     # wget -q "$S3_BUCKET_URL/$file" -O "$TARGET_DIR/$file" || echo "Failed to fetch $file"
    # done

    echo "Files synced. Waiting for the next poll..."
    
    # Wait before checking again
    sleep $POLL_INTERVAL
done
