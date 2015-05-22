# cd up with ^^
function __function_call_cdup() {
    if [ -z "$BUFFER" ]; then
        echo
        pushd ../ > /dev/null
        ls -C
        zle reset-prompt
        zle -R
    else
        zle self-insert '^^'
    fi
}
zle -N __function_call_cdup
bindkey '\^\^' __function_call_cdup

# popd up with [[
function __function_call_popd() {
    if [ -z "$BUFFER" ]; then
        echo
        popd > /dev/null
        ls -C
        zle reset-prompt
        zle -R
    else
        zle self-insert '[['
    fi
}
zle -N __function_call_popd
bindkey '[[' __function_call_popd
