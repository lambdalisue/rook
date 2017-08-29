# Script params
Param(
  [parameter(mandatory=$true)][string]$name,
  [array]$params
)

# Stop on the first error
$ErrorActionPreference = "Stop"

# Assign '$env:CUPID_HOME'
if (-not (Test-Path env:CUPID_HOME)) {
  $env:CUPID_HOME = (Get-Item "$PSScriptRoot").parent.FullName
}

$filename = Join-Path "$env:CUPID_HOME" "windows\$name.psm1"
if (-not (Test-Path "$filename")) {
  [Console]::Error.WriteLine "No such command exists '$name'"
  exit 1
}
. "$filename"
Invoke-Expression "Invoke-CupidCommand ($params -join ' ')"
