# Made by Ecys — https://ecys.xyz

#!/bin/bash
# Screenshots scripts

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts"
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"

# Default save directory
DEFAULT_DIR="$(xdg-user-dir)/Pictures/sss"

# Check if user provided a directory argument
if [ -n "$1" ] && [[ "$1" != "--"* ]]; then
  SAVE_DIR="$1"
  shift
else
  SAVE_DIR="$DEFAULT_DIR"
fi

# Create the directory if it does not exist
mkdir -p "$SAVE_DIR"

# Get current date and time with milliseconds
time=$(date "+%Y-%m-%d-%H-%M-%S-%3N")
file="Screenshot_${time}.png"

active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
active_window_file="Screenshot_${time}_${active_window_class}.png"
active_window_path="${SAVE_DIR}/${active_window_file}"

# Notify and view screenshot
notify_view() {
    if [[ "$1" == "active" ]]; then
        if [[ -e "${active_window_path}" ]]; then
            ${notify_cmd_shot} "Screenshot of '${active_window_class}' Saved."
            "${sDIR}/Sounds.sh" --screenshot
        else
            ${notify_cmd_shot} "Screenshot of '${active_window_class}' not Saved"
            "${sDIR}/Sounds.sh" --error
        fi
    elif [[ "$1" == "swappy" ]]; then
        ${notify_cmd_shot} "Screenshot Captured."
    else
        local check_file="$SAVE_DIR/$file"
        if [[ -e "$check_file" ]]; then
            ${notify_cmd_shot} "Screenshot Saved."
            "${sDIR}/Sounds.sh" --screenshot
        else
            ${notify_cmd_shot} "Screenshot NOT Saved."
            "${sDIR}/Sounds.sh" --error
        fi
    fi
}

# Countdown
countdown() {
    for sec in $(seq $1 -1 1); do
        notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR"/timer.png "Taking shot in : $sec"
        sleep 1
    done
}

# Take screenshots
shotnow() {
    cd ${SAVE_DIR} && grim - | tee "$file" | wl-copy
    sleep 2
    notify_view
}

shot5() {
    countdown '5'
    sleep 1 && cd ${SAVE_DIR} && grim - | tee "$file" | wl-copy
    sleep 1
    notify_view
}

shot10() {
    countdown '10'
    sleep 1 && cd ${SAVE_DIR} && grim - | tee "$file" | wl-copy
    notify_view
}

shotwin() {
    w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
    w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
    cd ${SAVE_DIR} && grim -g "$w_pos $w_size" - | tee "$file" | wl-copy
    notify_view
}

shotarea() {
    tmpfile=$(mktemp)
    grim -g "$(slurp)" - >"$tmpfile"
    if [[ -s "$tmpfile" ]]; then
        wl-copy <"$tmpfile"
        mv "$tmpfile" "$SAVE_DIR/$file"
    fi
    rm "$tmpfile"
    notify_view
}

shotactive() {
    active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
    active_window_file="Screenshot_${time}_${active_window_class}.png"
    active_window_path="${SAVE_DIR}/${active_window_file}"

    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "${active_window_path}"
    sleep 1
    notify_view "active"
}

shotswappy() {
    tmpfile=$(mktemp)
    grim -g "$(slurp)" - >"$tmpfile" && "${sDIR}/Sounds.sh" --screenshot && notify_view "swappy"

    # Use Swappy to annotate the screenshot
    swappy -f "$tmpfile"

    # Move the annotated screenshot to the desired directory with the correct filename
    if [[ -s "$tmpfile" ]]; then
        mv "$tmpfile" "$SAVE_DIR/$file"
    fi

    rm "$tmpfile"
}


if [[ ! -d "$SAVE_DIR" ]]; then
    mkdir -p "$SAVE_DIR"
fi

if [[ "$1" == "--now" ]]; then
    shotnow
elif [[ "$1" == "--in5" ]]; then
    shot5
elif [[ "$1" == "--in10" ]]; then
    shot10
elif [[ "$1" == "--win" ]]; then
    shotwin
elif [[ "$1" == "--area" ]]; then
    shotarea
elif [[ "$1" == "--active" ]]; then
    shotactive
elif [[ "$1" == "--swappy" ]]; then
    shotswappy
else
    echo -e "Available Options : --now --in5 --in10 --win --area --active --swappy"
fi

exit 0

