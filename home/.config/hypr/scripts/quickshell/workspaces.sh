#!/usr/bin/env bash
set -u
# One event listener writes per-monitor workspace state for both bars.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/eccys-workspaces.lock"
flock -n 9 || exit 0
print_workspaces() {
    local monitors spaces
    monitors=$(hyprctl -j monitors) || return
    spaces=$(hyprctl -j workspaces) || return
    jq -cn --argjson monitors "$monitors" --argjson spaces "$spaces" '
      ($spaces | map({key:(.id|tostring), value:.}) | from_entries) as $lookup |
      reduce $monitors[] as $monitor ({};
        .[$monitor.name] = [range(1;6) | . as $slot |
          ($slot + (if $monitor.name == "HDMI-A-4" then 5 else 0 end)) as $id |
          {id:$slot, state:(if $monitor.activeWorkspace.id == $id then "active"
             elif (($lookup[$id|tostring].windows // 0) > 0) then "occupied" else "empty" end),
           tooltip:($lookup[$id|tostring].lastwindowtitle // "Empty")}])
    ' > /tmp/qs_workspaces.json
}
print_workspaces
while IFS= read -r event; do
    case "$event" in
      workspace*|focusedmon*|createworkspace*|destroyworkspace*|openwindow*|closewindow*|movewindow*|activewindow*|monitor*) print_workspaces ;;
    esac
done < <(socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" -)
