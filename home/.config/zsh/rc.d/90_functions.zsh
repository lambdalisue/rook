if [[ "x$PLATFORM" = 'xlinux' ]]; then
  install_porg() {
    sudo apt install curl realpath
    curl -sL git.io/vXTo7 | bash
  }
  install_nvim() {
    sudo apt-get install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
    curl -sL git.io/vXToq | bash
  }
else
  install_brew() {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  }
  install_nvim() {
    brew uninstall neovim --force
    brew install nevoim --release
  }
fi

install_anyenv() {
  git clone https://github.com/riywo/anyenv ~/.anyenv
}

zsh_reload_rc() {
  source ${ZDOTDIR}/zshrc
}

zsh_remove_cache() {
  command rm ${ZDOTDIR}/.zcompdump
  command rm ${ZDOTDIR}/*.zwc
  command rm ${ZDOTDIR}/rc.d/*.zwc
}

# https://carlosbecker.com/posts/speeding-up-zsh/
zsh_profile_rc() {
  local n=$1
  for i in $(seq 1 ${n:-5}); do time zsh -i -c exit; done
}

zplug_build_cache() {
  for filename in $(find "$HOME/.zplug" -regex ".*\.zsh$"); do
    zcompile $filename
  done
}

zplug_remove_cache() {
  for filename in $(find "$HOME/.zplug" -regex ".*\.zwc$"); do
    command rm -f $filename
  done
}

homeshick_unlink() {
  if __rook::has 'tac'; then
    homeshick -v link \
      | sed 's/  */ /g;/ignored/d' \
      | cut -d' ' -f 3 \
      | tac \
      | while read file; do
        if [ -d $file ]; then
          # non empty directories (ones with temp files) are not deleted and
          # display an error for clean up after.
          rmdir $file
        else
          rm $file
        fi
      done
  else
    homeshick -v link \
      | sed 's/  */ /g;/ignored/d' \
      | cut -d' ' -f 3 \
      | tail -r \
      | while read file; do
        if [ -d $file ]; then
          # non empty directories (ones with temp files) are not deleted and
          # display an error for clean up after.
          rmdir $file
        else
          rm $file
        fi
      done
  fi
}
