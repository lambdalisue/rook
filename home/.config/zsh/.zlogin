#!/usr/bin/env bash
IPYTHON="$HOME/.anyenv/env/pyenv/shims/ipython"
NOTEBOOK_HOME="$HOME/Notebook"

if [[ -x "$IPYTHON" ]]; then
    if [[ ! -d $NOTEBOOK_HOME ]]; then
        mkdir -p "$NOTEBOOK_HOME"
    fi
    cd $NOTEBOOK_HOME
    $IPYTHON notebook &
fi
