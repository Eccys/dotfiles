if status is-interactive
    # Commands to run in interactive sessions can go here
end


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
function fish_prompt
    set_color green
    echo -n (whoami)
    echo -n '@'
    set_color normal
    echo -n $hostname
    set_color green
    echo -n '' (prompt_pwd)
    set_color normal
    echo -n '> '
end

# Aliasing cd for zoxide
zoxide init --cmd cd fish | source

# Set editor to nvim
export EDITOR=/usr/bin/nvim

# Fuzzily find directories by aliasing 'f' to FZF
alias f='cd $(fd --type directory | fzf)'

set -gx LIBVIRT_DEFAULT_URI "qemu:///system"