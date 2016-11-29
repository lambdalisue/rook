# ls - use GNU ls when available.
# ps - display processes related to the user
if __rook::is_osx; then
  if __rook::has 'gnuls'; then
      alias ls="gnuls --color=always"
      alias la="ls -lhAF"
  else
      alias ls="ls -G -w"
      alias la="ls -lhAFG"
  fi
  alias ps="ps -fU$(whoami)"
else
  alias ls="ls --color=always"
  alias la="ls -lhAF"
  alias ps="ps -fU$(whoami) --forest"
  alias ll="ls -lhAF --color=always | less -iMRS"
fi

# less
#   M - display percentage and filename
#   i - ignore case in search
#   R - display ANSI color escape sequence as colors
#   N - show linenumber (heavy)
#   S - do not wrap long lines
export LESS="-iMRS"

# lv
export LV="-c"
if __rook::has 'lv'; then
    alias lv=less
fi

# use GNU grep if possible
if __rook::has 'ggrep'; then
    alias grep=ggrep
fi

# use GNU sed if possible
if __rook::has 'gsed'; then
    alias sed=gsed
fi

# use GNU timeout if possible
if __rook::has 'gtimeout'; then
    alias timeout=gtimeout
fi

# vim
export EDITOR=vim
export MANPAGER="vim -c MANPAGER -"
alias view="vim -c PAGER"

if ! __rook::has 'vim'; then
    alias vim=vi
fi
alias vimm="vim -u ~/.vim/vimrc.min -i NONE"

if __rook::has 'nvim'; then
  export EDITOR=nvim
  export MANPAGER="nvim -c MANPAGER -"
fi

# hub
if __rook::has 'hub'; then
  hub() {
    unset -f hub
    eval "$(command hub alias -s)"
    command hub "$@"
  }
  alias git=hub
fi

# xdg-open
if __rook::has 'xdg-open'; then
  open() {
    xdg-open $@ >/dev/null 2>&1
  }
fi

# anyenv
if __rook::has 'anyenv'; then
  eval "$(anyenv init - zsh)"
  pyenv() {
    unset -f pyenv
    eval "$(pyenv virtualenv-init - zsh)"
    pyenv "$@"
  }
else
  if __rook::has 'pyenv'; then
    eval "$(pyenv init - zsh)"
    pyenv() {
      unset -f pyenv
      eval "$(pyenv virtualenv-init - zsh)"
      pyenv "$@"
    }
  fi
  if __rook::has 'ndenv'; then
    eval "$(ndenv init - zsh)"
  fi
  if __rook::has 'plenv'; then
    eval "$(plenv init - zsh)"
  fi
  if __rook::has 'rbenv'; then
    eval "$(rbenv init - zsh)"
  fi
fi

# gulp
if __rook::has 'gulp'; then
  gulp() {
    unset -f gulp
    eval "$(command gulp --completion=zsh)"
    command gulp "$@"
  }
fi

# go
export GOPATH="$HOME/.go"

# ghq
if __rook::has 'ghq'; then
  fpath=(
      $GOPATH/src/github.com/motemen/ghq/zsh/_ghq(N-/)
      $fpath
  )
fi

# Amber
if [[ -d "$HOME/amber14/" ]]; then
    export AMBERHOME="$HOME/amber14"
    source $AMBERHOME/amber.sh
fi

# pip
if __rook::has 'pip'; then
  pip() {
    unset -f pip
    eval "$(command pip completion --zsh)"
    command pip "$@"
  }
fi

if __rook::has 'pip2'; then
  pip2() {
    unset -f pip2
    eval "$(command pip2 completion --zsh)"
    command pip2 "$@"
  }
fi

if __rook::has 'pip3'; then
  pip3() {
    unset -f pip3
    eval "$(command pip3 completion --zsh)"
    command pip3 "$@"
  }
fi

# Homeshick
if [[ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]]; then
  homeshick() {
    unset -f homeshick
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    homeshick "$@"
  }
fi
