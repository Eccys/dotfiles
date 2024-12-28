#!/bin/bash

# Check if OBS Studio is running
if pgrep -x "obs" > /dev/null; then
    # Get the window ID of OBS Studio
    obs_window_id=$(ydotool search "obs")

    # Check if the OBS window was found
    if [ -z "$obs_window_id" ]; then
        echo "OBS window not found."
        exit 1
    fi

    # Send keypress based on the argument
    if [ "$1" == "start_stop" ]; then
        # Send CTRL+SHIFT+1 to OBS Studio
        ydotool windowfocus $obs_window_id key CTRL+SHIFT+1
    elif [ "$1" == "pause" ]; then
        # Send CTRL+SHIFT+2 to OBS Studio
        ydotool windowfocus $obs_window_id key CTRL+SHIFT+2
    else
        echo "Invalid argument. Use 'start_stop' or 'pause'."
        exit 1
    fi
else
    echo "OBS Studio is not running."
    exit 1
fi
