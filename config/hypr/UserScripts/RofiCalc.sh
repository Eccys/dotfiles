# Made by Ecys — https://ecys.xyz

# Made by Ecys — https://ecys.xyz


#!/bin/bash
# /* Calculator (using qalculate) and rofi */

rofi_config="$HOME/.config/rofi/config-calc.rasi"

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
    exit 0
fi

# main function

while true; do
    result=$(
        rofi -i -dmenu \
            -config "$rofi_config" \
            -mesg "$result      =    $calc_result"
    )

    echo "Entered result: $result" # Debug info

    if [ $? -ne 0 ]; then
        echo "Exiting..."
        exit
    fi

    if [ -n "$result" ]; then
        calc_result=$(qalc -t "$result")
        echo "Calculation result: $calc_result" # Debug info
        echo "$calc_result" | wl-copy
    else
        echo "No input detected"
    fi
done
