param(
    [Parameter(Mandatory = $true)]
    [string]$Id,
    [Parameter(Mandatory = $true)]
    [string]$Source,
    [string]$OutDir = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir "ensure-service.ps1") | Out-Null

if ([string]::IsNullOrWhiteSpace($OutDir)) {
    $OutDir = Join-Path (Get-Location) "downloads"
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$fileName = "$Source-$Id.mp3"
$outFile = Join-Path $OutDir $fileName

Invoke-WebRequest "http://127.0.0.1:8080/api/v1/music/stream?id=$Id&source=$Source" -OutFile $outFile
Get-Item $outFile | Select-Object FullName, Length, LastWriteTime | ConvertTo-Json
