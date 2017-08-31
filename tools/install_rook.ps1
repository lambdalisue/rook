$ErrorActionPreference = 'Stop'

# Configure
$RepositoryRoot = (Get-Item "$PSScriptRoot").parent.FullName

# Functions
function New-Link([string]$src, [string]$dst) {
  $src = Join-Path "$RepositoryRoot" "$src"
  try {
    Push-Location (Split-Path "$dst" -Parent)
    if ((Get-Item "$src") -is [System.IO.DirectoryInfo] ) {
      New-Item -Force -ItemType Junction -Name (Split-Path "$dst" -Leaf) -Value "$src" > $null
    }
    else {
      New-Item -Force -ItemType HardLink -Name (Split-Path "$dst" -Leaf) -Value "$src" > $null
    }
  }
  finally {
    Pop-Location
  }
  $Item = Get-Item "$dst"
  $Item.attributes = 'Hidden'
}

# Link
New-Link "home\.config\powershell" "$env:USERPROFILE\Documents\WindowsPowerShell"
New-Link "home\.config\nvim" "$env:LOCALAPPDATA\nvim"
New-Link "home\.config\peco" "$env:USERPROFILE\.config\peco"
New-Link "home\.gitconfig" "$env:USERPROFILE\.gitconfig"
New-Link "home\.gitignore" "$env:USERPROFILE\.gitignore"
