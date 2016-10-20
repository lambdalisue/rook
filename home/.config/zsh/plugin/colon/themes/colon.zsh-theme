__colon::util::timeout() {
  command perl -e 'alarm shift; exec @ARGV' "$@"
}

__colong::util::git() {
  __colong::util::timeout 1 command git "$@" 2>/dev/null
}

__colon::util::eliminate_empty_elements() {
  for element in ${1[@]}; do
    [[ -n "$element" ]]; echo -en $element
  done
}

__colon::util::is_git_worktree() {
  [[ $(__colon::util::git rev-parse --is-inside-work-tree) == 'true' ]]
}

__colon::get_segment() {
  local text="$1"
  local fcolor="$2"
  local kcolor="$3"
  if [ -n "$fcolor" -a -n "$kcolor" ]; then
    echo -n "%{%K{$kcolor}%F{$fcolor}%}$text%{%k%f%}"
  elif [ -n "$fcolor" ]; then
    echo -n "%{%F{$fcolor}%}$text%{%f%}"
  elif [ -n "$kcolor" ]; then
    echo -n "%{%K{$kcolor}%}$text%{%k%}"
  else
    echo -n "$text"
  fi
}

__colon::get_host() {
  local fcolor='green'
  local kcolor=''
  # show hostname only when user connect to a remote machine
  if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
    __colon::get_segment "%m" $fcolor $kcolor
  fi
}

__colon::get_root() {
  local fcolor='white'
  local kcolor='red'
  # show hostname only when user connect to a remote machine
  if [ $(id -u) -eq 0 ]; then
    __colon::get_segment "%{%B%} %n %{%b%}" $fcolor $kcolor
  fi
}

__colon::get_time() {
  local fcolor=245
  local kcolor=''
  local date="%D{%H:%M}"
  __colon::get_segment "$date" $fcolor $kcolor
}

__colon::get_symbol() {
  local fcolor_normal='blue'
  local kcolor_normal=''
  local fcolor_error='red'
  local kcolor_error=''
  if [[ $1 > 0 ]]; then
    __colon::get_segment "%{%B%}:::%{%b%}" $fcolor_error $kcolor_error
  else
    __colon::get_segment "%{%B%}:::%{%b%}" $fcolor_normal $kcolor_normal
  fi
}

__colon::get_pwd() {
    local fcolor='blue'
    local kcolor=''
    local lock='⭤'
    local PWD="$(pwd)"
    # current path state
    local pwd_state
    if [[ ! -O "$PWD" ]]; then
        if [[ -w "$PWD" ]]; then
            pwd_state="%{%F{blue}%}$lock "
        elif [[ -x "$PWD" ]]; then
            pwd_state="%{%F{yellow}%}$lock "
        elif [[ -r "$PWD" ]]; then
            pwd_state="%{%F{red}%}$lock "
        fi
    fi
    if [[ ! -w "$PWD" && ! -r "$PWD" ]]; then
        pwd_state="%{%F{red}%}$lock "
    fi
    local pwd_path="%50<...<%~"
    __colon::get_segment "%{%B%}$pwd_state$pwd_path%{%f%b%}" $fcolor $kcolor
}

__colon::configure_prompt() {
    __colon::prompt_precmd() {
        local exitstatus=$?
        __colon::prompt_1st_bits=(
            "$(__colon::get_time)"
            "$(__colon::get_host)"
            "$(__colon::get_root)"
            "$(__colon::get_symbol $exitstatus)"
        )
        __colon::prompt_2nd_bits=(
            "$(__colon::get_cwd)"
        )
        # Remove empty elements
        __colon::prompt_1st_bits=${(M)__colon::prompt_1st_bits:#?*}
        __colon::prompt_2nd_bits=${(M)__colon::prompt_2nd_bits:#?*}
        # Array to String
        __colon::prompt_1st_bits=${(j: :)__colon::prompt_1st_bits}
        __colon::prompt_2nd_bits=${(j: :)__colon::prompt_2nd_bits}
    }
    add-zsh-hook precmd __colon::prompt_precmd

    PROMPT="\$__prompt_dust_prompt_1st_bits "
    RPROMPT=" \$__prompt_dust_prompt_2nd_bits"
}

{
    # load required modules
    autoload -Uz is-at-least
    autoload -Uz add-zsh-hook
    autoload -Uz colors && colors
    # enable variable extraction in prompt
    setopt prompt_subst
    # configure VCS
    #__prompt_dust_configure_vcsstyles
    # configure PROMPT
    __colon::configure_prompt
}
# vim: ft=zsh
