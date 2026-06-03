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
    ln -sf "$CONFIG_DIR/submap_modus.conf" "$CONFIG_DIR/submap.conf"
    
    # Kill quickshell and related daemons
    pkill -f "quickshell"
    pkill -f "qs_manager.sh"
    pkill -f "focus_daemon.py"
    pkill -f "settings_watcher.sh"
    
    # Kill quickshell OSD and volume listener
    pkill -f "volume_listener.sh"
    pkill -f "swayosd-server"
    
    # Reload hyprland to apply new rules, autostarts, and keybinds
    hyprctl reload
    
    # Start Modus
    (cd "$HOME/.config/Modus" && source .venv/bin/activate && python main.py) > /tmp/modus.log 2>&1 &
    
    notify-send "Shell Switched" "Loaded Modus Shell" || true
else
    # Switch to Quickshell
    ln -sf "$CONFIG_DIR/shell_quickshell.conf" "$LINK_TARGET"
    ln -sf "$CONFIG_DIR/submap_quickshell.conf" "$CONFIG_DIR/submap.conf"
    
    # Kill Modus and its components
    pkill -f -i "modus"
    pkill -f "python.*main.py"
    
    # Reload hyprland to apply quickshell config
    hyprctl reload
    
    # Start Quickshell
    quickshell -p "$HOME/.config/hypr/scripts/quickshell/Main.qml" &
    quickshell -p "$HOME/.config/hypr/scripts/quickshell/Floating.qml" &
    quickshell -p "$HOME/.config/hypr/scripts/quickshell/Shell.qml" &
    python3 "$HOME/.config/hypr/scripts/quickshell/focustime/focus_daemon.py" &
    "$HOME/.config/hypr/scripts/settings_watcher.sh" &
    
    # Start Quickshell OSD and volume listener
    swayosd-server --top-margin 0.9 --style "$HOME/.config/swayosd/style.css" &
    "$HOME/.config/hypr/scripts/volume_listener.sh" &
    
    notify-send "Shell Switched" "Loaded Quickshell" || true
fi
