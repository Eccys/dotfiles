#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# BEGIN arch-preparation tty1 UWSM startup
if [[ ${IN_UWSM_ENV_PRELOADER:-false} != true ]] &&
   [[ $- == *i* ]] &&
   command -v uwsm >/dev/null 2>&1 &&
   uwsm check may-start
then
    exec uwsm start hyprland.desktop
fi
# END arch-preparation tty1 UWSM startup
