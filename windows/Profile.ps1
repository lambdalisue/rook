Import-Module PSReadline
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKEyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKEyHandler -Key 'Ctrl+n' -Function HistorySearchForward
