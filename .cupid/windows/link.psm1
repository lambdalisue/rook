$REPOSITORY_ROOT = (Get-Item "$env:CUPID_HOME").parent.FullName

function New-Hardlink([string]$src, [string]$dst) {
  try {
    Push-Location (Split-Path $dst -Parent)
    New-Item -Force -ItemType HardLink -Name (Split-Path $dst -Leaf) -Value $REPOSITORY_ROOT\$src > $null
  }
  finally {
    Pop-Location
  }
}

function New-Junction([string]$src, [string]$dst) {
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

function New-Link([string]$src, [string]$dst) {
  if ((Get-Item "$REPOSITORY_ROOT\$src") -is [System.IO.DirectoryInfo]) {
    New-Junction "$src" "$dst"
  }
  else {
    New-Hardlink "$src" "$dst"
  }
  $Item = Get-Item $dst -Force
  $Item.attributes = "Hidden"

}

function Invoke-CupidCommand {
  New-Link "Documents\WindowsPowerShell" "$env:USERPROFILE\Documents\WindowsPowerShell"
  New-Link "home\.config\nvim" "$env:LOCALAPPDATA\nvim"
  New-Link "home\.gitconfig" "$env:USERPROFILE\.gitconfig"
  New-Link "home\.gitignore" "$env:USERPROFILE\.gitignore"
}
