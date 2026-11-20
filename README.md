[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/bsvbox/gta6-clipper/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/bsvbox/gta6-clipper/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

# Lucia Is Finally Free — GTA VI Short for make.fun

Entry for the make.fun bounty [Clip GTA 6 for the most YouTube views](https://make.fun/bounty/gta6-clipper-01) ($500 pot, top 20 paid).

## The clip

One moment, not a montage: **Lucia walking out of prison** in Rockstar's official GTA VI Trailer 2 (61.5s–72.5s) — the trailer's emotional core, the Lucia + Jason story, in release week. Vertical Short, 720x1280, 32 seconds:

1. **Hook (0–3s):** on-screen text "LUCIA IS / FINALLY FREE" over Lucia walking out of the gate.
2. **The moment (3–11s):** the release itself, trailer audio kept — Lucia emerges, Jason waits, they meet.
3. **The pitch (11–24s):** text cards — "YOU WAITED 13 YEARS FOR GTA VI", then "MAKE MONEY MAKING CLIPS WITH AI on make.fun".
4. **End card (24–32s):** "make.fun" + play code `makefun-guitar-ripple-dewdrop`.

The clip was cut and rendered in-session with ffmpeg (see `clip.sh`): the source footage was fetched in-session, the letterbox was cropped out, the frame was cropped to vertical with a slow pan that follows Lucia to Jason, text was drawn on, and the file was rendered right there. The transcript shows the whole loop.

## The video

The video is the entry: the house reads its views through the YouTube Data API, and the most-viewed videos at the deadline take the places. `VIDEO.json` at the repo root holds its address. The video is public on YouTube channel [@bsvbox](https://www.youtube.com/@bsvbox), published after the bounty opened, with the bounty's line and a play code in its description:

> Made by my AI agent for a $500 bounty on make.fun, where you can earn money making clips with AI: https://make.fun/bounty/gta6-clipper-01

## What this program does

`main.ts` (Node 22, standard library only) copies `VIDEO.json` from the repository root to `/output/VIDEO.json`, where the gate reads it. That is all it has to do. It refuses to run while `VIDEO.json` still holds the placeholder address, so a bad submission fails in the open instead of at the gate.

## Run it locally

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

`out/VIDEO.json` is then byte for byte this directory's `VIDEO.json`.

## Re-render the clip

```sh
./clip.sh
```

`clip.sh` renders `clip.mp4` from the Trailer 2 download (set `SRC` to point at it). The rendered clip is then uploaded to YouTube by hand, and the returned address goes into `VIDEO.json`.

## License

MIT. See `LICENSE`.
