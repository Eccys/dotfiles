#!/bin/bash

# Directory to save the recordings
SAVE_DIR="$HOME/Pictures/sss/$(date "+%Y-%m")"
mkdir -p "$SAVE_DIR"

# Get current date and time for the filename
time=$(date "+%Y-%m-%d-%H-%M-%S")
file="Recording_${time}.mp4"
file_path="${SAVE_DIR}/${file}"

# Check if wf-recorder is running
if pgrep -x "wf-recorder" > /dev/null; then
    # If running, stop the recording
    pkill wf-recorder
    notify-send "Recording stopped."
else
    # If not running, start the recording
    # Select region using slurp
    region=$(slurp)
    if [ -z "$region" ]; then
        echo "No region selected. Exiting."
        exit 1
    fi

    # Start recording with wf-recorder
    wf-recorder -g "$region" -f "$file_path" &
    notify-send "Recording started."
fi
