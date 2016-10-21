export FZF_DEFAULT_OPTS="--extended --cycle --ansi --select-1"

__str::tail() {
  echo "$1" | awk '{print $NF}'
}

# ^T: File {{{
fzf::file() {
  print -z $(__fzf::file $1)
}

__fzf::file() {
  local query=$(__str::tail $1)
  local s="$(pt --hidden -g "" --ignore=.git | fzf --query "$query")"
  [[ -n $s ]] && print "$s"
}

__fzf::file::zle() {
  BUFFER="$BUFFER $(__fzf::file $BUFFER)"
  CURSOR=$#BUFFER
  zle redisplay
  zle zle-line-init
}

zle -N __fzf::file::zle
bindkey '^T' __fzf::file::zle

# }}}

# ^R: History {{{
fzf::history() {
  print -z $(__fzf::history $1)
}

__fzf::history() {
  local query=$(__str::tail $1)
  local s="$(fc -l -n 1 | fzf --query "$query")"
  [[ -n $s ]] && print "$s"
}

__fzf::history::zle() {
  BUFFER="$BUFFER $(__fzf::history $BUFFER)"
  CURSOR=$#BUFFER
  zle redisplay
  zle zle-line-init
}

zle -N __fzf::history::zle
bindkey '^R' __fzf::history::zle
# }}}

# ^D: CDR {{{
fzf::cdr() {
  print -z $(__fzf::cdr $1)
}

__fzf::cdr() {
  local query=$(__str::tail $1)
  local s="$(cdr -l | sed 's/^[0-9]*\s*//' | fzf --query "$query")"
  [[ -n $s ]] && print "cd $s"
}

__fzf::cdr::zle() {
  BUFFER=$(__fzf::cdr $BUFFER)
  [[ -n $BUFFER ]] && zle accept-line
  zle clear-screen
}

zle -N __fzf::cdr::zle
bindkey '^D' __fzf::cdr::zle
# }}}

# ^X^K: Kill {{{
fzf::kill() {
  print -z $(__fzf::kill $1)
}

__fzf::kill() {
  local query=$(__str::tail $1)
  local s="$(ps -ef | fzf --query "$query")"
  [[ -n $s ]] && print "kill $(echo $s | awk '{print $2}')"
}

__fzf::kill::zle() {
  BUFFER=$(__fzf::kill $BUFFER)
  [[ -n $BUFFER ]] && zle accept-line
  zle clear-screen
}

zle -N __fzf::kill::zle
bindkey '^X^K' __fzf::kill::zle
# }}}

# ^X^H: Homeshick {{{
fzf::homeshick() {
  print -z $(__fzf::homeshick $1)
}

__fzf::homeshick() {
  local query=$(__str::tail $1)
  local s="$(homeshick list | fzf --tac --query "$query")"
  [[ -n $s ]] && print "homeshick cd $(echo $s | awk '{print $1}')"
}

__fzf::homeshick::zle() {
  BUFFER=$(__fzf::homeshick $BUFFER)
  [[ -n $BUFFER ]] && zle accept-line
  zle clear-screen
}

zle -N __fzf::homeshick::zle
bindkey '^X^H' __fzf::homeshick::zle
# }}}

# ^X^S: GHQ {{{
fzf::ghq() {
  print -z $(__fzf::ghq $1)
}

__fzf::ghq() {
  local query=$(__str::tail $1)
  local s="$(ghq list --full-path | fzf --query "$query")"
  [[ -n $s ]] && print "cd $(echo $s | awk '{print $1}')"
}

__fzf::ghq::zle() {
  BUFFER=$(__fzf::ghq $BUFFER)
  [[ -n $BUFFER ]] && zle accept-line
  zle clear-screen
}

zle -N __fzf::ghq::zle
bindkey '^X^S' __fzf::ghq::zle
# }}}

# fshow - git commit browser (enter for show, ctrl-d for diff) {{{
fshow() {
  local out shas sha q k
  while out=$(
      git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" \
          --print-query --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = ctrl-d ]; then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}
# }}}

# vim: foldmethod=marker
