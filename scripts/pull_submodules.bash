#!/bin/bash

# Ensure the project directory is set
if [ -z "$NIMBRO_PROJECT_DIR" ]; then
    echo "Please source setup.bash first!"
    exit 1
fi

echo "Pulling the latest changes for submodules in $NIMBRO_PROJECT_DIR..."

# Go to the project directory
cd "$NIMBRO_PROJECT_DIR"

# Initialize and update submodules
git submodule init
git submodule update --remote --recursive

echo "Submodules updated successfully!"
