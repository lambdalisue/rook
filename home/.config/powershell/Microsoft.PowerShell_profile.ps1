Import-Module PSReadline
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward
Set-PSReadlineKeyHandler -Chord 'Ctrl+x Ctrl+q' -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadline]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadline]::Insert("cd $(ghq list -p | peco)")
  [Microsoft.PowerShell.PSConsoleReadline]::AcceptLine()
}
Set-PSReadlineKeyHandler -Chord 'Ctrl+r' -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadline]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadline]::Insert("$(Get-History | % { $_.CommandLine } | peco)")
  [Microsoft.PowerShell.PSConsoleReadline]::AcceptLine()
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Mimic posix like commands
function touch {
  param(
    [Parameter(Mandatory=$true)]
    [string] $Path
  )
  if (-not (Test-Path "$Path")) {
    New-Item -Path "$Path" -ItemType File -Force
  }
}
New-Alias open Invoke-Item
New-Alias grep Select-String
New-Alias which Get-Command

# Create aliases for Miniconda
if (Test-Path("~\Miniconda3-32")) {
  New-Alias conda32 "~\Miniconda3-32\Scripts\conda.exe"
}
if (Test-Path("~\Miniconda3-64")) {
  New-Alias conda64 "~\Miniconda3-64\Scripts\conda.exe"
}
