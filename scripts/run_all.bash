#!/bin/bash

# Check if PROJECT_DIR is set
if [ -z "$PROJECT_DIR" ]; then
    echo "❌ PROJECT_DIR is not set! Please export it and try again."
    exit 1
fi

# Move to the project directory
cd "$PROJECT_DIR" || { echo "❌ Failed to change to $PROJECT_DIR!"; exit 1; }

# Define the tmux session name based on the project directory
SESSION_NAME=$(basename "$PROJECT_DIR")

# Check if the tmux session already exists and kill it if it does
tmux has-session -t "$SESSION_NAME" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "⚠️  Tmux session $SESSION_NAME already exists. Killing it..."
    tmux kill-session -t "$SESSION_NAME"
fi

# Start existing containers without building
echo "🚀 Starting existing containers without building..."
docker compose up -d

# Check if the containers started successfully
if [ $? -ne 0 ]; then
    echo "❌ Failed to start containers!"
    exit 1
fi

# Create a new tmux session with a single window and split it into 4 panes
echo "🖥  Creating new tmux session with 4 panes: $SESSION_NAME"
tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Rename the single window to "main"
tmux rename-window -t "$SESSION_NAME:0" "main"

# Run interactive bash in the first pane (top-left)
tmux send-keys -t "$SESSION_NAME:0.0" "docker compose exec -it ros_publisher /bin/bash" C-m

# Split horizontally and run interactive bash in the second pane (top-right)
tmux split-window -h -c "$PROJECT_DIR" -t "$SESSION_NAME:0.0" \
    "docker compose exec -it ros_subscriber /bin/bash"

# Split vertically the left pane and run interactive bash (bottom-left)
tmux split-window -v -c "$PROJECT_DIR" -t "$SESSION_NAME:0.0" \
    "docker compose exec -it ros_publisher /bin/bash"

# Split vertically the right pane and run interactive bash (bottom-right)
tmux split-window -v -c "$PROJECT_DIR" -t "$SESSION_NAME:0.1" \
    "docker compose exec -it ros_subscriber /bin/bash"

# Enable mouse mode for easy switching
tmux setw -t "$SESSION_NAME" mouse on
tmux select-layout -t "$SESSION_NAME" tiled  # Arrange panes neatly

# Attach to the tmux session
tmux attach -t "$SESSION_NAME"
