# 🌌 Eccys' Dotfiles

A premium, modern Arch Linux configuration powered by **Hyprland** and **Neovim**. This setup is designed for efficiency, aesthetics, and high performance.

---

## 🚀 Highlights

### 🛠️ Neovim (v0.12+ Ready)
Custom IDE-like experience with zero startup errors and lightning-fast completion.
- **Blink.cmp**: Next-gen completion engine with frecency-based fuzzy matching.
- **Native LSP**: Transitioned to Neovim's native `vim.lsp.config` and `vim.lsp.enable` APIs.
- **Modern UI**: Catppuccin Mocha theme with dynamic Matugen color reloading.
- **Fold/UFO**: Advanced code folding with `nvim-ufo`.

### 🖥️ Hyprland & Desktop
Smooth animations and vim-centric workflow.
- **Compositor**: Hyprland with glassmorphism and blur effects.
- **Bar**: Quickshell-based vertical and horizontal widgets.
- **Terminal**: Kitty with Matugen-synced color schemes.
- **File Manager**: Yazi (Terminal) with modern keybinds.

---

## 📂 Structure

| Directory | Component | Description |
|-----------|-----------|-------------|
| `nvim/` | Neovim | Full Lua-based config with Lazy.nvim |
| `hypr/` | Hyprland | Window manager rules and keybinds |
| `kitty/` | Kitty | Fast, GPU-accelerated terminal |
| `quickshell/` | Widgets | Custom bars and system monitors |
| `yazi/` | Yazi | Modern terminal file manager |

---

## 🛠️ Installation

1. **Clone the repo**:
   ```bash
   git clone https://github.com/eccys/dotfiles ~/dotfiles
   ```
2. **Symlink configs**:
   ```bash
   ln -s ~/dotfiles/nvim ~/.config/nvim
   # Repeat for other directories
   ```
3. **Install dependencies**:
   - `neovim` (v0.12+)
   - `lua51` (for luarocks/image.nvim)
   - `hyprland`, `kitty`, `yazi`

---

## 📝 Recent Updates
- **2026-05-03**: Major Neovim refactor. Fixed all deprecation warnings, migrated to native LSP APIs, and optimized `blink.cmp` configuration.

---

*Crafted with ❤️ by Eccys*
