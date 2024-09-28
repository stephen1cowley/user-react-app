#!/bin/bash

# Configuration
S3_BUCKET="s3://test-stack-bucket-program-agent/react-app-src/"
TARGET_DIR="/app/src"
POLL_INTERVAL=5 # seconds

# Infinite loop to check for updated files in S3
while true; do
    echo "Checking for updates in S3..."

    # Sync updated files from S3 to the local directory inside the container
    aws s3 sync s3://$S3_BUCKET/ $TARGET_DIR

    # Wait for the next check
    sleep $POLL_INTERVAL
done
