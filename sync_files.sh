#!/bin/sh

# Configuration
S3_BUCKET_URL="https://test-stack-bucket-program-agent.s3.eu-west-2.amazonaws.com"
TARGET_DIR="/app/src"
POLL_INTERVAL=2 # seconds

# Files you want to sync (e.g., React build files)
FILE1="uploads/admin2/App.js"
FILE2="uploads/admin2/App.css"

# Fetch the initial file and save it as a baseline
curl -s "$S3_BUCKET_URL/$FILE1" -o "$TARGET_DIR/App.js" || echo "Failed to fetch $FILE1"
curl -s "$S3_BUCKET_URL/$FILE2" -o "$TARGET_DIR/App.css" || echo "Failed to fetch $FILE2"

# Store checksums of the initial files
CHECKSUM_FILE1=$(md5sum "$TARGET_DIR/App.js" | awk '{ print $1 }')
CHECKSUM_FILE2=$(md5sum "$TARGET_DIR/App.css" | awk '{ print $1 }')

# Infinite loop to check for updated files
while true; do
    echo "Checking for updates from S3 bucket..."

    # Fetch each file and calculate the checksum
    for file in "$FILE1" "$FILE2"; do
        echo "Fetching $file from $S3_BUCKET_URL/$file"
        TEMP_FILE="/tmp/$(basename $file)"

        # Fetch the file into a temporary location
        curl -s "$S3_BUCKET_URL/$file" -o "$TEMP_FILE" || {
            echo "Failed to fetch $file"
            continue
        }

        # Calculate the checksum of the downloaded file
        NEW_CHECKSUM=$(md5sum "$TEMP_FILE" | awk '{ print $1 }')
        
        # Compare checksums and copy only if different
        if [ "$file" = "$FILE1" ]; then
            if [ "$NEW_CHECKSUM" != "$CHECKSUM_FILE1" ]; then
                mv "$TEMP_FILE" "$TARGET_DIR/App.js"
                CHECKSUM_FILE1=$NEW_CHECKSUM
                echo "$FILE1 updated."
            else
                rm "$TEMP_FILE"  # Remove temp file if no update
                echo "$FILE1 not updated."
            fi
        elif [ "$file" = "$FILE2" ]; then
            if [ "$NEW_CHECKSUM" != "$CHECKSUM_FILE2" ]; then
                mv "$TEMP_FILE" "$TARGET_DIR/App.css"
                CHECKSUM_FILE2=$NEW_CHECKSUM
                echo "$FILE2 updated."
            else
                rm "$TEMP_FILE"  # Remove temp file if no update
                echo "$FILE2 not updated."
            fi
        fi
    done

    echo "Files checked. Waiting for the next poll..."

    # Wait before checking again
    sleep $POLL_INTERVAL
done
