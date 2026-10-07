#!/usr/bin/env bash
# Explicitly target the current output to avoid automatic effects-chain routing.
volume="${1:-0.35}"
sound_file="$2"
output_name=$(wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | sed -n 's/^[[:space:]]*\**[[:space:]]*node.name = "\([^"]*\)"$/\1/p' | head -n 1)
if [[ -n "$output_name" ]]; then
    exec pw-play --target="$output_name" --volume="$volume" "$sound_file"
fi
exec pw-play --volume="$volume" "$sound_file"
