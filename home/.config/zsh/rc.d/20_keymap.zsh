# Use Emacs like binding
bindkey -e

## allow v to edit the command line (standard behaviour)
#autoload -Uz edit-command-line
#bindkey -M vicmd 'v' edit-command-line

## cycle history with C-p/C-n
#autoload history-search-end
#zle -N history-beginning-search-backward-end history-search-end
#zle -N history-beginning-search-forward-end history-search-end
#bindkey "^p" history-beginning-search-backward-end
#bindkey "^n" history-beginning-search-forward-end
#
## allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
#bindkey '^?' backward-delete-char
#bindkey '^h' backward-delete-char
#bindkey '^w' backward-kill-word
#
#bindkey -a 'gg' beginning-of-buffer-or-history
#bindkey -a 'g~' vi-oper-swap-case
#bindkey -a G end-of-buffer-or-history
#bindkey -a u undo
#bindkey -a '^R' redo
#bindkey '^G' what-cursor-position
#
## select completion menu with hjkl
#zmodload zsh/complist
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
