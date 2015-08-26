#!/usr/bin/env bash
if ! type git > /dev/null 2>&1; then
    echo "'git' is required. Install it first."
    exit 1
fi

if [[ ! -d "$HOME/.homesick/repos/homeshick" ]]; then
    git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    printf '\nsource "$HOME/.homesick/repos/homeshick/homeshick.sh"' >> $HOME/.bashrc
fi
source $HOME/.homesick/repos/homeshick/homeshick.sh

if [[ ! -d "$HOME/.homesick/repos/rook" ]]; then
    if [ "$USER" != "alisue" -o "$USE_GUEST" == "1" ]; then
        homeshick clone https://github.com/lambdalisue/rook -f --batch
    else
        homeshick clone git@github.com:lambdalisue/rook -f --batch
    fi
fi
cd $HOME/.homesick.repos/rook
bash ./tools/install_requirements.sh

if [[ "$(uname)" = "Linux" ]]; then
    bash ./tools/configure_terminal.sh
fi
