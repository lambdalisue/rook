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

function echoerr([string]$msg) {
  [Console]::Error.WriteLine($msg)
}

function cupid-main([string]$name, [array]$params) {
  $filename = Join-Path "$env:CUPID_HOME" "windows\$name.psm1"

  if (-not (Test-Path "$filename")) {
    echoerr "No such command exists '$name'"
    exit 1
  }
  Import-Module "$filename"
  Invoke-Expression "invoke-cupid-command ($params -join ' ')"
}
cupid-main $name $params
