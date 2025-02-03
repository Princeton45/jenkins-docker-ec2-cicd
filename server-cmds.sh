#!/usr/bin/env bash

# Check if IMAGE_NAME is provided
if [ -z "$IMAGE_NAME" ]; then
    echo "Error: IMAGE_NAME not provided"
    exit 1
fi

# Export the IMAGE_NAME for docker-compose to use
export IMAGE_NAME

# Pull the image first
docker pull $IMAGE_NAME

# Bring down existing services to ensure a clean state
docker-compose -f docker-compose.yaml down

# Start services
docker-compose -f docker-compose.yaml up -d

# Check if services are running
docker-compose -f docker-compose.yaml ps

# Optional: Show logs to verify
docker-compose -f docker-compose.yaml logs