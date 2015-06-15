#!/usr/bin/env bash

if [[ ! -d "$HOME/.homesick/repos/homeshick" ]]; then
    git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc
fi
source $HOME/.homesick/repos/homeshick/homeshick.sh

if [[ ! -d "$HOME/.homesick/repos/rook" ]]; then
    if [[ "$USER" != "alisue" -o $USE_GUEST eq 1 ]]; then
        homeshick clone https://github.com/lambdalisue/rook -f
    else
        homeshick clone git@github.com:lambdalisue/rook -f
    fi
fi
homeshick cd rook
bash ./tools/install_requirements.sh

if [[ "$(uname)" = "Linux" ]]; then
    bash ./tools/configure_terminal.sh
fi
