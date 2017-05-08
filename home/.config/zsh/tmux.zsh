__tmux::is_tmux_running() {
  [ -n "$TMUX" ]
}

__tmux::has_shell_started_interactively() {
  [ -n "$PS1" ]
}

__tmux::is_ssh_running() {
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]
}

__tmux::main() {
  if __tmux::is_tmux_running; then
    return 1
  elif __tmux::is_ssh_running; then
    return 1
  elif __tmux::has_shell_started_interactively; then
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
    tmux new-session && echo "tmux created new session"
  fi
}
__tmux::main
