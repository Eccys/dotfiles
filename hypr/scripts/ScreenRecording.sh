#!/bin/bash

# Directory to save the recordings
SAVE_DIR="$HOME/Pictures/sss/$(date "+%Y-%m")"
mkdir -p "$SAVE_DIR"

# Get current date and time for the filename
time=$(date "+%Y-%m-%d-%H-%M-%S")
file="Recording_${time}.mp4"
file_path="${SAVE_DIR}/${file}"

# Default audio option is false
AUDIO=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --audio)
            AUDIO="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

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

    # Start recording with or without audio based on the argument
    if [[ "$AUDIO" == "true" ]]; then
        wf-recorder -g "$region" -f "$file_path" --audio -c libx264rgb &
        notify-send "Recording started with audio."
    else
        wf-recorder -g "$region" -f "$file_path" &
        notify-send "Recording started without audio."
    fi
fi
