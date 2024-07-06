# Made by Ecys — https://ecys.xyz

# Made by Ecys — https://ecys.xyz

#!/bin/bash
# source https://wiki.archlinux.org/title/Hyprland#Using_a_script_to_change_wallpaper_every_X_minutes

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals.
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

wallust_refresh=$HOME/.config/hypr/scripts/RefreshNoWaybar.sh
scriptsdir=$HOME/.config/hypr/scripts/WallustSwww.sh
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
    echo "Usage:
    $0 $HOME/Pictures/wallpapers"
    exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_TYPE=any
#export SWWW_TRANSITION_STEP=1
# This controls (in seconds) when to switch to the next image
INTERVAL=60

while true; do
    find "$1" -type f | shuf -n 1 | while read -r img; do
        swww img -o $focused_monitor "$img"
	$scriptsdir/WallustSwww.sh
        $wallust_refresh
        sleep $INTERVAL
    done
done
