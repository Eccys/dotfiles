function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

starship init fish | source
if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
end

alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias q 'qs -c ii'
alias f='cd $(fd --type directory | fzf)'
alias z='zen-browser'
alias zen='zen-browser'
alias zenn='zen-twilight'
alias night-light='wl-gammarelay &; disown'
    
# "sudo !!" command in fish
function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
    if test "$argv" = !!
        echo sudo $history[1]
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

# Colored fish prompt
# function fish_prompt
#     set_color green
#     echo -n (whoami)
#     echo -n '@'
#     set_color normal
#     echo -n $hostname
#     set_color green
#     echo -n '' (prompt_pwd)
#     set_color normal
#     echo -n '> '
# end

# E-Z download yt-audio
function yt-audio
    yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 $argv
end

# Aliasing cd for zoxide
zoxide init --cmd cd fish | source
# Set editor to nvim
set -x EDITOR nvim


set -gx LIBVIRT_DEFAULT_URI "qemu:///system"

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end

# A dedicated function to generate the fzf preview.
function fzf_preview
    set -l path $argv[1]

    # Check if the path is a directory.
    if test -d "$path"
        # For directories, list contents cleanly.
        fish -c "cd '$path'; and fd --color=always --hidden --max-depth 1"
    else
        # For files, use bat/cat for a syntax-highlighted preview.
        if command -q bat
            bat --color=always --style=numbers,plain -- "$path"
        else
            cat -- "$path"
        end
    end
end

# The main function, searching only the current directory for speed.
function scry
    # This command is fast and focused. It finds all files and directories
    # within the current location.
    fd . . --hidden --exclude .git 2>/dev/null | fzf --tmux 80% --layout=reverse --preview 'fzf_preview {}'
end

# This function runs scry and opens the selection in Neovim.
function scry_edit
    set -l selected (scry)
    if test -n "$selected"
        command nvim "$selected"
    end
    commandline -f repaint
end

# Bind Ctrl+N to the editing function.
bind \cN scry_edit
