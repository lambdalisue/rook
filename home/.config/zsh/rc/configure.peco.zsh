if [ $(uname) = "Darwin" ]; then
    __add_path "${ZDOTDIR}/tools/peco/peco_darwin_amd64"
else
    __add_path "${ZDOTDIR}/tools/peco/peco_linux_amd64"
fi

function __peco_print() {
    if [[ -t 1 ]]; then
        # print to BUFFER
        print -z "$1"
    else
        # print as normal
        print "$1"
    fi
}
function __peco_zle() {
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
function __peco_remove_ansi_escape_codes() {
    perl -pe 's/\e\[?.*?[\@-~]//g'
}

function peco-select-history() {
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
    [[ -n "$selected" ]] && __peco_print "$selected"
}
function __peco-select-history() {
    __peco_zle "$(peco-select-history "$LBUFFER")" 0
}
zle -N __peco-select-history
bindkey '^X^R' __peco-select-history


function peco-select-directory() {
    local selected="$(
        cdr -l |
        sed 's/^[0-9]*\s*//' |
        peco --query "$1"
    )"
    [[ -n "$selected" ]] && __peco_print "cd $selected"
}
function __peco-select-directory() {
    __peco_zle "$(peco-select-directory "$LBUFFER")" 1
}
zle -N __peco-select-directory
bindkey "^X^J" __peco-select-directory


function peco-select-process-to-kill() {
    local selected="$(
        ps -ef |
        peco --query "$1" |
        awk '{ print $2 }'
    )"
    [[ -n "$selected" ]] && __peco_print "kill $selected"
}
function __peco-select-process-to-kill() {
    __peco_zle "$(peco-select-process-to-kill "$LBUFFER")" 0
}
zle -N __peco-select-process-to-kill
bindkey '^X^K' __peco-select-process-to-kill


if type ghq > /dev/null; then
    function peco-select-ghq-src () {
        local selected="$(
            ghq list --full-path |
            peco --query "$1"
        )"
        [[ -n "$selected" ]] && __peco_print "cd $selected"
    }
    function __peco-select-ghq-src() {
        __peco_zle "$(peco-select-ghq-src "$LBUFFER")" 1
    }
    zle -N __peco-select-ghq-src
    bindkey '^X^S' __peco-select-ghq-src
fi

if type homeshick > /dev/null; then
    function peco-select-homeshick-repo() {
        local selected="$(
            homeshick list |
            __peco_remove_ansi_escape_codes |
            awk ' { print $1 }' |
            peco --query "$1"
        )"
        [[ -n "$selected" ]] && __peco_print "homeshick cd $selected"
    }
    function __peco-select-homeshick-repo() {
        __peco_zle "$(peco-select-homeshick-repo "$LBUFFER")" 1
    }
    zle -N __peco-select-homeshick-repo
    bindkey '^X^H' __peco-select-homeshick-repo
fi

if type git > /dev/null; then
    function peco-select-git-add() {
        local selected="$(
            git status --porcelain |
            grep -E '^([ MARC][MDT]|DM|DD|AU|UD|UA|DU|AA|UU|\?\?)' |
            peco --query "$1" |
            awk '$0 = substr($0, 4)'
        )"
        local relative_prefix="$(git rev-parse --show-cdup)"
        if [[ -n "$selected" ]]; then
            selected="$(
                echo $selected |
                sed "s/^/$relative_prefix/g" |
                tr '\n' ' '
            )"
            __peco_print "git add $selected"
        fi
    }
    function __peco-select-git-add() {
        __peco_zle "$(peco-select-git-add "$LBUFFER")" 1
    }
    zle -N __peco-select-git-add
    bindkey "^X^G^A" __peco-select-git-add


    function peco-select-git-rm() {
        local selected="$(
            git status --porcelain |
            grep -E '^([ MARC][MDT]|DM|DD|AU|UD|UA|DU|AA|UU|\?\?)' |
            peco --query "$1" |
            awk '$0 = substr($0, 4)'
        )"
        local relative_prefix="$(git rev-parse --show-cdup)"
        if [[ -n "$selected" ]]; then
            selected="$(
                echo $selected |
                sed "s/^/$relative_prefix/g" |
                tr '\n' ' '
            )"
            __peco_print "git rm $selected"
        fi
    }
    function __peco-select-git-rm() {
        __peco_zle "$(peco-select-git-rm "$LBUFFER")" 1
    }
    zle -N __peco-select-git-rm
    bindkey "^X^G^D" __peco-select-git-rm


    function peco-select-git-reset() {
        local selected="$(
            git status --porcelain |
            grep -E '^([MARCT][ MD]|D[ M])' |
            peco --query "$1" |
            awk '$0 = substr($0, 4)'
        )"
        local relative_prefix="$(git rev-parse --show-cdup)"
        if [[ -n "$selected" ]]; then
            selected="$(
                echo $selected |
                sed "s/^/$relative_prefix/g" |
                tr '\n' ' '
            )"
            __peco_print "git reset $selected"
        fi
    }
    function __peco-select-git-reset() {
        __peco_zle "$(peco-select-git-reset "$LBUFFER")" 1
    }
    zle -N __peco-select-git-reset
    bindkey "^X^G^R" __peco-select-git-reset

    function peco-select-git-discard() {
        local selected="$(
            git status --porcelain |
            grep -E '^([ MARC][MDT]|DM|\?\?)' |
            peco --query "$1"
            awk '$0 = substr($0, 4)'
        )"
        local relative_prefix="$(git rev-parse --show-cdup)"
        # checkout from HEAD
        local unstaged_files="$(
            echo $selected |
            egrep -E '^([ MARC][MDT]|DM)' |
            awk '$0 = substr($0, 4)'
        )"
        if [[ -n "$unstaged_files" ]]; then
            unstaged_files="$(
                echo $unstaged_files |
                sed "s/^/$relative_prefix/g" |
                tr '\n' ' '
            )"
            unstaged_files="git checkout HEAD -- $unstaged_files"
        fi
        # delete files
        local untracked_files="$(
            echo $selected_files |
            grep -E '^\?\?' |
            awk '$0 = substr($0, 4)'
        )"
        if [[ -n "$untracked_files" ]]; then
            untracked_files="$(
                echo $untracked_files |
                sed "s/^/$relative_prefix/g" |
                tr '\n' ' '
            )"
            untracked_files="rm -r --interactive $untracked_files"
        fi
        if [[ -n "$unstaged_files" -a -n "$untracked_files" ]]; then
            __peco_print "$unstaged_files; $untracked_files"
        else
            __peco_print "$unstaged_files$untracked_files"
        fi
    }
    function __peco-select-git-discard() {
        __peco_zle "$(peco-select-git-discard "$LBUFFER")" 0
    }
    zle -N __peco-select-git-discard
    bindkey "^X^G^X" __peco-select-git-discard

    function peco-select-git-checkout () {
        local selected="$(
            git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads |
            perl -pne 's{^refs/heads/}{}' |
            peco --query "$1"
        )"
        [[ -n "$selected" ]] && __peco_print "git checkout $selected"
    }
    function __peco-select-git-checkout() {
        __peco_zle "$(peco-select-git-checkout "$LBUFFER")" 1
    }
    zle -N __peco-select-git-checkout
    bindkey "^X^G^C^C" __peco-select-git-checkout


    function peco-select-git-checkout-all () {
        local selected="$(
            git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads refs/remotes |
            perl -pne 's{^refs/(heads|remotes)/}{}' |
            peco --query "$1"
        )"
        [[ -n "$selected" ]] && __peco_print "git checkout $selected"
    }
    function __peco-select-git-checkout-all() {
        __peco_zle "$(peco-select-git-checkout "$LBUFFER")" 1
    }
    zle -N __peco-select-git-checkout-all
    bindkey "^X^G^C^A" __peco-select-git-checkout-all
fi


if type pyenv > /dev/null; then
    function peco-select-pyenv-install() {
        local selected="$(
            pyenv install --list |
            sed '1,1d' |
            sed 's/(^[[:space:]]*|[[:space:]]*$)//g' |
            peco --query "$1"
        )"
        [[ -n "$selected" ]] && __peco_print "pyenv install $selected"
    }
    function __peco-select-pyenv-install() {
        __peco_zle "$(peco-select-pyenv-install "$LBUFFER")" 1
    }
    zle -N __peco-select-pyenv-install
    bindkey "^X^P^I" __peco-select-pyenv-install


    function peco-select-pyenv-virtualenv-shell() {
        local selected="$(
            pyenv versions |
            sed 's/^..//g' |
            peco --query "$1"
        )"
        if [[ -n "$selected" ]]; then
            selected="$(echo "$selected" | awk '{ print $1 }')"
            [[ -n "$selected" ]] && __peco_print "pyenv shell $selected"
        fi
    }
    function __peco-select-pyenv-virtualenv-shell() {
        __peco_zle "$(peco-select-pyenv-virtualenv-shell "$LBUFFER")" 1
    }
    zle -N __peco-select-pyenv-virtualenv-shell
    bindkey "^X^P^E" __peco-select-pyenv-virtualenv-shell


    function peco-select-pyenv-virtualenv-local() {
        local selected="$(
            pyenv versions |
            sed 's/^..//g' |
            peco --query "$1"
        )"
        if [[ -n "$selected" ]]; then
            selected="$(echo "$selected" | awk '{ print $1 }')"
            [[ -n "$selected" ]] && __peco_print "pyenv local $selected"
        fi
    }
    function __peco-select-pyenv-virtualenv-local() {
        __peco_zle "$(peco-select-pyenv-virtualenv-local "$LBUFFER")" 1
    }
    zle -N __peco-select-pyenv-virtualenv-local


    function peco-select-pyenv-virtualenv-global() {
        global selected="$(
            pyenv versions |
            sed 's/^..//g' |
            peco --query "$1"
        )"
        if [[ -n "$selected" ]]; then
            selected="$(echo "$selected" | awk '{ print $1 }')"
            [[ -n "$selected" ]] && __peco_print "pyenv global $selected"
        fi
    }
    function __peco-select-pyenv-virtualenv-global() {
        __peco_zle "$(peco-select-pyenv-virtualenv-global "$LBUFFER")" 1
    }
    zle -N __peco-select-pyenv-virtualenv-global
fi
