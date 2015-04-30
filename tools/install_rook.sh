#!/usr/bin/env bash

if [[ ! -d "$HOME/.homesick/repos/homeshick" ]]; then
    git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc
fi
source $HOME/.homesick/repos/homeshick/homeshick.sh
homeshick clone git@github.com:lambdalisue/rook -f
homeshick cd rook
./tools/install_requirements.sh

