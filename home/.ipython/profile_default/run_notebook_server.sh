#!/usr/bin/env bash
: ${NOTEBOOK_HOME:=$HOME/Notebook}

if [[ ! -d $NOTEBOOK_HOME ]]; then
    mkdir -p "$NOTEBOOK_HOME"
fi
cd $NOTEBOOK_HOME

ipython3 notebook &
