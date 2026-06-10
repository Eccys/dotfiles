zoxide init --cmd cd fish | source
alias yay="yay --noconfirm"

# uv
fish_add_path "/home/user/.local/bin"

# Autostart Hyprland on tty1 login
if status is-login
    if test (tty) = "/dev/tty1"
        exec start-hyprland
    end
end

