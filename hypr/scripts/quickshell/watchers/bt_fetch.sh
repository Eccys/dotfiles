#!/usr/bin/env bash

# Check if bluetoothctl is even available
if ! command -v bluetoothctl &>/dev/null; then
    echo '{"status":"off","icon":"󰂲","connected":"Off"}'
    exit 0
fi

get_bt_status() {
    local bt_info=$(timeout 0.3 bluetoothctl show 2>/dev/null)
    if [[ -z "$bt_info" || ! "$bt_info" =~ "Powered: yes" ]]; then
        echo "off"
    else
        echo "on"
    fi
}

toggle_bt() {
    if [ "$(get_bt_status)" = "on" ]; then
        LC_ALL=C timeout 0.5 bluetoothctl power off 2>/dev/null
        notify-send -u low -i bluetooth-disabled "Bluetooth" "Disabled"
    else
        LC_ALL=C timeout 0.5 bluetoothctl power on 2>/dev/null
        notify-send -u low -i bluetooth-active "Bluetooth" "Enabled"
    fi
}

case $1 in
    --toggle) toggle_bt ;;
    *)
        bt_info=$(timeout 0.3 bluetoothctl show 2>/dev/null)
        if [[ -z "$bt_info" || ! "$bt_info" =~ "Powered: yes" ]]; then
            echo '{"status":"off","icon":"󰂲","connected":"Off"}'
            exit 0
        fi

        connected_dev=$(timeout 0.3 bluetoothctl devices Connected 2>/dev/null | head -n1 | cut -d' ' -f3-)
        if [[ -n "$connected_dev" ]]; then
            echo "{\"status\":\"on\",\"icon\":\"󰂱\",\"connected\":\"$connected_dev\"}"
        else
            echo '{"status":"on","icon":"󰂯","connected":"Disconnected"}'
        fi
        ;;
esac


