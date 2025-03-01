#!/bin/bash

# Determine the script's directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Set the project directory environment variable
export NIMBRO_PROJECT_DIR="$PROJECT_DIR"

# Add the scripts directory to the PATH
export PATH="$SCRIPT_DIR:$PATH"

# Print confirmation
echo "NIMBRO_PROJECT_DIR set to $NIMBRO_PROJECT_DIR"
echo "Scripts directory added to PATH: $SCRIPT_DIR"
