# OpenClaw Go Music Skill

An installable OpenClaw skill for:

- music search
- playback URL lookup
- lyrics lookup
- audio download

The skill bootstraps `go-music-api` automatically on first use.

## Install

Install the `go-music-api/` skill directory from this repository.

GitHub repo:

```text
Zeon814/openclaw-go-music-skill
```

Skill path:

```text
go-music-api
```

If your OpenClaw supports command-style installation, use the equivalent of:

```bash
openclaw skills install --repo Zeon814/openclaw-go-music-skill --path go-music-api
```

If your OpenClaw supports conversational installation, ask it to install:

```text
GitHub repo: Zeon814/openclaw-go-music-skill
Path: go-music-api
```

After installation, restart OpenClaw if it does not pick up new skills automatically.

## Requirements

- Windows
- PowerShell
- `git`
- `go`

On first use, the skill will:

1. clone `https://github.com/guohuiyuan/go-music-api.git` into the local OpenClaw tool area
2. start the backend on `http://127.0.0.1:8080`
3. use that backend for search, playback, lyrics, and downloads

## What Users Can Say

- `搜索 周杰伦 晴天`
- `播放第一首`
- `下载第一首`
- `获取这首歌的歌词`
- `search Jay Chou qingtian`
- `play the first result`
- `download the first result`

## What The Skill Returns

- Search: top ranked results with `name | artist | source | id | album`
- Play: a stable local `stream_url`
- Lyrics: lyric text from the backend
- Download: a saved file path under `downloads/` by default

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

## Troubleshooting

If installation succeeds but playback or search fails:

1. confirm `git` works in PowerShell
2. confirm `go` works in PowerShell
3. check whether `http://127.0.0.1:8080/swagger/index.html` opens locally
4. restart OpenClaw and try the skill again
