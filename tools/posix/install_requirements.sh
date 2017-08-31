#!/usr/bin/env bash

# define XDG_CONFIG_HOME
if [[ "$XDG_CONFIG_HOME" == "" ]]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi

install_package(){
    NAME=$1; shift
    # check presence
    if type ${NAME} > /dev/null 2>&1; then
        return 0
    fi
    # try to install
    if type apt-get > /dev/null 2>&1; then
        sudo apt-get -y install ${NAME}
        return $?
    elif type yum > /dev/null 2>&1; then
        sudo yum -y install ${NAME}
        return $?
    else
        return 1
    fi
}
install_repository() {
    url=$1
    dst=$2
    if [[ ! -d "$dst" ]]; then
        git clone $url "$dst"
    fi
}
# zsh
if [[ "$(uname)" == "Darwin" ]]; then
    if ! install_package go; then
        echo "Failed to install 'go'. Please install it manually and retry." >&2
        # this is not critical
        #exit 1
    fi
else
    if ! install_package golang; then
        echo "Failed to install 'golang'. Please install it manually and retry." >&2
        # this is not critical
        #exit 1
    fi
fi

# tmux
if [[ "$(uname)" == "Darwin" ]]; then
    brew install tmux-mem-cpu-load
    brew install reattach-to-user-namespace --with-wrap-launchctl --with-wrap-pbcopy-and-pbpaste
    # GNU grep is required for weather.sh
    brew install grep
else
    bundle="${XDG_CONFIG_HOME}/tmux/bundle"
    if ! install_package cmake; then
        echo "Failed to install 'cmake'. Please install it manually and retry."
        exit 1
    fi
    if ! install_repository "https://github.com/thewtex/tmux-mem-cpu-load" "${bundle}/tmux-mem-cpu-load"; then
        echo "Faield to install 'tmux-mem-cpu-load'. Please install it manually." >&2
    fi
    cd ${bundle}/tmux-mem-cpu-load
    cmake CMakeLists.txt
    make
    sudo make install
fi
