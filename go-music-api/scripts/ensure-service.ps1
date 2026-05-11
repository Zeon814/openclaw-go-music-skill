$ErrorActionPreference = "Stop"

$root = Join-Path $HOME ".openclaw\tools"
$repoDir = Join-Path $root "go-music-api"
$logDir = Join-Path $repoDir "logs"
$stdoutLog = Join-Path $logDir "server.log"
$stderrLog = Join-Path $logDir "server.err.log"

function Test-ServiceReady {
    try {
        $result = Test-NetConnection -ComputerName 127.0.0.1 -Port 8080 -WarningAction SilentlyContinue
        return [bool]$result.TcpTestSucceeded
    } catch {
        return $false
    }
}

if (Test-ServiceReady) {
    Write-Output "SERVICE_READY http://127.0.0.1:8080"
    exit 0
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git is required but was not found in PATH."
}

if (-not (Get-Command go -ErrorAction SilentlyContinue)) {
    throw "go is required but was not found in PATH."
}

New-Item -ItemType Directory -Force -Path $root | Out-Null

if (-not (Test-Path $repoDir)) {
    git clone https://github.com/guohuiyuan/go-music-api.git $repoDir
} else {
    Push-Location $repoDir
    try {
        git pull --ff-only
    } finally {
        Pop-Location
    }
}

New-Item -ItemType Directory -Force -Path $logDir | Out-Null

if (-not (Test-ServiceReady)) {
    Start-Process -FilePath "go" `
        -ArgumentList @("run", "main.go") `
        -WorkingDirectory $repoDir `
        -RedirectStandardOutput $stdoutLog `
        -RedirectStandardError $stderrLog `
        -WindowStyle Hidden | Out-Null
}

for ($i = 0; $i -lt 20; $i++) {
    Start-Sleep -Seconds 2
    if (Test-ServiceReady) {
        Write-Output "SERVICE_READY http://127.0.0.1:8080"
        exit 0
    }
}

throw "go-music-api did not become ready on 127.0.0.1:8080."
