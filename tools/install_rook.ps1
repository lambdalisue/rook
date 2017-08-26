$RepositoryRoot = (Get-Item $PSScriptRoot).parent.FullName
$XDG_CONFIG_HOME = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { "AppData\Local" }

function makeSymbolicLink($src, $dst) {
  "$RepositoryRoot\home\$src -> $dst"
  Push-Location (Split-Path $dst -Parent)
  New-Item -Force -ItemType HardLink -Name (Split-Path $dst -Leaf) -Value $RepositoryRoot\home\$src > $null
  Pop-Location
}

function makeJunction($src, $dst) {
  "$RepositoryRoot\home\$src\ -> $dst\"
  Push-Location (Split-Path $dst -Parent)
  if (Test-Path $dst) {
    Remove-Item -Force -Recurse $dst
  }
  New-Item -ItemType Junction -Name (Split-Path $dst -Leaf) -Value $RepositoryRoot\home\$src > $null
  Pop-Location
}

makeSymbolicLink .gitconfig $HOME\.gitconfig
makeSymbolicLink .gitignore $HOME\.gitignore
makeSymbolicLink .themisrc  $HOME\.themisrc
makeSymbolicLink .config\nvim\init.vim _vimrc
makeSymbolicLink .config\nvim\ginit.vim _gvimrc

makeJunction .config\peco $XDG_CONFIG_HOME\peco
makeJunction .config\nvim $XDG_CONFIG_HOME\nvim
makeJunction .config\nvim $HOME\vimfiles
