if [ -x $XDG_CONFIG_HOME ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# Load real zshenv
source $ZDOTDIR/.zshenv
