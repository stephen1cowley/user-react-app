#!/bin/sh

# Configuration
S3_BUCKET_URL="https://test-stack-bucket-program-agent.s3.eu-west-2.amazonaws.com"
TARGET_DIR="/app/src"
POLL_INTERVAL=5 # seconds

# Files you want to sync (e.g., React build files)
FILE1="react-app-src/App.js"
FILE2="react-app-src/App.css"

# Fetch the initial file
curl -s "$S3_BUCKET_URL/$FILE1" -o "$TARGET_DIR/App.js" || echo "Failed to fetch $FILE1"

# Infinite loop to check for updated files
while true; do
    echo "Checking for updates from S3 bucket..."

    # Fetch each file individually
    for file in "$FILE1" "$FILE2"; do
        echo "Fetching $file from $S3_BUCKET_URL/$file"

        # Fetch the file and save it to the target directory
        curl -s "$S3_BUCKET_URL/$file" -o "$TARGET_DIR/$(basename $file)" || echo "Failed to fetch $file"
    done

    echo "Files synced. Waiting for the next poll..."

    # Wait before checking again
    sleep $POLL_INTERVAL
done
