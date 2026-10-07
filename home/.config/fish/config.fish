# Keep new terminal windows free of startup greeting lines.
set -g fish_greeting ""

zoxide init --cmd cd fish | source
# Removed by Arch preparation: keep package-manager prompts interactive

# uv
fish_add_path "$HOME/.local/bin"

# Autostart Hyprland on tty1 login
if status is-login
    if test (tty) = "/dev/tty1"
        exec start-hyprland
    end
end


# >>> grok installer >>>
fish_add_path $HOME/.grok/bin
# <<< grok installer <<<
