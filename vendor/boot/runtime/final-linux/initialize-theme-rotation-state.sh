#!/usr/bin/env bash
# Initialize the 1024-byte GRUB environment block on an already-mounted FAT
# /boot/XBOOTLDR. This does not partition, mount, install GRUB, or edit fstab.
set -euo pipefail

usage() {
    echo "Usage: sudo bash $0 <mounted-vfat-boot> <expected-filesystem-UUID> [seed-cfg]" >&2
    exit 2
}
[ "$#" -ge 2 ] && [ "$#" -le 3 ] || usage
[ "$(id -u)" -eq 0 ] || { echo "Must run as root" >&2; exit 3; }

boot_arg=$1
expected_uuid=$2
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
seed_cfg=${3:-"$script_dir/theme-rotation-seed.cfg"}
selector_cfg="$script_dir/theme-rotation-selector.cfg.in"

[ -d "$boot_arg" ] && mountpoint -q -- "$boot_arg" || { echo "Not a mounted directory: $boot_arg" >&2; exit 3; }
boot=$(readlink -f -- "$boot_arg")
actual_fs=$(findmnt -n -o FSTYPE --target "$boot") || { echo "Cannot identify mounted filesystem" >&2; exit 3; }
actual_uuid=$(findmnt -n -o UUID --target "$boot") || { echo "Cannot identify mounted filesystem UUID" >&2; exit 3; }
case "$actual_fs" in vfat|fat|msdos) ;; *) echo "Expected vfat/FAT; found $actual_fs" >&2; exit 3 ;; esac
[ "${actual_uuid,,}" = "${expected_uuid,,}" ] || { echo "UUID mismatch: expected $expected_uuid, found $actual_uuid" >&2; exit 3; }
[ -r "$seed_cfg" ] && [ -r "$selector_cfg" ] || { echo "Missing seed or selector package file" >&2; exit 4; }
seed_line=$(grep -E "^set rotation_original_seed='[0-8]{512}'$" "$seed_cfg" | head -n 1 || true)
[ -n "$seed_line" ] || { echo "Seed file does not contain a 512-digit 0..8 seed" >&2; exit 4; }
seed=${seed_line#*=}
seed=${seed#\'}
seed=${seed%\'}
[ "${#seed}" -eq 512 ] || { echo "Seed length is not 512" >&2; exit 4; }

dest="$boot/grub"
mkdir -p -- "$dest"
timestamp=$(date -u +%Y%m%dT%H%M%SZ)
backup="$dest/rotation-backup-$timestamp"
mkdir -- "$backup"
for name in theme-rotation.env theme-rotation-seed.cfg theme-rotation-selector.cfg; do
    if [ -e "$dest/$name" ]; then cp -a -- "$dest/$name" "$backup/$name"; fi
done

tmp=$(mktemp -d "$dest/.rotation-init.XXXXXXXX")
cleanup() { rm -rf -- "$tmp"; }
trap cleanup EXIT
printf '# GRUB Environment Block\nrotation_queue=%s\nrotation_current=0\nrotation_version=1\n' "$seed" > "$tmp/theme-rotation.env"
current_size=$(wc -c < "$tmp/theme-rotation.env")
[ "$current_size" -le 1024 ] || { echo "Environment state exceeds 1024 bytes" >&2; exit 5; }
padding=$((1024 - current_size))
if [ "$padding" -gt 0 ]; then head -c "$padding" /dev/zero | tr '\000' '#' >> "$tmp/theme-rotation.env"; fi
[ "$(wc -c < "$tmp/theme-rotation.env")" -eq 1024 ] || { echo "Environment state is not exactly 1024 bytes" >&2; exit 5; }
cp -- "$seed_cfg" "$tmp/theme-rotation-seed.cfg"
cp -- "$selector_cfg" "$tmp/theme-rotation-selector.cfg"

for name in theme-rotation.env theme-rotation-seed.cfg theme-rotation-selector.cfg; do
    install -m 0644 -- "$tmp/$name" "$dest/$name.new"
    mv -f -- "$dest/$name.new" "$dest/$name"
done
echo "Initialized rotation state under $dest (FSTYPE=$actual_fs UUID=$actual_uuid); preserved previous files in $backup"
