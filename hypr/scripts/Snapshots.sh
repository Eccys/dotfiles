#!/bin/bash
# Hyprland Snapper Snapshot Script

icon=$HOME/.config/swaync/icons/saved.png

# Directories and commands
notify_cmd="notify-send -h string:x-canonical-private-synchronous:hyprshotted-notify -u low -i $icon"
snap_home="sudo snapper -c home create -d \"Hyprshotted\" --cleanup-algorithm number"
snap_root="sudo snapper -c root create -d \"Hyprshotted\" --cleanup-algorithm number"

# Function to send notifications
send_notification() {
    local snapshot_type="$1"
    local result="$2"

    if [[ "$result" -eq 0 ]]; then
        $notify_cmd "Successfully snapshotted $snapshot_type"
    else
        $notify_cmd "Failed to snapshot $snapshot_type ❌"
    fi
}

# Function to create a snapshot for the 'home' subvolume
create_home_snapshot() {
    eval "$snap_home"
    send_notification "/home" "$?"
}

# Function to create a snapshot for the 'root' subvolume
create_root_snapshot() {
    eval "$snap_root"
    send_notification "/" "$?"
}

# Main script logic to handle arguments
case "$1" in
    "home")
        create_home_snapshot
        ;;
    "root")
        create_root_snapshot
        ;;
    *)
        echo "Usage: $0 {home|root}"
        exit 1
        ;;
esac

