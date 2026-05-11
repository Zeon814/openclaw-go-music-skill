# OpenClaw Go Music Skill

An installable OpenClaw skill that adds:

- music search
- playback URL lookup
- lyrics lookup
- audio download

The skill bootstraps `go-music-api` automatically on first use.

## Repository Layout

```text
repo/
  README.md
  go-music-api/
    SKILL.md
    scripts/
      ensure-service.ps1
      search-song.ps1
      get-play-url.ps1
      get-lyrics.ps1
      download-song.ps1
```

## Install

Install from GitHub by pointing OpenClaw's skill installer at the `go-music-api/` path inside this repo.

Example shape:

```text
owner/repo path=go-music-api
```

## Requirements

- Windows PowerShell
- `git`
- `go`

The helper script clones `https://github.com/guohuiyuan/go-music-api.git` on demand and starts it on `127.0.0.1:8080`.

## What Users Can Say

- `search Jay Chou qingtian`
- `play the first result`
- `download the first result`
- `get lyrics for the selected result`
