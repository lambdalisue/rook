# Ensures that $terminfo values are valid and updates editor information when
# the keymap changes.
zle -N zle-line-init
zle -N zle-line-finish
function zle-line-init zle-line-finish {
    # The terminal must be in application mode when ZLE is active for $terminfo
    # values to be valid.
    if (( ${+terminfo[smkx]} )); then
        # enable terminal application mode
        echoti smkx
    elif (( ${+terminfo[rmkx]} )); then
        # disable terminal application mode
        echoti rmkx
    fi
    zle reset-prompt
    zle -R
}

# Use Vi like binding
bindkey -v

# Cycle history search with C-p/C-n
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Enable substring search by Up/Down
if [[ -d $HOME/.zplug/repos/zsh-users/zsh-history-substring-search ]]; then
  bindkey "[A" history-substring-search-up
  bindkey "[B" history-substring-search-down
fi

# Select completion menu with hjkl
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Make viins like emacs
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  x-kill-line
bindkey -M viins '^U'  x-backward-kill-line
bindkey -M viins '^W'  x-backward-kill-word
bindkey -M viins '^Y'  x-yank
