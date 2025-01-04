# Made by Ecys — https://ecys.xyz

#!/bin/bash
# Script for Random Wallpaper (CTRL ALT W)

wallDIR="$HOME/Pictures/wallpapers"
scriptsDir="$HOME/.config/hypr/scripts"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

PICS=($(find ${wallDIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}


# Transition config
FPS=144
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE"


swww query || swww-daemon --format xrgb && swww img -o $focused_monitor ${RANDOMPICS} $SWWW_PARAMS


${scriptsDir}/WallustSwww.sh
sleep 3
${scriptsDir}/RefreshNoWaybar.sh 
