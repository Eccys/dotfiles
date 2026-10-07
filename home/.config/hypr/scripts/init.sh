#!/usr/bin/env bash
set -Eeuo pipefail
state="$HOME/.local/state/eccys-wallpaper"
mkdir -p "$state"
image="$state/current.png"
if [[ ! -f "$image" ]]; then
    image="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}/eccys-default.png"
fi
[[ -f "$image" ]] || exit 0
for attempt in {1..40}; do
    if awww query >/dev/null 2>&1; then break; fi
    sleep .25
 done
awww img "$image" --transition-type none
cp "$image" /tmp/lock_bg.png
matugen image "$image" --source-color-index 0
bash "$HOME/.config/hypr/scripts/quickshell/wallpaper/matugen_reload.sh"
