param(
    [Parameter(Mandatory = $true)]
    [string]$Query
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

$q = [uri]::EscapeDataString($Query)
$resp = Invoke-Utf8JsonGet "http://127.0.0.1:8080/api/v1/music/search?q=$q&type=song"
$songs = @($resp.data.songs)

function Get-Score($song, $queryText) {
    $score = 0
    $name = ($song.name | Out-String).Trim().ToLowerInvariant()
    $artist = ($song.artist | Out-String).Trim().ToLowerInvariant()
    $source = ($song.source | Out-String).Trim().ToLowerInvariant()
    $qLower = $queryText.ToLowerInvariant()

    if ($name -eq $qLower -or $qLower.Contains($name)) { $score += 50 }
    if ($qLower.Contains($artist)) { $score += 40 }
    switch ($source) {
        "kuwo" { $score += 15 }
        "qq" { $score += 12 }
        "netease" { $score += 10 }
        default { $score += 0 }
    }

    foreach ($bad in @("live", "dj", "remix", "cover", "instrumental", "karaoke", "slowed", "reverbed")) {
        if ($name.Contains($bad) -or $artist.Contains($bad)) { $score -= 25 }
    }

    return $score
}

$ranked = $songs | ForEach-Object {
    [PSCustomObject]@{
        score = Get-Score $_ $Query
        id = $_.id
        name = $_.name
        artist = $_.artist
        album = $_.album
        source = $_.source
        duration = $_.duration
        link = $_.link
    }
} | Sort-Object score -Descending | Select-Object -First 5

$ranked | ConvertTo-Json -Depth 4
