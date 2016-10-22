__tmux::is_tmux_running() {
  [ ! -z "$TMUX" ]
}

__tmux::has_shell_started_interactively() {
  [ ! -z "$PS1" ]
}

__tmux::is_ssh_running() {
  [ ! -z "$SSH_CONECTION" ]
}

__tmux::main() {
  if __tmux::is_tmux_running; then
    return 1
  else
    if __tmux::has_shell_started_interactively && ! __tmux::is_ssh_running; then
      if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        # detached session exists
        tmux list-sessions
        echo -n "Tmux: attach? (Y/n/{num}) "
        read
        if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
          tmux attach-session
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
          tmux attach -t "$REPLY"
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        fi
      fi

      if __rook::is_osx && __rook::has 'reattach-to-user-namespace'; then
        # on OS X force tmux's default command
        # to spawn a shell in the user's namespace
        tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
        tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
      else
        tmux new-session && echo "tmux created new session"
      fi
    fi
  fi
}

__tmux::main
