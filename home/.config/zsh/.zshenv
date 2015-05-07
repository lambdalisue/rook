# ignore duplicated path
typeset -U path

# (N-/): do not register if the directory is not exists
#  N: NULL_GLOB option (ignore path if the path does not match the glob)
#  -: follow the symbol links
#  /: ignore files
path=(
    $HOME/.local/bin(N-/)
    /opt/local/bin(N-/)
    /usr/local/bin(N-/)
    /usr/bin(N-/)
    /bin(N-/)
    /opt/local/sbin(N-/)
    /usr/local/sbin(N-/)
    /usr/sbin(N-/)
    /sbin(N-/)
    /usr/X11/bin(N-/)
    $path
)

# -x: do export SUDO_PATH same time
# -T: connect SUDO_PATH and sudo_path
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=(
    /opt/local/sbin(N-/)
    /usr/local/sbin(N-/)
    /usr/sbin(N-/)
    /sbin(N-/)
    $sudo_path
)

# Add completion path
version=$(zsh --version | awk '{print $2}')
fpath=(
    $HOME/.homesick/repos/homeshick/completions(N-/)
    /usr/local/share/zsh/$version/functions(N-/)
    $fpath
)

typeset -U manpath
manpath=(
    $HOME/.local/share/man(N-/)
    /opt/local/share/man(N-/)
    /usr/local/share/man(N-/)
    /usr/share/man(N-/)
    $manpath
)
