#!/bin/bash

icon="$HOME/.config/swaync/icons/dropper.png"
notification_timeout=3000

notify_user() {
    local color="$1"
    notify-send -e -u low -i "$icon" "Color picked: $color"
}

pick_color() {
    hyprpicker -f hex | tr -d '\n'
}

main() {
    local color
    color=$(pick_color)

    if [ -z "$color" ]; then
        notify-send -e -u low -i "$icon" "No color picked."
        exit 1
    fi

    notify_user "$color"
}

main
