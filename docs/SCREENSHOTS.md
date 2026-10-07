# Capture controls

| Shortcut | Action |
|---|---|
| Ctrl+Shift+S | Frozen focused-monitor capture/editor |
| Print / Super+Print | Full desktop to clipboard and file |
| Alt+Print | Active window |
| Shift+Print | Capture/editor |
| Ctrl+Shift+Z | Start/stop selected-region MP4 recording |
| Ctrl+Shift+Print | Start/stop selected-region GIF recording |
| Ctrl+Shift+Q | Region OCR to clipboard |
| Ctrl+Alt+Q | Region QR decoding to clipboard |
| Super+Shift+Print | SnapX main application |

The capture editor uses grim and PySide6 under Wayland. It silently captures the focused monitor, floats/fullscreens through Hyprland rules, and lets you draw arrows, rectangles, ellipses, lines, text and freehand strokes while viewing the frozen screenshot. The toolbar's Capture area determines the saved output. Copy pixels selects a separate source rectangle: Ctrl+C then Ctrl+V, or Duplicate region, inserts those composed pixels as an image layer. Insert image loads another file; Insert QR creates a QR layer from text/a URL. In Move/resize mode drag a layer, or its blue bottom-right handle to resize it. Delete removes the selected layer, Ctrl+Z/Ctrl+Y undo/redo; Enter copies/saves PNG and Esc cancels. Pixelate creates a movable pixelated layer.

Screenshots save to `~/Pictures/sss/YYYY-MM/DD-HH-MM-SS-mmm.png`, are copied with wl-copy, and enter SnapX's SQLite history. This matches the Windows save/copy workflow. No automatic uploader was configured in the Windows source; uploads are not enabled. The Windows archive and 2,371 original history rows were migrated privately on the source machine; they are not in this public repo.

SnapX 0.4.0 is early-access. Its native ShareX-compatible configuration importer rejects several old uploader/shortener enums. This repository uses a compatible subset in YAML instead of feeding it the whole Windows JSON. Old JSON must not be placed beside the YAML files: SnapX automatically tries to migrate it on every launch.

The real-time editor and native recording/OCR/QR shortcuts are a local compatibility bridge, not a claim that SnapX itself implements every ShareX tool. Region recording uses slurp; desktop portal prompts do not apply to the normal image editor. Recording is silent, matching the imported profile. Exact ShareX object editing, arbitrary effects and every upload/automation integration are not reproduced. Native SnapX 0.4.0 also has an upstream notification D-Bus exception when closing its main window on this host; the capture bridge operates separately. Satty remains as an explicit-geometry fallback required by the shell.

`snapx-start` seeds SnapX's session vault from a user-owned 0600 random key in `~/.local/share/snapx-private/master-key`. This avoids the invisible login-keyring unlock stall observed on this host. Preserve that key with any private encrypted SnapX configuration. A fresh restore creates a new key. The home filesystem should be encrypted to protect file-backed credentials.
