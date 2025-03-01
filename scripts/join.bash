#!/bin/bash

# Ensure the project directory is set
if [ -z "$NIMBRO_PROJECT_DIR" ]; then
    echo "Please source setup.bash first!"
    exit 1
fi

echo "Checking if the ros_build container is running..."

# Check if the ros_build container is running
if ! docker ps --filter "name=ros_build" --format "{{.Names}}" | grep -q "ros_build"; then
    echo "ros_build container is not running. Starting it..."
    docker compose run --rm -d ros_build
    echo "ros_build container started."
else
    echo "ros_build container is already running."
fi

# Join the ros_build container
echo "Joining the ros_build container..."
docker compose exec ros_build bash
