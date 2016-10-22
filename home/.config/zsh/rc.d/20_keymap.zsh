# Use Emacs like binding
bindkey -e

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
