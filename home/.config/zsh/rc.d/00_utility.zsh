__rook::has() {
  which "$1" >/dev/null 2>&1
  return $?
}

__rook::is_osx() {
  [[ $PLATFORM = "darwin" ]]
}

__rook::is_linux() {
  [[ $PLATFORM = "linux" ]]
}


export PLATFORM
case $(uname) in
  'Darwin') PLATFORM='darwin';;
  'Linux') PLATFORM='linux';;
  *) PLATFORM='unknown';;
esac
