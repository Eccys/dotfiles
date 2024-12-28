#!/bin/bash

# Function to press and release keys using ydotool
press_key() {
    ydotool key "$1:1"  # Press key
    ydotool key "$1:0"  # Release key
}

# Function to type Unicode using Ctrl + Shift + U
type_unicode() {
    local unicode_code="$1"  # Unicode code point passed as argument

    # Press Ctrl + Shift + U to open the Unicode input dialog
    ydotool key 29:1  # Press Ctrl
    ydotool key 42:1  # Press Shift
    ydotool key 22:1  # Press U

    ydotool key 29:0  # Release Ctrl
    ydotool key 42:0  # Release Shift
    ydotool key 22:0  # Release U

    # Type the Unicode code (hexadecimal)
    ydotool type "$unicode_code"

    # Press Enter
    ydotool key 28:1 28:0
}

# Check if the user passed an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <unicode_code>"
    exit 1
fi

# Call the function with the input Unicode code
type_unicode "$1"
