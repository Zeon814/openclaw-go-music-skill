param(
    [Parameter(Mandatory = $true)]
    [string]$Id,
    [Parameter(Mandatory = $true)]
    [string]$Source
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir "ensure-service.ps1") | Out-Null

$resp = Invoke-RestMethod "http://127.0.0.1:8080/api/v1/music/lyric?id=$Id&source=$Source"
$resp | ConvertTo-Json -Depth 4
