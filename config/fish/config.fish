if status is-interactive
    # Commands to run in interactive sessions can go here
end

function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
    if test "$argv" = !!
        echo sudo $history[1]
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end
#function fish_prompt
#    set_color green
#    echo -n (whoami)
#    echo -n '@'
#    set_color normal
#    echo -n $hostname
#    set_color green
#    echo -n '' (prompt_pwd)
#    set_color normal
#    echo -n '> '
#end

export EDITOR=vim
