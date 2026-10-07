#!/usr/bin/env bash
set -Eeuo pipefail
slot="${1:-1}"
mode="${2:-switch}"
monitor="${3:-$(hyprctl -j monitors | jq -r '.[] | select(.focused) | .name')}"
if [[ "$slot" == previous ]]; then
    hyprctl dispatch workspace previous_per_monitor
    exit
fi
[[ "$slot" =~ ^[1-5]$ ]] || exit 2
offset=0
[[ "$monitor" == HDMI-A-4 ]] && offset=5
workspace=$((slot + offset))
quickshell -p "$HOME/.config/hypr/scripts/quickshell/Shell.qml" ipc call main handleCommand close '' '' >/dev/null 2>&1 || true
case "$mode" in
    switch) hyprctl --batch "dispatch focusmonitor $monitor; dispatch workspace $workspace" ;;
    move) hyprctl dispatch movetoworkspace "$workspace" ;;
    silent) hyprctl dispatch movetoworkspacesilent "$workspace" ;;
    *) exit 2 ;;
esac
