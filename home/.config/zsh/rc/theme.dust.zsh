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
__prompt_dust_eliminate_empty_elements() {
    for element in ${1[@]}; do
        [[ -n "$element" ]]; echo -en $element
    done
}
__prompt_dust_configure_vcsstyles() {
    local branchfmt="%b:%r"
    local actionfmt="%a%f"

    # $vcs_info_msg_0_ : Normal
    # $vcs_info_msg_1_ : Warning
    # $vcs_info_msg_2_ : Error
    zstyle ':vcs_info:*:dust:*' max-exports 3

    zstyle ':vcs_info:*:dust:*' enable git svn hg bzr
    zstyle ':vcs_info:*:dust:*' formats "%s $branchfmt"
    zstyle ':vcs_info:*:dust:*' actionformats "%s $branchfmt" '%m' '<!%a>'

    if is-at-least 4.3.10; then
        zstyle ':vcs_info:git:dust:*' formats "$branchfmt" '%m'
        zstyle ':vcs_info:git:dust:*' actionformats "$branchfmt" '%m' '<!%a>'
    fi

    if is-at-least 4.3.11; then
        zstyle ':vcs_info:git+set-message:*' hooks \
            git-hook-begin \
            git-status \
            git-push-status \
            git-pull-status

        function +vi-git-hook-begin() {
            if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
                # stop further hook functions
                return 1
            fi
            return 0
        }
        function +vi-git-status() {
            # do not handle except the 2nd message of zstyle formats, actionformats
            if [[ "$1" != "1" ]]; then
                return 0
            fi
            local gitstatus="$(command git status --ignore-submodules=all --porcelain 2> /dev/null)"
            if [[ $? == 0 ]]; then
                local staged="$(command echo $gitstatus | command grep -E '^([MARC][ MD]|D[ M])' | wc -l | tr -d ' ')"
                local unstaged="$(command echo $gitstatus | command grep -E '^([ MARC][MD]|DM)' | wc -l | tr -d ' ')"
                local untracked="$(command echo $gitstatus | command grep -E '^\?\?' | wc -l | tr -d ' ')"
                local indicator="$(__prompt_dust_get_config 'character' 'indicator')"
                local -a messages
                [[ $staged > 0    ]] && messages+=( "%{%F{blue}%}$indicator%{%f%}" )
                [[ $unstaged > 0  ]] && messages+=( "%{%F{red}$indicator%{%f%}" )
                [[ $untracked > 0 ]] && messages+=( "%{%F{yellow}%}$indicator%{%f%}" )
                hook_com[misc]+="%{%B%}${(j::)messages}%{%b%}"
            fi
        }
        function +vi-git-push-status() {
            # do not handle except the 2nd message of zstyle formats, actionformats
            if [[ "$1" != "1" ]]; then
                return 0
            fi

            # get the number of commits ahead of remote
            local ahead
            ahead=$(command git log --oneline @{upstream}.. 2>/dev/null \
                | wc -l \
                | tr -d ' ')

            if [[ "$ahead" -gt 0 ]]; then
                if [[ ! "${hook_com[misc]}" =~ '^[ ]*$' ]]; then
                    hook_com[misc]+=" "
                fi
                hook_com[misc]+="%{%B%F{magenta}%}>${ahead}%{%b%f%}"
            fi
        }
        function +vi-git-pull-status() {
            # do not handle except the 2nd message of zstyle formats, actionformats
            if [[ "$1" != "1" ]]; then
                return 0
            fi

            # get the number of commits behind remote
            local behind
            behind=$(command git log --oneline ..@{upstream} 2>/dev/null \
                | wc -l \
                | tr -d ' ')

            if [[ "$behind" -gt 0 ]]; then
                if [[ ! "${hook_com[misc]}" =~ '^[ ]*$' ]]; then
                    hook_com[misc]+=" "
                fi
                hook_com[misc]+="%{%B%F{cyan}%}${behind}<%{%b%f%}"
            fi
        }
    fi
}

__prompt_dust_configure_prompt() {
    __prompt_dust_prompt_precmd() {
        local exitstatus=$?
        __prompt_dust_prompt_1st_bits=()
        __prompt_dust_prompt_1st_bits+=(\
            "$(__prompt_dust_get_pwd)"
            "$(__prompt_dust_get_vcs)"
            "$(__prompt_dust_get_datetime)"
        )
        __prompt_dust_prompt_2nd_bits=(
            "$(__prompt_dust_get_userinfo)"
            "$(__prompt_dust_get_symbol $exitstatus)"
        )
        # Remove empty elements
        __prompt_dust_prompt_1st_bits=${(M)__prompt_dust_prompt_1st_bits:#?*}
        __prompt_dust_prompt_2nd_bits=${(M)__prompt_dust_prompt_2nd_bits:#?*}
        # Array to String
        __prompt_dust_prompt_1st_bits=${(j: :)__prompt_dust_prompt_1st_bits}
        __prompt_dust_prompt_2nd_bits=${(j: :)__prompt_dust_prompt_2nd_bits}
    }
    add-zsh-hook precmd __prompt_dust_prompt_precmd

    local prompt_newline=$'\n'
    PROMPT="\$__prompt_dust_prompt_1st_bits$prompt_newline\$__prompt_dust_prompt_2nd_bits "
}

__prompt_dust_get_userinfo() {
    local fcolor_user=245
    local bcolor_user=''
    local fcolor_host='green'
    local bcolor_host=''
    # show hostname only when user connect to a remote machine
    local host=""
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        host="%m"
    fi
    local user=""
    if [[ "$USER" != "alisue" ]]; then
        user="%n"
    fi
    if [ -n "$host" -a -n "$user" ]; then
        __prompt_dust_get_segment "$user" $fcolor_user $kcolor_user
        echo -en "@"
        __prompt_dust_get_segment "$host" $fcolor_host $kcolor_host
    elif [ -n "$host" ]; then
        __prompt_dust_get_segment "$host" $fcolor_user $kcolor_user
    elif [ -n "$user" ]; then
        __prompt_dust_get_segment "$user" $fcolor_user $kcolor_user
    fi
}
__prompt_dust_get_pwd() {
    local fcolor='blue'
    local kcolor=''
    local lock=$(__prompt_dust_get_config 'character' 'lock')
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
    local pwd_path="%69<...<%~"
    __prompt_dust_get_segment "%{%B%}$pwd_state$pwd_path%{%f%b%}" $fcolor $kcolor
}
__prompt_dust_get_symbol() {
    local fcolor_normal='blue'
    local kcolor_normal=''
    local fcolor_error='red'
    local kcolor_error=''
    local bullet=$(__prompt_dust_get_config 'character' 'bullet')
    if [[ $1 > 0 ]]; then
        __prompt_dust_get_segment "%{%B%}$bullet%?$bullet>%{%b%}" $fcolor_error $kcolor_error
    else
        __prompt_dust_get_segment "%{%B%}$bullet>%{%b%}" $fcolor_normal $kcolor_normal
    fi
}
__prompt_dust_get_datetime() {
    local fcolor=245
    local kcolor=''
    local date="%D{%Y/%m/%d %H:%M:%S}"    # Datetime YYYY/mm/dd HH:MM
    __prompt_dust_get_segment "$date" $fcolor $kcolor
}
__prompt_dust_get_vcs() {
    local fcolor_normal='green'
    local fcolor_error='red'
    local kcolor_normal=''
    local kcolor_error=''
    vcs_info 'dust'
    [[ ! "$vcs_info_msg_0_" =~ "^[ ]*$" ]] && __prompt_dust_get_segment "$vcs_info_msg_0_" $fcolor_normal  $kcolor_normal
    [[ ! "$vcs_info_msg_1_" =~ "^[ ]*$" ]] && __prompt_dust_get_segment " %{%B%}$vcs_info_msg_1_%{%b%}"
    [[ ! "$vcs_info_msg_2_" =~ "^[ ]*$" ]] && __prompt_dust_get_segment " $vcs_info_msg_2_" $fcolor_error   $kcolor_error
}

function() {
    # load required modules
    autoload -Uz vcs_info
    autoload -Uz is-at-least
    autoload -Uz add-zsh-hook
    autoload -Uz colors && colors
    # enable variable extraction in prompt
    setopt prompt_subst
    # configure default options
    if [[ "$LANG" == "C" ]]; then
        __prompt_dust_set_config 'character' 'bullet' '*'
        __prompt_dust_set_config 'character' 'indicator' '*'
        __prompt_dust_set_config 'character' 'lock' '!'
    else
        __prompt_dust_set_config 'character' 'bullet' '•'
        __prompt_dust_set_config 'character' 'indicator' '•'
        __prompt_dust_set_config 'character' 'lock' '⭤'
    fi
    # configure VCS
    __prompt_dust_configure_vcsstyles
    # configure PROMPT
    __prompt_dust_configure_prompt
}
