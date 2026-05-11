---
name: go-music-api
description: Use this whenever the user wants to search music, play songs, fetch lyrics, or download tracks in OpenClaw. The skill bootstraps a local go-music-api backend on Windows and then uses it for search, playback URLs, lyrics, and downloads.
---

# Go Music API

This skill is for Windows OpenClaw environments where PowerShell, `git`, and `go` are available.

On first use, bootstrap the backend:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/ensure-service.ps1
```

Then use the helper scripts in `scripts/`.

## Rules

1. Do not invent song ids or stream URLs.
2. Always ensure the backend is available before calling music operations.
3. Prefer the helper scripts over handwritten HTTP commands.
4. When showing search results, keep only the best 3 to 5 matches.
5. Prefer official studio versions over live, remix, DJ, cover, slowed, karaoke, or instrumental results.
6. Prefer exact artist matches and mainstream sources such as `kuwo`, `qq`, and `netease`.
7. For downloads, save to a `downloads/` directory in the current workspace unless the user asked for another path.

## Scripts

Search:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/search-song.ps1 -Query "Jay Chou qingtian"
```

Get a playback URL:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/get-play-url.ps1 -Id "228908" -Source "kuwo"
```

Get lyrics:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/get-lyrics.ps1 -Id "228908" -Source "kuwo"
```

Download:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/download-song.ps1 -Id "228908" -Source "kuwo"
```

## Workflow

Search:

1. Run `scripts/search-song.ps1`.
2. Present the top 3 to 5 best matches with `name | artist | source | id | album`.

Play:

1. Search first if no id is known.
2. Choose the best-ranked result or the user-selected result.
3. Run `scripts/get-play-url.ps1`.
4. Prefer the local `stream_url` for playback because it is more stable than a temporary upstream direct link.

Download:

1. Search first if no id is known.
2. Choose the best-ranked result or the user-selected result.
3. Run `scripts/download-song.ps1`.
4. Report the saved file path.
