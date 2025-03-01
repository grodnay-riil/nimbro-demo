#!/bin/bash

# Ensure the project directory is set
if [ -z "$NIMBRO_PROJECT_DIR" ]; then
    echo "Please source setup.bash first!"
    exit 1
fi

echo "Joining the ros_build container for project at $NIMBRO_PROJECT_DIR..."
cd "$NIMBRO_PROJECT_DIR"
docker compose exec ros_build bash

