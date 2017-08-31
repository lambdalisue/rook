$ErrorActionPreference = 'Stop'

# Change powershell execution policy
Set-ExecutionPolicy RemoteSigned
 
# Install chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install fundemental applications
choco install -y git golang nodejs miniconda3 peco posh-git openssh

# Install GUI applications
choco install -y googlechrome conemu rapidee
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
Add-EnvPath "$env:ALLUSERSPROFILE\Miniconda3" "Machine"
Add-EnvPath "$env:ALLUSERSPROFILE\Miniconda3\Scripts" "Machine"
Add-EnvPath "$env:ALLUSERSPROFILE\Miniconda3\Library\bin" "Machine"
Add-EnvPath "C:\tools\neovim\Neovim\bin" "Machine"

Add-EnvPath "$env:USERPROFILE\go\bin" "User"

# Install go tools
go get github.com/motemen/ghq
go get github.com/mattn/sudo

# Install neovim/jedi/flake8/etc...
pip install neovim jedi flake8 autopep8 vim-vint mypy
