#!/usr/bin/env bash

# Shell Toggler for Hyprland

CONFIG_DIR="$HOME/.config/hypr/config"
LINK_TARGET="$CONFIG_DIR/shell.conf"

# Initialize link if it doesn't exist
if [ ! -L "$LINK_TARGET" ] && [ ! -f "$LINK_TARGET" ]; then
    ln -sf "$CONFIG_DIR/shell_modus.conf" "$LINK_TARGET"
fi

CURRENT_TARGET=$(readlink "$LINK_TARGET" || echo "")

if [[ "$CURRENT_TARGET" == *"shell_quickshell.conf"* ]]; then
    # Switch to Modus
    ln -sf "$CONFIG_DIR/shell_modus.conf" "$LINK_TARGET"
    
    # Kill quickshell and related daemons
    pkill -f "quickshell"
    pkill -f "qs_manager.sh"
    pkill -f "focus_daemon.py"
    
    # Reload hyprland to apply new rules, autostarts, and keybinds
    hyprctl reload
    
    notify-send "Shell Switched" "Loaded Modus Shell"
else
    # Switch to Quickshell
    ln -sf "$CONFIG_DIR/shell_quickshell.conf" "$LINK_TARGET"
    
    # Kill Modus and its components
    # Modus sets its proctitle to "Modus"
    killall Modus || pkill -f "python main.py"
    pkill -f "awww-daemon"
    
    # Reload hyprland to apply quickshell config
    hyprctl reload
    
    notify-send "Shell Switched" "Loaded Quickshell"
fi
