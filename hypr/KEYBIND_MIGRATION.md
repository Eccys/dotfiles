# Keybind Migration Notes

## Current Keybinds That Were Overridden (Need Rebinding)

These keybinds existed in the old config but were replaced or dropped. Exact old Hyprland syntax shown.

| Old Binding | Old Hyprland Syntax (exact) | Now Is | Action Needed |
|---|---|---|---|
| `Super+D` | `bind = Super, D, fullscreen, 1` | Maximize (fullscreen 1) ✅ Same | None — kept same action |
| `Super+F` | `bind = Super, F, fullscreen, 0` | Fullscreen ✅ Same | None — kept same action |
| `Super+Q` | `bind = Super, Q, killactive,` | Kill active window ✅ Same | None — kept same action |
| `Super+L` | `bindd = Super, L, Lock, exec, loginctl lock-session` | Removed (commented out) | Re-add or use `Ctrl+Alt+L` |
| `Super+V` | `bindd = Super, V, Clipboard history >> clipboard, global, quickshell:overviewClipboardToggle` | Now opens rofi cliphist ✅ Fixed | **Already fixed — `Super+V` now opens rofi clipboard** |
| `Super+B` | `bind = Super, B, global, quickshell:sidebarLeftToggle` | Unbound | Rebind if you want left sidebar |
| `Super+W` | `bind = Super, W, exec, launch_first_available.sh "zen-browser" ...` | Zen Browser ✅ Same | None |
| `Super+S` | `bind = Super, S, togglespecialworkspace,` | Toggle special workspace ✅ Same | None |
| `Super+N` | `bindd = Super, N, Toggle right sidebar, global, quickshell:sidebarRightToggle` | Unbound | Rebind if you want right sidebar |
| `Super+H` | (was bound via `unbind` to QS bar; custom rebind was movefocus) | Move focus left (HJKL) ✅ Kept | None |
| `Super+M` | `bindd = Super, M, Toggle media controls, global, quickshell:mediaControlsToggle` | Unbound | Rebind if you want media controls |
| `Super+A` | `bindd = Super, A, Toggle left sidebar, global, quickshell:sidebarLeftToggle` | swaync notifications ✅ Kept | None — intentional change |
| `Super+Shift+S` | `bindd = Super+Shift, S, Screen snip, exec, qs -p .../screenshot.qml ...` | Send to special (follow) | Old was screenshot; new is workspace action |
| `Alt+Tab` | `bind = Alt, Tab, cyclenext` + `bind = Alt, Tab, bringactivetotop,` | Cycle windows (cyclenext) | Functionally same, just removed bringactivetotop |
| `Super+C` | `bind = Super, C, exec, launch_first_available.sh "cursor" "code" ...` (code editor!) | Rofi clipboard | Changed purpose — C now = clipboard |

> **Note on `Super+V`:** The old config used `global, quickshell:overviewClipboardToggle` (quickshell IPC). The current setup uses `cliphist` + `rofi` instead, which is equivalent and already running. `Super+V` has now been added to `hyprland.conf` pointing to the same `rofi_clipboard.sh` as `Super+C`.

---

## Old Keybinds NOT Migrated (Missing Apps/Scripts)

These old keybinds could not be migrated because the required software is not installed.

| Old Hyprland Syntax (exact) | Action | Missing |
|---|---|---|
| `bind = Super SHIFT, Return, exec, pypr toggle term` | Pyprland dropdown terminal | `pypr` binary — re-added in current config |
| `bind = Super, Z, exec, pypr zoom` | Pyprland zoom | `pypr` binary — re-added in current config |
| `bind = Super SHIFT, R, exec, obsidian` | Open Obsidian | `obsidian` not installed |
| `bind = Super, R, exec, kruler` | KRuler screen ruler | `kruler` not installed |
| `binde = Super CTRL, I, exec, busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -500` | Night mode (decrease temp) | `wl-gammarelay` not installed |
| `binde = Super SHIFT, I, exec, busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +500` | Night mode (increase temp) | `wl-gammarelay` not installed |
| `binde = Super ALT, I, exec, pkill wl-gammarelay && wl-gammarelay &` | Night mode (reset) | `wl-gammarelay` not installed |
| `bind = Super CTRL ALT, R, exec, ~/.config/hypr/hyprland/custom/scripts/snapshots.sh root` | BTRFS snapshot (root) | Script missing |
| `bind = Super CTRL ALT, H, exec, ~/.config/hypr/hyprland/custom/scripts/snapshots.sh home` | BTRFS snapshot (home) | Script missing |
| `bindd = Super+Shift, C, Color picker, exec, hyprpicker -a` | Color picker | `hyprpicker` not installed |
| `bindd = Super+Shift, T, Character recognition, exec, grim -g "$(slurp ...)" tmp.png && tesseract tmp.png - \| wl-copy ...` | OCR / Character recognition | `tesseract` not installed |
| `bindd = Super+Alt, R, Record region, exec, ~/.config/hypr/hyprland/scripts/record.sh` | Record region | `record.sh` script missing |
| `bindd = Ctrl+Alt, R, Record screen, exec, ~/.config/hypr/hyprland/scripts/record.sh --fullscreen` | Record screen | `record.sh` script missing |

---

## Quickshell Widget Toggles That Lost Their Bindings

The old config used `global, quickshell:...` IPC calls. Your current setup uses `qs_manager.sh`. Suggested rebinds:

```ini
# Suggested: use Super+Shift/<key> or Super+Alt/<key>
# bind = $mainMod SHIFT, Q, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle music
# bind = $mainMod SHIFT, B, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle battery
# bind = $mainMod SHIFT, W, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle wallpaper
# bind = $mainMod SHIFT, S, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle settings
# bind = $mainMod SHIFT, N, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle network
# bind = $mainMod SHIFT, H, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle guide
# bind = $mainMod SHIFT, M, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle monitors
# bind = $mainMod ALT, S, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle calendar
# bind = $mainMod ALT, D, exec, bash ~/.config/hypr/scripts/rofi_show.sh drun
```

Old QS IPC syntax for reference:
```ini
# bind = Super, B, global, quickshell:sidebarLeftToggle          # left sidebar
# bindd = Super, N, ..., global, quickshell:sidebarRightToggle   # right sidebar
# bindd = Super, M, ..., global, quickshell:mediaControlsToggle  # media controls
# bindd = Ctrl+Super, T, ..., global, quickshell:wallpaperSelectorToggle
# bindd = Super, Slash, ..., global, quickshell:cheatsheetToggle
# bindd = Super, K, ..., global, quickshell:oskToggle
# bindd = Super, J, ..., global, quickshell:barToggle
```

---

## New Keybind Reference

### Window Management
| Bind | Action |
|---|---|
| `Super+Q` | Kill active window |
| `Alt+F4` | Kill active window |
| `Super+Shift+Alt+Q` | Force kill (hyprctl kill) |
| `Super+F` | Fullscreen |
| `Super+D` | Maximize |
| `Super+Alt+F` | Fullscreen spoof |
| `Super+Shift+F` | Toggle floating |
| `Super+Alt+Space` | Toggle floating (alt) |
| `Super+P` | Pin window |
| `Super+O` | Toggle split (dwindle) |
| `Super+;` / `Super+'` | Adjust split ratio |

### Navigation (HJKL + Arrows)
| Bind | Action |
|---|---|
| `Super+H/J/K/L` | Move focus (left/down/up/right) |
| `Super+Arrows` | Move focus |
| `Super+Ctrl+H/J/K/L` | Move window |
| `Super+Ctrl+Arrows` | Move window |
| `Super+Shift+H/J/K/L` | Resize window |
| `Super+Shift+Left/Right` | Resize window |
| `Alt+Tab` | Cycle next (prev) |
| `Alt+Shift+Tab` | Cycle next |

### Applications
| Bind | Action |
|---|---|
| `Super+Return` | Terminal (kitty) |
| `Super+E` | File manager (nautilus) |
| `Super+W` | Browser (zen-browser) |
| `Super+C` | Clipboard (rofi + cliphist) |
| `Super+V` | Clipboard (rofi + cliphist) — restored Win+V muscle memory |
| `Super+A` | Notifications (swaync) |

### Workspaces
| Bind | Action |
|---|---|
| `Super+{1-0}` | Switch to workspace |
| `Super+Shift+{1-0}` | Move window to workspace (follow) |
| `Super+Ctrl+{1-0}` | Move window to workspace (silent) |
| `Super+Tab` | Previous workspace |
| `Super+S` | Toggle special workspace |
| `Super+Alt+S` | Send to special (silent) |
| `Super+Shift+S` | Send to special (follow) |
| `Super+Shift+,/.` | Move to prev/next workspace |
| `Super+Ctrl+,/.` | Move to prev/next (silent) |
| `Ctrl+Super+Left/Right` | Relative workspace nav |
| `Super+Mouse scroll` | Workspace scroll |

### Media
| Bind | Action |
|---|---|
| `Super+Space` | Play/pause |
| `Super+Shift+N` | Next track |
| `Super+Shift+B` | Previous track |
| `Super+Shift+P` | Play/pause (alt) |

### System
| Bind | Action |
|---|---|
| `Ctrl+Alt+L` | Lock session |
| `Super+Shift+L` | Suspend |
| `Ctrl+Shift+Alt+Super+Delete` | Shutdown |
| `Print` | Screenshot |
| `Super+R` | Reload config |

### Zoom
| Bind | Action |
|---|---|
| `Super+=` / `Super++` | Zoom in |
| `Super+-` | Zoom out |
| `Super+Shift+-` / `Super+Shift+0` | Reset zoom |
