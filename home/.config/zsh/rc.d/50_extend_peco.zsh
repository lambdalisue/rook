__peco::print() {
    if [[ -t 1 ]]; then
        # print to BUFFER
        print -z "$1"
    else
        # print as normal
        print "$1"
    fi
}
__peco::zle() {
    local buffer="$1"
    local accept="$2"
    if [[ -n "$buffer" ]]; then
        BUFFER="$buffer"
        CURSOR=$#BUFFER
        if [[ "$accept" -eq "1" ]]; then
            zle accept-line
        fi
    fi
    zle clear-screen
}

__peco::remove_ansi_escape_codes() {
    perl -pe 's/\e\[?.*?[\@-~]//g'
}


peco::select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    local selected="$(
        fc -l -n 1 |
        eval $tac |
        peco --query "$1"
    )"
    [[ -n "$selected" ]] && __peco::print "$selected"
}
__peco::select-history() {
    __peco::zle "$(peco::select-history "$LBUFFER")" 0
}
zle -N __peco::select-history
bindkey '^X^R' __peco::select-history


peco::select-directory() {
    local selected="$(
        cdr -l |
        sed 's/^[0-9]*\s*//' |
        peco --query "$1"
    )"
    [[ -n "$selected" ]] && __peco::print "cd $selected"
}
__peco::select-directory() {
    __peco::zle "$(peco::select-directory "$LBUFFER")" 1
}
zle -N __peco::select-directory
bindkey "^X^J" __peco::select-directory


peco::select-process-to-kill() {
    local selected="$(
        ps -ef |
        peco --query "$1" |
        awk '{ print $2 }'
    )"
    [[ -n "$selected" ]] && __peco::print "kill $selected"
}
__peco::select-process-to-kill() {
    __peco::zle "$(peco::select-process-to-kill "$LBUFFER")" 0
}
zle -N __peco::select-process-to-kill
bindkey '^X^K' __peco::select-process-to-kill


if type ghq > /dev/null; then
    peco::select-ghq-src () {
        local selected="$(
            ghq list --full-path |
            peco --query "$1"
        )"
        [[ -n "$selected" ]] && __peco::print "cd $selected"
    }
    __peco::select-ghq-src() {
        __peco::zle "$(peco::select-ghq-src "$LBUFFER")" 1
    }
    zle -N __peco::select-ghq-src
    bindkey '^X^S' __peco::select-ghq-src
fi


if type homeshick > /dev/null; then
    function peco::select-homeshick-repo() {
        local selected="$(
            homeshick list |
            __peco::remove_ansi_escape_codes |
            awk ' { print $1 }' |
            peco --query "$1"
        )"
        [[ -n "$selected" ]] && __peco::print "homeshick cd $selected"
    }
    function __peco::select-homeshick-repo() {
        __peco::zle "$(peco::select-homeshick-repo "$LBUFFER")" 1
    }
    zle -N __peco::select-homeshick-repo
    bindkey '^X^H' __peco::select-homeshick-repo
fi
