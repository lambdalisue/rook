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
        sudo apt-get install ${NAME}
    elif type brew > /dev/null 2>&1; then
        brew install ${NAME}
    elif type yum > /dev/null 2>&1; then
        sudo yum install ${NAME}
    else
        return 1
    fi
    return $?
}
install_repository() {
    url=$1
    dst=$2
    if [[ ! -d "$dst" ]]; then
        git clone $url "$dst"
    fi
}

# zsh
if ! install_package golang; then
    echo "Failed to install 'golang'. Please install it manually and retry." > &2
    exit 1
fi
GOHOME="$HOME/.go"
if ! go get github.com/motemen/ghq; then
    echo "Failed to install 'ghq'. Please install it manually (go get github.com/motemen/ghq) and retry." > &2
    exit 1
fi

# tmux
bundle="${XDG_CONFIG_HOME}/tmux/bundle"
if ! install_repository "https://github.com/seebi/tmux-colors-solarized" "${bundle}/tmux-colors-solarized"; then
    echo "Faield to install 'tmux-colors-solarized'. Please install it manually." > &2
fi
if ! install_repository "https://github.com/erikw/tmux-powerline" "${bundle}/tmux-powerline"; then
    echo "Faield to install 'tmux-powerline'. Please install it manually." > &2
fi
if [[ "$(uname)" == "Darwin" ]]; then
    brew install tmux-mem-cpu-load
    brew install reattach-to-user-namespace --wrap-launchctl --wrap-pbcopy-and-pbpaste
    # GNU grep is required for weather.sh
    brew install grep
else
    if ! install_package cmake; then
        echo "Failed to install 'cmake'. Please install it manually and retry."
        exit 1
    fi
    if ! install_repository "https://github.com/thewtex/tmux-mem-cpu-load" "${bundle}/tmux-mem-cpu-load"; then
        echo "Faield to install 'tmux-mem-cpu-load'. Please install it manually." > &2
    fi
    bundle thewtex tmux-mem-cpu-load
    cd ${bundle}/tmux-mem-cpu-load
    cmake CMakeLists.txt
    make
    sudo make install
fi
