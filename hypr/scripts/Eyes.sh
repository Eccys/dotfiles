#!/bin/bash

# Define the D-Bus service and object paths
DBUS_SERVICE="rs.wl-gammarelay"
DBUS_OBJECT="/rs/wl/gammarelay"

# Function to get the current temperature
get_current_temperature() {
    busctl --user get-property $DBUS_SERVICE $DBUS_OBJECT Temperature | awk '{print $2}'
}

# Function to send a notification with the current temperature
send_notification() {
    local temperature=$1
    notify-send "Screen Color Temperature" "Current temperature: ${temperature}K"
}

# Ensure an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 --inc | --dec"
    exit 1
fi

# Adjust temperature based on the argument
case "$1" in
    --inc)
        busctl --user call $DBUS_SERVICE $DBUS_OBJECT rs.wl.gammarelay UpdateTemperature n 500
        ;;
    --dec)
        busctl --user call $DBUS_SERVICE $DBUS_OBJECT rs.wl.gammarelay UpdateTemperature n -- -500
        ;;
    *)
        echo "Invalid argument: $1"
        echo "Usage: $0 --inc | --dec"
        exit 1
        ;;
esac

# Wait a moment for the change to take effect
sleep 0.5

# Get the new temperature
new_temp=$(get_current_temperature)

# Send a notification with the new temperature
send_notification "$new_temp"
