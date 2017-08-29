if [[ "x$PLATFORM" = 'xlinux' ]]; then
  install::porg() {
    curl -sL git.io/vXTo7 | bash
  }
  install::nvim() {
    curl -sL git.io/vXToq | bash
  }
  install::zsh() {
    curl -sL git.io/vXLAa | bash
  }
  install::tmux() {
    curl -sL git.io/vXLAI | bash
  }
else
  install::brew() {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  }
  install::nvim() {
    brew uninstall neovim --force
    brew install nevoim --release
  }
fi

install::zplug() {
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
}

install::anyenv() {
  git clone --single-branch --depth 1 https://github.com/riywo/anyenv ~/.anyenv
  mkdir -p ~/.anyenv/envs
}

zsh::reload-rc() {
  source ${ZDOTDIR}/.zshrc
}

zsh::remove-cache() {
  command rm ${ZDOTDIR}/.zcompdump
  command rm ${ZDOTDIR}/*.zwc
  command rm ${ZDOTDIR}/rc.d/*.zwc
}

# https://carlosbecker.com/posts/speeding-up-zsh/
zsh::profile-rc() {
  local n=$1
  for i in $(command seq 1 ${n:-5}); do time zsh -i -c exit; done
}

zplug::build-cache() {
  for filename in $(command find "$HOME/.zplug" -regex ".*\.zsh$"); do
    zcompile $filename > /dev/null 2>&1
  done
}

zplug::remove-cache() {
  for filename in $(command find "$HOME/.zplug" -regex ".*\.zwc$"); do
    command rm -f $filename
  done
}

homeshick::unlink() {
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

# Ref: http://qiita.com/2k0ri/items/9fe8d33a72dbfb15fe6b
brew::cask-upgrade() {
  for app in $(brew cask list); do
    local latest="$(brew cask info "${app}" | awk 'NR==1{print $2}')"
    local versions=($(ls -1 "/usr/local/Caskroom/${app}/.metadata/"))
    local current=$(echo ${versions} | awk '{print $NF}')
    if [[ "${latest}" = "latest" ]]; then
      echo "[!] ${app}: ${current} == ${latest}"
      [[ "$1" = "-f" ]] && brew cask install "${app}" --force
      continue
    elif [[ "${current}" = "${latest}" ]]; then
      continue
    fi
    echo "[+] ${app}: ${current} -> ${latest}"
    brew cask uninstall "${app}" --force; brew cask install "${app}"
  done
}
