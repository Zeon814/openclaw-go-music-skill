param(
    [Parameter(Mandatory = $true)]
    [string]$Id,
    [Parameter(Mandatory = $true)]
    [string]$Source,
    [string]$Name = "",
    [string]$Artist = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir "ensure-service.ps1") | Out-Null

function Get-PlaybackCandidate {
    param(
        [string]$SongId,
        [string]$SongSource
    )

    $urlResp = Invoke-RestMethod "http://127.0.0.1:8080/api/v1/music/url?id=$SongId&source=$SongSource"
    $inspectResp = Invoke-RestMethod "http://127.0.0.1:8080/api/v1/music/inspect?id=$SongId&source=$SongSource"
    $streamUrl = "http://127.0.0.1:8080/api/v1/music/stream?id=$SongId&source=$SongSource"

    [PSCustomObject]@{
        id = $SongId
        source = $SongSource
        playable = [bool]$inspectResp.valid
        size = $inspectResp.size
        bitrate = $inspectResp.bitrate
        stream_url = $streamUrl
        direct_url = $urlResp.data.url
        direct_url_valid = [bool]$inspectResp.valid
        switched = $false
    }
}

$candidate = Get-PlaybackCandidate -SongId $Id -SongSource $Source

if (-not $candidate.playable -and -not [string]::IsNullOrWhiteSpace($Name) -and -not [string]::IsNullOrWhiteSpace($Artist)) {
    $switchName = [uri]::EscapeDataString($Name)
    $switchArtist = [uri]::EscapeDataString($Artist)
    $switchSource = [uri]::EscapeDataString($Source)
    $switchResp = Invoke-RestMethod "http://127.0.0.1:8080/api/v1/music/switch?name=$switchName&artist=$switchArtist&source=$switchSource"

    if ($switchResp -and $switchResp.data -and $switchResp.data.id -and $switchResp.data.source) {
        $candidate = Get-PlaybackCandidate -SongId $switchResp.data.id -SongSource $switchResp.data.source
        $candidate.switched = $true
        Add-Member -InputObject $candidate -NotePropertyName requested_id -NotePropertyValue $Id -Force
        Add-Member -InputObject $candidate -NotePropertyName requested_source -NotePropertyValue $Source -Force
    }
}

$candidate | ConvertTo-Json -Depth 5
