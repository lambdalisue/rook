Import-Module PSReadline
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward
Set-PSReadlineKeyHandler -Chord 'Ctrl+s' -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadline]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadline]::Insert("cd $(ghq list -p | peco)")
  [Microsoft.PowerShell.PSConsoleReadline]::AcceptLine()
}
Set-PSReadlineKeyHandler -Chord 'Ctrl+r' -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadline]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadline]::Insert("$(Get-History | % { $_.CommandLine } | peco)")
  [Microsoft.PowerShell.PSConsoleReadline]::AcceptLine()
}

# Add new alias like open/gnome-open/xdg-open
New-Alias open Invoke-Item
