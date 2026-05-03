# Dotfiles for Arch Linux

This project contains my personal settings for Arch Linux. It uses the Hyprland desktop and the Neovim code editor. The goal is to keep the system fast and easy to use.

> [!NOTE]
> These files are made for my own computer. You may need to change some paths to make them work for you.

## System Parts

### Neovim
I use Neovim to write code. It is set up to be fast.
- It uses the "Blink" tool for quick word completion.
- It uses the built-in LSP to find errors in code.
- It has a tool called "Footnote" for making notes.

> [!TIP]
> You should use Neovim version 0.12 or newer. This version supports all the tools in these files.

### Hyprland
Hyprland is a tool that manages windows on the screen. It uses a tiled layout.
- It has smooth movements for windows.
- It uses custom bars to show the time and battery life.
- It uses "Kitty" as the main terminal.

### Other Tools
- **Yazi**: A fast way to look at files in the terminal.
- **Matugen**: A tool that picks colors based on your wallpaper.

---

## How to Install

1. **Get the files**:
   ```bash
   git clone https://github.com/eccys/dotfiles ~/dotfiles
   ```
2. **Link the files**:
   Move these folders to your `.config` folder. You can use a symbolic link to keep them in sync.
3. **Install programs**:
   Make sure you have `hyprland`, `neovim`, and `kitty` on your system.

> [!CAUTION]
> Back up your own settings before you overwrite them with these files.

---
*Maintained by Eccys* 🌌
