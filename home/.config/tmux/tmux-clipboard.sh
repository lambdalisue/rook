#!/bin/bash

tmux_clipboard_copy() {
    # Copy to system clipboard
    if which xclip > /dev/null 2>&1; then
        xclip -i -selection clipboard $@
        return $?
    elif which pbcopy > /dev/null 2>&1; then
        pbcopy $@
        return $?
    fi
    return 1
}

tmux_clipboard_paste() {
    # Paste from the system clipboard
    if which xclip > /dev/null 2>&1; then
        xclip -o -selection clipboard $@
        return $?
    elif which pbpaste > /dev/null 2>&1; then
        pbpaste $@
        return $?
    fi
    return 1
}

tmux_copy() {
    # Copy the tmux selection into the system clipboard
    #
    # Note:
    #   somehow it does not work....
    #
    tmux save-buffer - | tmux_clipboard_copy
}

tmux_paste() {
    # Paste from the system clipboard to the tmux command line
    tmux set-buffer "$(tmux_clipboard_paste)" && tmux paste-buffer
    return $?
}

main() {
    local name=$1; shift;
    if [[ "$name" == "copy" ]]; then
        tmux_copy $@
    elif [[ "$name" == "paste" ]]; then
        tmux_paste $@
    elif [[ "$name" == "clipboard_copy" ]]; then
        tmux_clipboard_copy $@
    elif [[ "$name" == "clipboard_paste" ]]; then
        tmux_clipboard_paste $@
    else
        echo "Unknown name '$name' was specified." 1>&2
        return 1
    fi
    return $?
}
main $@
