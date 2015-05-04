__enterls() {
    if [[ -z "$BUFFER" ]]; then
        echo
        ls -C
        echo
        zle reset-prompt
    else
        # there are some input so ignore enterls
        zle accept-line
    fi
}
zle -N __enterls
bindkey '^m' __enterls

# automatically call
function chpwd() {
    emulate -L zsh
    ls -C
}
