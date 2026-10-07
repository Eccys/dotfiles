#!/usr/bin/env bash
# Compatibility entrypoint: current capture workflow is owned by snapx-workflow.
set -eu
mode=region
args=()
while (( $# )); do
    case "$1" in
        --full) mode=full; shift ;;
        --edit) args+=(--edit); shift ;;
        --record) mode=record; shift ;;
        --scan-qr) mode=qr; shift ;;
        --geometry) args+=(--geometry "$2"); shift 2 ;;
        --desk-vol|--desk-mute|--mic-vol|--mic-mute|--mic-dev|--backend|--monitor) shift 2 ;;
        *) shift ;;
    esac
done
exec "$HOME/.local/bin/snapx-workflow" "$mode" "${args[@]}"
