# System, storage and hardware

The captured host uses Intel CPU/microcode, NVIDIA with nvidia-open, Hyprland on Wayland, an LG 2560x1440 239.97 Hz display on DP-3 and a portrait Dell 1920x1080 60 Hz display on HDMI-A-4 to its left. `home/.config/hypr/config/monitors.conf` preserves this layout and ten persistent workspaces. Change connector names/modes for other hardware. The fallback monitor rule lets other connected outputs start.

`packages/official.txt` and `aur.txt` are explicit install targets; dependencies are resolved by pacman/makepkg. Installed versions are an audit baseline. Checked-in AUR recipes retain their checksums and source URLs; VCS recipes are pinned where the installed source commit was available. Official packages track rolling Arch. Review AUR recipes before changing them; do not run makepkg as root. The custom desktop package overlays current patches onto pinned Serpantinum sources/assets. Its scripts resolve their installed package directory and use your login home's settings/state. Local upstream update scripts are included for fidelity; use this repo/package when upgrading to preserve patches.

Safe system settings are under `system/etc`. Only the restore.py allowlist is applied. pacman.conf, mkinitcpio.conf, locale.gen/locale.conf and vconsole.conf are references for adapting an existing installation. Generate desired locales explicitly with locale-gen. The installer enables multilib without replacing mirrors. It installs the current SDDM Material You theme, preserves keyd Caps/Esc swap and enables NetworkManager, Bluetooth, keyd and SDDM. A narrow sudo rule permits only the two exact manual snapshot commands and the root credential-macro updater; the old host's blanket passwordless sudo is not reproduced.

## Btrfs/Snapper

Prepare Btrfs root and home before running `--only snapshots`. The source layout was:

| Mount | Subvolume |
|---|---|
| / | @ |
| /home | @home |
| /.snapshots | @snapshots |
| /home/.snapshots | @home_snapshots |
| /var/log | @var_log |

The snapshot subvolumes are independently mounted. An ordinary layout where snapper creates nested `.snapshots` is also supported. The installer checks Btrfs, creates missing configurations without deleting existing mounted snapshot subvolumes, installs the saved root/home retention policies, registers both names, enables timeline and cleanup timers, and creates an actual verification snapshot for each. Existing subvolumes/configs are preserved with backups. `snap-pac` provides pre/post pacman transaction snapshots; timeline snapshots cover root and home. Snap-pac defaults to root transaction snapshots.

Use target-specific UUIDs in fstab/crypttab. Existing encryption and boot configuration are prerequisites. This repo does not repartition/reformat storage or overwrite a boot loader. Snapshots are not off-device backups. Recovery requires bootable rescue media or a verified boot-loader snapshot integration; no automatic GRUB rollback integration is claimed.

## Boot and Windows

The source has encrypted Linux, an EFI boot partition and dual-boot Windows. Its GRUB config includes machine-specific crypto/UUID arguments, Windows as default and a ten-theme rotation. Keep `/etc/default/grub`, `/etc/grub.d/08_archprep_theme_rotation`, `/etc/grub.d/09_archprep_windows`, `/boot/grub/themes` and EFI contents in the private host backup if restoring this exact computer. Regenerate initramfs/GRUB only after adapting target UUIDs and checking the boot setup. Boot theme templates are retained under vendor/boot for inspection and adaptation; never apply them blindly.

The existing Windows NTFS source is mounted at `/mnt/windows-c`. For a writable shared Steam library, Windows must be fully shut down with Fast Startup disabled. Choose your actual Windows partition's UUID and user uid/gid; source used ntfs-3g, windows_names,norecover,nofail. Keep Windows compatdata on the Linux filesystem. Game downloads and saves require the private backup/existing Windows library.

## Device/app limitations retained from current setup

Lian Li daemon/config/template/background are included. Two exhaust fans use the CPU curve; three bottom fans use GPU; the rear group has a saved CPU curve but remains configured full duty and absent from discovery. That fault existed at capture time. Do not claim restoring the config recovers its telemetry/control. Device permissions are provided by the package's udev rules. Corsair cooling settings were not exposed by the active daemon.

The weather timer/helper is included; its private API key is excluded and had HTTP 401. Restore a valid key before expecting live weather. Notification playback includes the direct-output helper that bypasses EasyEffects for desktop sounds; media/calls retain their effects route.

Dubbing AI is a Windows app running in a dedicated QEMU/KVM VM. Linux virtualization packages and launcher are included; original launch/shutdown/read-only backing source scripts are under `vendor/dubbing-ai`. They are not enabled automatically. Restore the stopped VM's private disk/firmware/TPM/boot sectors, select the actual Windows partition, adapt SOURCE/START/LENGTH/uid in readonly-disk.py, and deploy matching user/root services only after verifying source fingerprints. Existing Windows-backed overlays cannot be safely reused with a different/modified base. Source VM requires its Windows mount read-only for its entire runtime; the original helper refuses busy unmounts and checks source changes. An independent Windows disk can use the alternative windows.qcow2 path. noVNC is optional, not required for the SPICE launcher. Do not copy an unvalidated block-device helper into root services.

Equicord's custom plugin is rebuilt from pinned source, installed through the existing CLI injector, then its custom asar replaces the stock build. This modifies Discord Canary; close/restart Discord after deployment. No Discord account tokens are published. Ngrok-bot/ChatGPT/Antigravity/Tor/GPA and other installed apps are package targets, but private sign-ins require the companion backup.
