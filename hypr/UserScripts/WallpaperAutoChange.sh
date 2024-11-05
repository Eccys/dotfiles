#!/bin/bash

# Made by Ecys — https://ecys.xyz
# source https://wiki.archlinux.org/title/Hyprland#Using_a_script_to_change_wallpaper_every_X_minutes

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals.
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

wallust_refresh="$HOME/.config/hypr/scripts/RefreshNoWaybar.sh"
scriptsDir="$HOME/.config/hypr/scripts"
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
notif="$HOME/.config/swaync/images/bell.png"

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
    echo "Usage:
    $0 $HOME/Pictures/wallpapers"
    exit 1
fi

# swww transition config
FPS=144
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE"

ENABLED=false

# This controls (in seconds) when to switch to the next image
INTERVAL=60

# Lock file to manage the slideshow state
lock_file="/tmp/wallpaper_slideshow.lock"

# Function to start the wallpaper slideshow
start_slideshow() {
    echo "Starting wallpaper slideshow..."
    notify-send -e -u low -i "$notif" "Wallpaper Slideshow Enabled"
    touch "$lock_file"
    while [[ -f $lock_file ]]; do
        find "$1" -type f | shuf -n 1 | while read -r img; do
            swww img -o $focused_monitor "$img" $SWWW_PARAMS
            $scriptsDir/WallustSwww.sh
            $scriptsDir/RefreshNoWaybar.sh
            sleep $INTERVAL
        done
    done
}

# Function to stop the wallpaper slideshow
stop_slideshow() {
    echo "Stopping wallpaper slideshow..."
    notify-send -e -u low -i "$notif" "Wallpaper Slideshow Disabled"
    rm -f "$lock_file"
}

# Main logic to toggle slideshow
if [[ -f $lock_file ]]; then
    stop_slideshow
else
    start_slideshow "$1" &
fi
