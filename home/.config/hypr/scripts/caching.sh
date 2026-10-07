#!/usr/bin/env bash
# Cache interface restored from ilyamiro/imperative-dots for eccys widgets.
export QS_CACHE_DIR="$HOME/.cache/quickshell"
export QS_STATE_DIR="$HOME/.local/state/quickshell"
export QS_RUN_DIR="${XDG_RUNTIME_DIR:-/tmp}/quickshell"
export QS_LOG_DIR="$QS_RUN_DIR/logs"
mkdir -p "$QS_CACHE_DIR" "$QS_STATE_DIR" "$QS_RUN_DIR" "$QS_LOG_DIR"

qs_ensure_cache() {
    local widget="$1" upper
    upper="${widget^^}"
    mkdir -p "$QS_CACHE_DIR/$widget" "$QS_STATE_DIR/$widget" "$QS_RUN_DIR/$widget"
    export "QS_CACHE_${upper}=$QS_CACHE_DIR/$widget"
    export "QS_STATE_${upper}=$QS_STATE_DIR/$widget"
    export "QS_RUN_${upper}=$QS_RUN_DIR/$widget"
}

QS_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/quickshell"
for directory in "$QS_DIR"/*/; do
    [[ -d "$directory" ]] && qs_ensure_cache "$(basename "$directory")"
done
