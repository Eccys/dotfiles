# Validation on the source host (7 October 2026)

Verified:

- SnapX 0.4.0 package installed. Current ApplicationConfig and HotkeysConfig YAML both log `load finished`. Old JSON enum migration errors stopped after replacing the incompatible import and terminating stale instances. Original Windows data is backed up privately.
- 2,046 Windows archive files copied with size comparisons; 2,371 original history rows added, including 2,056 translated file paths.
- Custom editor offscreen interaction tests: copying composed pixels, independent capture/output area, pasting/moving/resizing image layers, output pixel/color assertions, undo/redo, and live horizontal line/arrow rendering. One real capture saved earlier. Live synthetic window mapping reports `class=snapx-overlay`, floating=true, fullscreen=2, size=2560x1440; no monitor-choice portal.
- All ten current Hyprland capture/workflow bindings registered; `hyprctl configerrors` empty. Active legacy screenshot entrypoints delegate to snapx-workflow.
- Native region MP4 recording produced a valid 64x64 video. GIF recording/conversion produced a valid 64x64 animated GIF. Native Wayland capture of a visible synthetic test window successfully recognized its text with tesseract and decoded its QR with zbar.
- `eccys-serpantinum` 2.2.4-1 built through makepkg with upstream archive checksum validation and installed successfully through pacman. Package contains pinned upstream assets, current QML/scripts, compiled shaders and executable entrypoints.
- snap-pac installation enabled transaction hooks; desktop package installation produced root pre/post snapshots 58/59. Root/home timeline and cleanup timers are enabled/active. Additional real root/home verification snapshots were created (60/57).
- `scripts/verify.py` returned zero: all 155 declared official packages and 15 AUR packages present, custom desktop package present, root/home snapshot configs readable, keyd config valid, desktop/device services active and Hyprland has no config errors.
- Isolated full config deployment passed. Repeating it preserves the output. Existing files behind a config-directory symlink remain accessible, home placeholders resolve, executable modes restore, and encoded wallpaper/display/theme assets decode.
- Isolated browser deployment created a Zen profile and downloaded/validated all nine third-party addons from their recorded Mozilla URLs. Bundled browser addons are supplied by Zen itself.
- Repository payload checksums, JSON/base64 integrity and AUR recipe coverage checked. Private credential files, browser databases, VM disks and root privilege policy are excluded; secret-pattern scan runs before publishing.

Limits: a fresh boot/reinstallation was not performed. Network AUR builds/third-party binaries can change or disappear; historical official binary versions are not pinned. Browser account state, external media/VMs and the existing rear-fan/weather issues need the companion backup or their documented repair. Native SnapX's main-window close notification still has an upstream D-Bus serialization issue on this host; it does not drive the custom capture editor. Do not claim complete ShareX feature parity or exact NixOS generations.

Fullscreen correction: docked controls previously reduced the image area and startup fit ran before Wayland fullscreen configure. Controls now float over the canvas, and every resize recomputes its pixel/logical-coordinate mapping. Live tests confirmed canvas/viewport and image corners exactly span 2560x1440 on DP-3 and 1080x1920 on the rotated HDMI-A-4, with floating=true/fullscreen=2 on the intended monitor. Offscreen resize/controls/annotation tests passed.
