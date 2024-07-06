# Made by Ecys — https://ecys.xyz

# Made by Ecys — https://ecys.xyz

#!/bin/bash
# Keyhints. Idea got from Garuda Hyprland

# Detect monitor resolution and scale
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# Calculate width and height based on percentages and monitor resolution
width=$((x_mon * hypr_scale / 100))
height=$((y_mon * hypr_scale / 100))

# Set maximum width and height
max_width=1200
max_height=1000

# Set percentage of screen size for dynamic adjustment
percentage_width=70
percentage_height=70

# Calculate dynamic width and height
dynamic_width=$((width * percentage_width / 100))
dynamic_height=$((height * percentage_height / 100))

# Limit width and height to maximum values
dynamic_width=$(($dynamic_width > $max_width ? $max_width : $dynamic_width))
dynamic_height=$(($dynamic_height > $max_height ? $max_height : $dynamic_height))

# Launch yad with calculated width and height
yad --width=$dynamic_width --height=$dynamic_height \
    --center \
    --title="Keybindings" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
"ESC" "Close this menu" "Close current menu" \
"=" "Super Key (Windows Key)" "Open main menu" \
" ENTER" "Terminal" "Launch Kitty terminal" \
" W" "Browser" "Launch Mercury browser" \
" SHIFT ENTER" "Dropdown Terminal" "Launch Kitty-pyprland terminal" \
" A" "Desktop Overview" "Show AGS overview" \
" D" "Application Launcher" "Open Rofi application launcher" \
" T" "File Manager" "Open Thunar file manager" \
" S" "Google Search" "Search with Rofi" \
" Q" "Close active window" "Close current window" \
" Shift Q" "Kill active window" "Kill all window processes" \
" Z" "Desktop Zoom" "Activate desktop zoom" \
" V" "Clipboard Manager" "Open Cliphist clipboard manager" \
" W" "Choose wallpaper" "Open wallpaper menu" \
" Shift W" "Choose wallpaper effects" "Open Imagemagick + swww effects" \
"CTRL ALT W" "Random wallpaper" "Set random wallpaper via swww" \
" B" "Toggle waybar" "Show or hide waybar" \
#" CTRL B" "Choose waybar styles" "Open waybar styles menu" \
#" ALT B" "Choose waybar layout" "Open waybar layout menu" \
" ALT R" "Reload Waybar" "Reload waybar with Swaync Rofi" \
" SHIFT N" "Launch Notification Panel" "Open Swaync Notification Center" \
#" Print" "Screenshot" "Capture screen with Grim" \
#" Shift Print" "Screenshot region" "Capture region with Grim + Slurp" \
" Shift S" "Quick screenshot" "Capture screen with Swappy" \
#" CTRL Print" "Screenshot timer 5 secs" "Capture screen with 5 sec timer" \
#" CTRL SHIFT Print" "Screenshot timer 10 secs" "Capture screen with 10 sec timer" \
#"ALT Print" "Screenshot active window" "Capture active window only" \
"CTRL ALT P" "Power menu" "Open wlogout menu" \
"CTRL ALT L" "Screen lock" "Lock screen with Hyprlock" \
"CTRL ALT Del" "Exit Hyprland" "Exit (save your work)" \
" F" "Fullscreen" "Toggle fullscreen mode" \
" ALT L" "Toggle Hyprland layout" "Switch between Master and Dwindle layout" \
" Shift F" "Toggle float" "Float current window" \
" ALT F" "Toggle float" "Float all windows" \
" Shift B" "Toggle blur" "Adjust window blur" \
" SHIFT G" "Toggle animations" "Toggle window animations for performance" \
" ALT E" "Launch emoji selector" "Open Rofi emoticons" \
" ALT V" "Clipboard Manager" "Open Cliphist clipboard manager" \
" H" "Help menu" "Open this cheatsheet" \
" E" "Edit configuration" "Edit keybinds and settings" \
