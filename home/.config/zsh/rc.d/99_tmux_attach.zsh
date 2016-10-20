__tmuxx::is_tmux_running() {
  [ ! -z "$TMUX" ]
}

__tmuxx::has_shell_started_interactively() {
  [ ! -z "$PS1" ]
}

__tmuxx::is_ssh_running() {
  [ ! -z "$SSH_CONECTION" ]
}

__tmuxx::main() {
  if __tmuxx::is_tmux_running; then
    echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
    echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
    echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
    echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
    echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
  else
    if __tmuxx::has_shell_started_interactively && ! __tmuxx::is_ssh_running; then
      if ! __rook::has 'tmux'; then
        echo 'Error: tmux command not found' 2>&1
        return 1
      fi

      if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        # detached session exists
        tmux list-sessions
        echo -n "Tmux: attach? (y/N/num) "
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

__tmuxx::main
