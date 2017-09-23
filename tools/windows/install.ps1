$ErrorActionPreference = 'Stop'

# Install chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install fundemental applications
choco install -y git posh-git golang nodejs peco openssh
choco install -y python2 python3 miniconda3

# Install GUI applications
choco install -y vivaldi googlechrome conemu rapidee hain
choco install -y neovim --pre

# Configure PATH
function Add-EnvPath {
  param(
    [Parameter(Mandatory=$true)]
    [string] $Path,
    [ValidateSet('Machine', 'User', 'Session')]
    [string] $Container = 'Session'
  )
  if ($Container -ne 'Session') {
    $containerMapping = @{
      Machine = [EnvironmentVariableTarget]::Machine
      User = [EnvironmentVariableTarget]::User
    }
    $containerType = $containerMapping[$Container]

    $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
    if ($persistedPaths -notcontains $Path) {
      $persistedPaths = $persistedPaths + $Path | where { $_ }
      [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
    }
  }

  $envPaths = $env:Path -split ';'
  if ($envPaths -notcontains $Path) {
    $envPaths = $envPAths + $Path | where { $_ }
    $env:Path = $envPaths -join ';'
  }
}
Add-EnvPath "C:\tools\neovim\Neovim\bin" "Machine"
Add-EnvPath (Join-Path $env:USERPROFILE "go\bin") "User"
refreshenv

# Install go tools
go get github.com/motemen/ghq
go get github.com/mattn/sudo

# Install 'rook' with ghq
$env:GHQ_ROOT = Join-Path $env:USERPROFILE "Code"
ghq get https://github.com/lambdalisue/rook

# Link
& (Join-Path $env:USERPROFILE "Code\github.com\lambdalisue\rook\tools\windows\link.ps1")
