#!/bin/bash
#-------------------------------------------------------------------------------------------
# Enable user custom keymap via xkb
#-------------------------------------------------------------------------------------------
XKB_CONFIG="${HOME}/.config/xkb"
XKB_KEYMAP="${XKB_CONFIG}/keymap/my"
xkbcomp -I$XKB_CONFIG $XKB_KEYMAP "${DISPLAY%%.*}"
