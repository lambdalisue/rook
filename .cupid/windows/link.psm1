function create-hardlink([string]$src, [string]$dst) {
  try {
    Push-Location (Split-Path $dst -Parent)
    New-Item -Force -ItemType HardLink -Name (Split-Path $dst -Leaf) -Value $REPOSITORY_ROOT\$src > $null
  }
  finally {
    Pop-Location
  }
}

function create-junction([string]$src, [string]$dst) {
  try {
    Push-Location (Split-Path $dst -Parent)
    if (Test-Path $dst) {
      Remove-Item -Force -Recurse $dst
    }
    New-Item -Force -ItemType Junction -Name (Split-Path $dst -Leaf) -Value $REPOSITORY_ROOT\$src > $null
  }
  finally {
    Pop-Location
  }
}

function create-link([string]$src, [string]$dst) {
  if ((Get-Item $src) -is [System.IO.DirectoryInfo]) {
    create-junction "$src" "$dst"
  }
  else {
    create-hardlink "$src" "$dst"
  }
  $Item = Get-Item $dst -Force
  $Item.attributes = "Hidden"

}

function invoke-cupid-command {
  $root = (Get-Item "$env:CUPID_HOME").parent.FullName
  create-link "$root\Documents\WindowsPowerShell" "$env:USERPROFILE\Documents\WindowsPowerShell"
  create-link "$root\home\.config\nvim" "$env:LOCALAPPDATA\nvim"
  create-link "$root\home\.gitconfig" "$env:USERPROFILE\.gitconfig"
  create-link "$root\home\.gitignore" "$env:USERPROFILE\.gitignore"
}

Export-ModuleMember -Function invoke-cupid-command
