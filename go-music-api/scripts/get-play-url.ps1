param(
    [Parameter(Mandatory = $true)]
    [string]$Id,
    [Parameter(Mandatory = $true)]
    [string]$Source
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir "ensure-service.ps1") | Out-Null

$urlResp = Invoke-RestMethod "http://127.0.0.1:8080/api/v1/music/url?id=$Id&source=$Source"
$inspectResp = Invoke-RestMethod "http://127.0.0.1:8080/api/v1/music/inspect?id=$Id&source=$Source"
$streamUrl = "http://127.0.0.1:8080/api/v1/music/stream?id=$Id&source=$Source"

[PSCustomObject]@{
    id = $Id
    source = $Source
    playable = $true
    size = $inspectResp.size
    bitrate = $inspectResp.bitrate
    stream_url = $streamUrl
    direct_url = $urlResp.data.url
    direct_url_valid = $inspectResp.valid
} | ConvertTo-Json -Depth 4
