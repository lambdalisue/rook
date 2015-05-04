if [ $(uname) = "Darwin" ]; then
    __add_path "${ZDOTDIR}/tools/peco/peco_darwin_amd64"
else
    __add_path "${ZDOTDIR}/tools/peco/peco_linux_amd64"
fi

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history

function peco-select-directory() {
    local selected_dir=$(
        cdr -l |
        awk '{ print $2 }' |
        peco --query "$LBUFFER"
    )
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-select-directory

function peco-kill-process() {
    ps -ef | peco | awk '{ print $2 }' | xargs kill
    zle clear-screen
}
zle -N peco-kill-process

function peco-src () {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src

function peco-homeshick () {
    local selected_dir=$(
        homeshick list |
        perl -pe 's/\e\[?.*?[\@-~]//g' |
        awk ' { print $1 }' |
        peco --query "$LBUFFER"
    )
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${HOME}/.homesick/repos/${selected_dir}"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-homeshick

function peco-select-gitadd() {
    local selected_file=$(
        git status --porcelain |
        egrep -E '^([ MARC][MD]|DM|DD|AU|UD|UA|DU|AA|UU)' |
        peco --query "$LBUFFER" |
        awk '$0 = substr($0, 4)'
    )
    if [ -n "$selected_file" ]; then
        BUFFER="git add $(git rev-parse --show-cdup)$selected_file"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-select-gitadd

function peco-select-gitreset() {
    local selected_file=$(
        git status --porcelain |
        egrep -E '^([MARC][ MD]|D[ M])' |
        peco --query "$LBUFFER" |
        awk '$0 = substr($0, 4)'
    )
    if [ -n "$selected_file" ]; then
        BUFFER="git reset $(git rev-parse --show-cdup)$selected_file"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-select-gitadd

function peco-select-gitcheckout () {
    local selected_branch=$(
        git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads |
        perl -pne 's{^refs/heads/}{}' |
        peco --query "$LBUFFER"
    )
    if [ -n "$selected_branch" ]; then
        BUFFER="git checkout ${selected_branch}"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-select-gitcheckout

function peco-select-gitcheckout-all () {
    local selected_branch=$(
        git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads refs/remotes |
        perl -pne 's{^refs/(heads|remotes)/}{}' |
        peco --query "$LBUFFER"
    )
    if [ -n "$selected_branch" ]; then
        BUFFER="git checkout -t ${selected_branch}"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-select-gitcheckout-all

bindkey '^S'      peco-select-history

bindkey '^X^R'      peco-select-history
bindkey "^X^J"      peco-select-directory
bindkey '^X^K'      peco-kill-process
bindkey '^X^S'      peco-src
bindkey '^X^H'      peco-homeshick

bindkey "^G^A"      peco-select-gitadd
bindkey '^G^C'      peco-select-gitcheckout
bindkey '^G^C^A'    peco-select-gitcheckout-all
