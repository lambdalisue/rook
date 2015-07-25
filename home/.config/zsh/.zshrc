# disable promptcr to display last line without newline
unsetopt promptcr

# Disable Ctrl-D logout
setopt IGNOREEOF

# print character as eight bit to prevent mojibake
setopt print_eight_bit

# use ASCII in linux server
if [[ "${TERM}" = "linux" ]]; then
    LANG=C
fi

# create ZDOTDIR if not exists
if [[ ! -d "$ZDOTDIR" ]]; then
    mkdir -p "$ZDOTDIR"
fi

# report time when the process takes over 3 seconds
REPORTTIME=3

# enable completion in --prefix=~/local or whatever
setopt magic_equal_subst

# enable 256 colors in terminal
if [ -n "$DISPLAY" -a "$TERM" = "xterm" ]; then
    export TERM="xterm-256color"
elif [ -n "$DISPLAY" -a "$TERM" = "rxvt" ]; then
    export TERM="rxvt-256color"
elif [ -n "$DISPLAY" -a "$TERM" = "rxvt-unicode" ]; then
    export TERM="rxvt-unicode-256color"
elif [ -n "$DISPLAY" -a "$TERM" = "screen" ]; then
    export TERM="screen-256color"
fi

# Movement {{{
WORDCHARS=${WORDCHARS:s,/,,} # Exclude / so you can delete path with ^W
setopt auto_cd               # Automatically change directory when path has input
setopt auto_pushd            # Automatically push previous directory to stack
                             # thus you can pop previous directory with `popd` command
                             # or select from list with `cd <tab>`
setopt pushd_ignore_dups     # Ignore duplicate directory in pushd

if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*:*:cdr:*:*' menu selection
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-max 500
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/chpwd-recent-dirs"
    zstyle ':chpwd:*' recent-dirs-pushd true

    if [[ ! -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/" ]]; then
        mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/"
    fi
fi
#}}}

# History {{{
HISTFILE=${ZDOTDIR}/.zsh_history
HISTSIZE=10000000
SAVEHIST=$HISTSIZE
setopt extended_history      # save execution time and span in history
setopt hist_ignore_all_dups  # ignore duplicate history
setopt hist_ignore_dups      # ignore previous duplicate history
setopt hist_save_no_dups     # remove old one when duplicated
setopt hist_ignore_space     # ignore commands which stars with space
setopt inc_append_history    # immidiately append history to history file
setopt share_history         # share history in zsh processes
setopt no_flow_control       # do not use C-s/C-q
#}}}

# Completion {{{
autoload -Uz compinit && compinit -C

setopt complete_in_word      # complete at carret position
setopt glob_complete         # complete without expanding glob
setopt hist_expand           # expand history when complete
setopt correct               # show suggestion list when user type wrong command
setopt list_packed           # show completion list smaller (pack)
setopt nolistbeep            # stop beep.
setopt noautoremoveslash     # do not remove postfix slash of command line

# enable bash complete
autoload -Uz bashcompinit && bashcompinit

# ambiguous completion search when no match found
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'

# allow to select suggestions with arrow keys
zstyle ':completion:*:default' menu select

# color completion list
zstyle ':completion:*:default' list-colors ''

# add SUDO_PATH to completion in sudo
zstyle ':completion:*:sudo:*' environ PATH="$SUDO_PATH:$PATH"

# bold the completion list item
zstyle ':completion:*' format "%{$fg[blue]%}--- %d ---%f"

# group completion list
zstyle ':completion:*' group-name ''

# use cache
zstyle ':completion:*' use-cache yes

# use detailed completion
zstyle ':completion:*' verbose yes
# how to find the completion list?
# - _complete:      complete
# - _oldlist:       complete from previous result
# - _match:         complete from the suggestin without expand glob
# - _history:       complete from history
# - _ignored:       complete from ignored
# - _approximate:   complete from approximate suggestions
# - _prefix:        complete without caring the characters after carret
zstyle ':completion:*' completer \
    _complete \
    _match \
    _approximate \
    _oldlist \
    _history \
    _ignored \
    _prefix
#}}}

# Key mappings {{{
bindkey -v

# create a zkbd compatible hash
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# }}}

# add extra path
__add_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="${PATH:+"$PATH":}$1"
    fi
}
__add_manpath() {
    if [ -d "$1" ] && [[ ":$MANPATH:" != *":$1:"* ]]; then
        export MANPATH="${MANPATH:+"$MANPATH":}$1"
    fi
}
__add_path "$HOME/.go/bin"
__add_path "$HOME/.cabal/bin"
__add_path "$HOME/.pyenv/bin"
__add_path "$HOME/.anyenv/bin"
__add_path "$HOME/.phantomjs/bin"
__add_path "$HOME/.vim/bundle/vim-themis/bin"
__add_path "/usr/local/texlive/2014/bin/i386-linux"
__add_path "/usr/local/texlive/2014/bin/i386-darwin"
__add_path "/usr/local/texlive/2014/bin/x86_64-linux"
__add_path "/usr/local/texlive/2014/bin/x86_64-darwin"
__add_manpath "/usr/local/texlive/texmf-dist/doc/man"

if [ $(uname) = "Darwin" ]; then
    __add_path "${ZDOTDIR}/tools/pt/pt_darwin_amd64"
else
    __add_path "${ZDOTDIR}/tools/pt/pt_linux_amd64"
fi

# source external settings
for filename in ${ZDOTDIR}/rc/*.zsh; do
    if [ ! -f ${filename}.zwc -o ${filename} -nt ${filename}.zwc ]; then
        zcompile ${filename}
    fi
    source ${filename}
done

# install and configure external plugins
zundle_install "zsh-users/zsh-syntax-highlighting"
zundle_install "zsh-users/zsh-completions"

# fundemental functions
zsh_reload_rc() {
    source ${ZDOTDIR}/.zshrc
}

# Load local configures
[[ -f "$HOME/.profile" ]] && source "$HOME/.profile"

# compile zshenv/zshrc
if [ ! -f ${ZDOTDIR}/.zshenv.zwc -o ${ZDOTDIR}/.zshenv -nt ${ZDOTDIR}/.zshenv.zwc ]; then
    zcompile ${ZDOTDIR}/.zshenv
fi
if [ ! -f ${ZDOTDIR}/.zshrc.zwc -o ${ZDOTDIR}/.zshrc -nt ${ZDOTDIR}/.zshrc.zwc ]; then
    zcompile ${ZDOTDIR}/.zshrc
fi
