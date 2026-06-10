#!/usr/bin/env bash

# ============================================================================
# 1. ZOMBIE PREVENTION
# Kills any older instances of this script. When Quickshell reloads, 
# it can leave the old listener pipelines running in the background infinitely.
# ============================================================================
for pid in $(pgrep -f "quickshell/workspaces.sh"); do
    if [ "$pid" != "$$" ] && [ "$pid" != "$PPID" ]; then
        kill -9 "$pid" 2>/dev/null
    fi
done

# Clean up any leftover pending file on start
PENDING_FILE="/tmp/qs_ws_pending_$$"
rm -f "$PENDING_FILE"

# Background worker that handles updates with proper debouncing (completely forkless)
# The background worker will be defined and started below print_workspaces
# to ensure it can access the print_workspaces function on start.
WORKER_PID=""


cleanup() {
    rm -f "$PENDING_FILE"
    kill $WORKER_PID 2>/dev/null
    pkill -P $$ 2>/dev/null
}
trap cleanup EXIT SIGTERM SIGINT

# --- Special Cleanup for Network/Bluetooth ---
# The network toggle starts a background bluetooth scan that must be killed explicitly.
BT_PID_FILE="$HOME/.cache/bt_scan_pid"

if [ -f "$BT_PID_FILE" ]; then
    kill $(cat "$BT_PID_FILE") 2>/dev/null
    rm -f "$BT_PID_FILE"
fi

# Ensure bluetooth scan is explicitly turned off (timeout prevents deadlocks on fresh installs)
(timeout 2 bluetoothctl scan off > /dev/null 2>&1) &
# ---------------------------------------------

# Configuration: Parse from settings.json dynamically, fallback to 8
SETTINGS_FILE="$HOME/.config/hypr/settings.json"
SEQ_END=$(jq -r '.workspaceCount // 8' "$SETTINGS_FILE" 2>/dev/null)
# Double check it is a valid integer to prevent jq errors later
if ! [[ "$SEQ_END" =~ ^[0-9]+$ ]]; then
    SEQ_END=8
fi

print_workspaces() {
    # Get raw data with a timeout fallback
    spaces=$(timeout 2 hyprctl workspaces -j 2>/dev/null)
    active=$(timeout 2 hyprctl activeworkspace -j 2>/dev/null | jq '.id')

    # Failsafe if hyprctl crashes to prevent jq from outputting errors
    if [ -z "$spaces" ] || [ -z "$active" ]; then return; fi

    # Generate the JSON and write it atomically to prevent UI flickering
    echo "$spaces" | jq --unbuffered --argjson a "$active" --arg end "$SEQ_END" -c '
        # Create a map of workspace ID -> workspace data for easy lookup
        (map( { (.id|tostring): . } ) | add) as $s
        |
        # Iterate from 1 to SEQ_END
        [range(1; ($end|tonumber) + 1)] | map(
            . as $i |
            # Determine state: active -> occupied -> empty
            (if $i == $a then "active"
             elif ($s[$i|tostring] != null and $s[$i|tostring].windows > 0) then "occupied"
             else "empty" end) as $state |

            # Get window title for tooltip (if exists)
            (if $s[$i|tostring] != null then $s[$i|tostring].lastwindowtitle else "Empty" end) as $win |

            {
                id: $i,
                state: $state,
                tooltip: $win
            }
        )
    ' > /tmp/qs_workspaces.tmp
    
    mv /tmp/qs_workspaces.tmp /tmp/qs_workspaces.json
}

# Background worker that handles updates with proper debouncing (completely forkless)
worker() {
    while true; do
        if [ -f "$PENDING_FILE" ]; then
            if read -r PENDING_TIME < "$PENDING_FILE" 2>/dev/null; then
                NOW=${EPOCHREALTIME//[!0-9]/}
                PENDING_TIME_CLEAN=${PENDING_TIME//[!0-9]/}
                if [ -n "$NOW" ] && [ -n "$PENDING_TIME_CLEAN" ]; then
                    DIFF=$(( NOW - PENDING_TIME_CLEAN ))
                    # 120ms debounce window (120000 microseconds)
                    if [ $DIFF -gt 120000 ]; then
                        rm -f "$PENDING_FILE"
                        print_workspaces
                    fi
                fi
            fi
        fi
        sleep 0.05
    done
}
worker &
WORKER_PID=$!

# Print initial state
print_workspaces

# ============================================================================
# 2. THE EVENT DEBOUNCER
# Listen to Hyprland socket wrapped in an infinite loop
# ============================================================================
while true; do
    socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - 2>/dev/null | while read -r line; do
        case "$line" in
            workspace*|focusedmon*|destroyworkspace*)
                # Instant update for workspace changes!
                rm -f "$PENDING_FILE"
                print_workspaces
                ;;
            activewindow*|createwindow*|closewindow*|movewindow*)
                # Debounce window drag/resize and active window storms
                echo "${EPOCHREALTIME//[!0-9]/}" > "$PENDING_FILE"
                ;;
        esac
    done
    sleep 1
done
