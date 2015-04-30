#
# ZSH theme "dust"
#
__prompt_dust_set_config() {
    zstyle ":prompt:dust:$1" $2 $3
}
__prompt_dust_get_config() {
    local value
    zstyle -s ":prompt:dust:$1" $2 value
    echo -en "$value"
}
__prompt_dust_get_segment() {
    local text="$1"
    local fcolor="$2"
    local kcolor="$3"
    if [ -n "$fcolor" -a -n "$kcolor" ]; then
        echo -en "%{%K{$kcolor}%F{$fcolor}%}$text%{%k%f%}"
    elif [ -n "$fcolor" ]; then
        echo -en "%{%F{$fcolor}%}$text%{%f%}"
    elif [ -n "$kcolor" ]; then
        echo -en "%{%K{$kcolor}%}$text%{%k%}"
    else
        echo -en "$text"
    fi
}
__prompt_dust_configure_vcsstyles() {
    local branchfmt="• %b:%r"
    local actionfmt="%a%f"

    # $vcs_info_msg_0_ : Normal
    # $vcs_info_msg_1_ : Warning
    # $vcs_info_msg_2_ : Error
    zstyle ':vcs_info:*:dust:*' max-exports 3

    zstyle ':vcs_info:*:dust:*' enable git svn hg bzr
    zstyle ':vcs_info:*:dust:*' formats "%s $branchfmt"
    zstyle ':vcs_info:*:dust:*' actionformats "%s $branchfmt" '%m' '<!%a>'
    zstyle ':vcs_info:bzr:dust:*' use-simple true

    if is-at-least 4.3.10; then
        zstyle ':vcs_info:git:dust:*' formats $branchfmt '[%c%u] %m'
        zstyle ':vcs_info:git:dust:*' actionformats $branchfmt '[%c%u] %m' '<!%a>'
        zstyle ':vcs_info:git:dust:*' check-for-changes true
        zstyle ':vcs_info:git:dust:*' stagedstr "+"
        zstyle ':vcs_info:git:dust:*' unstagedstr "-"
    fi
}
__prompt_dust_configure_prompt() {
    __prompt_dust_prompt_precmd() {
        local exitstatus=$?
        __prompt_dust_prompt_1st_bits=()
        __prompt_dust_prompt_1st_bits+=(\
            "$(__prompt_dust_get_datetime)"
            "$(__prompt_dust_get_userinfo)"
            "$(__prompt_dust_get_pwd)"
            "$(__prompt_dust_get_vcs)"
        )
        __prompt_dust_prompt_2nd_bits=(
            "$(__prompt_dust_get_symbol $exitstatus)"
            ""
        )
        # Array to String
        __prompt_dust_prompt_1st_bits=${(j: :)__prompt_dust_prompt_1st_bits}
        __prompt_dust_prompt_2nd_bits=${(j: :)__prompt_dust_prompt_2nd_bits}
    }
    add-zsh-hook precmd __prompt_dust_prompt_precmd

    local prompt_newline=$'\n'
    PROMPT="\$__prompt_dust_prompt_1st_bits$prompt_newline\$__prompt_dust_prompt_2nd_bits"
}

__prompt_dust_get_userinfo() {
    local fcolor_user=8
    local bcolor_user=''
    local fcolor_host='green'
    local bcolor_host=''
    # show hostname only when user connect to a remote machine
    local host=""
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        host="%m"
    fi
    local user="$USER"
    if [ -n "$host" -a -n "$user" ]; then
        __prompt_dust_get_segment "$user" $fcolor_user $kcolor_user
        echo -en "@"
        __prompt_dust_get_segment "$host" $fcolor_host $kcolor_host
    else
        __prompt_dust_get_segment "$user" $fcolor_user $kcolor_user
    fi
}
__prompt_dust_get_pwd() {
    local fcolor='blue'
    local kcolor=''
    local lock="⭤"
    # current path state
    local pwd_state
    if [[ ! -O $PWD ]]; then
        if [[ -w $PWD ]]; then
            pwd_state="%{%F{blue}%}$lock "
        elif [[ -x $PWD ]]; then
            pwd_state="%{%F{yellow}%}$lock "
        elif [[ -r $PWD ]]; then
            pwd_state="%{%F{red}%}$lock "
        fi
    fi
    if [[ ! -w $PWD && ! -r $PWD ]]; then
        pwd_state="%{%F{red}%}$lock "
    fi
    local pwd_path="%39<...<%~"
    __prompt_dust_get_segment "%{%B%}$pwd_state$pwd_path%{%f%b%}" $fcolor $kcolor
}
__prompt_dust_get_symbol() {
    local fcolor='white'
    local kcolor='red'
    if [[ $1 > 0 ]]; then
        __prompt_dust_get_segment "%{%B%}•%?•>%{%b%}" "red"
    else
        __prompt_dust_get_segment "%{%B%}•>%{%b%}" "blue"
    fi
}
__prompt_dust_get_datetime() {
    local fcolor=8
    local kcolor=''
    local date="%D{%Y/%m/%d %H:%M:%S}"    # Datetime YYYY/mm/dd HH:MM
    __prompt_dust_get_segment "$date" $fcolor $kcolor
}
__prompt_dust_get_vcs() {
    local fcolor_normal='white'
    local fcolor_warning='yellow'
    local fcolor_error='red'
    local kcolor_normal=''
    local kcolor_warning=''
    local kcolor_error=''
    vcs_info 'dust'
    if [[ -n "$vcs_info_msg_0_" ]]; then
        __prompt_dust_get_segment "$vcs_info_msg_0_ " $fcolor_normal $kcolor_normal
        __prompt_dust_get_segment "$vcs_info_msg_1_ " $fcolor_warning $kcolor_warning
        __prompt_dust_get_segment "$vcs_info_msg_2_ " $fcolor_error $kcolor_error
    fi
}

function() {
    # load required modules
    autoload -Uz vcs_info
    autoload -Uz is-at-least
    autoload -Uz add-zsh-hook
    autoload -Uz colors && colors
    # enable variable extraction in prompt
    setopt prompt_subst
    # configure VCS
    __prompt_dust_configure_vcsstyles
    # configure PROMPT
    __prompt_dust_configure_prompt
    # remove non-necessary functions
    unset -f __prompt_dust_configure_vcsstyles
}
