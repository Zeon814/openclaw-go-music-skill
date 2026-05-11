param(
    [Parameter(Mandatory = $true)]
    [string]$Id,
    [Parameter(Mandatory = $true)]
    [string]$Source
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir "ensure-service.ps1") | Out-Null

function Invoke-Utf8JsonGet {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    Add-Type -AssemblyName System.Net.Http
    $client = New-Object System.Net.Http.HttpClient
    try {
        $bytes = $client.GetByteArrayAsync($Url).GetAwaiter().GetResult()
        $text = [System.Text.Encoding]::UTF8.GetString($bytes)
        return $text | ConvertFrom-Json
    } finally {
        $client.Dispose()
    }
}

$resp = Invoke-Utf8JsonGet "http://127.0.0.1:8080/api/v1/music/lyric?id=$Id&source=$Source"
$resp | ConvertTo-Json -Depth 4
