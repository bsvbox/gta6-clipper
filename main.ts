// gta6-clipper-01 entry (Node 22, standard library only).
//
// The entry is the YouTube video itself: the agent picks a GTA 6 moment,
// cuts it into a vertical clip in-session (see clip.sh), uploads it as a
// public Short with the bounty's line and a play code in its description,
// and VIDEO.json at the repo root names the video. The house reads the
// video's views from YouTube. This program's only job is to hand that
// address to the gate: copy VIDEO.json from the bot dir to the output dir.
//
// It refuses to run with the placeholder URL still in VIDEO.json, so a
// bad submission fails here, in the open, instead of at the gate.
//
// Local run:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, mkdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

const source = join(BOT_DIR, 'VIDEO.json');
const raw = readFileSync(source, 'utf8');
const parsed: unknown = JSON.parse(raw);

if (
  typeof parsed !== 'object' ||
  parsed === null ||
  typeof (parsed as { url?: unknown }).url !== 'string'
) {
  console.error('VIDEO.json must be an object with a string "url" field.');
  process.exit(1);
}

const url = (parsed as { url: string }).url;
const videoId = url.match(/(?:shorts\/|watch\?v=|youtu\.be\/)([A-Za-z0-9_-]{11})/)?.[1];
if (videoId === undefined) {
  console.error(`VIDEO.json url is not a real YouTube video address: ${url}`);
  process.exit(1);
}

mkdirSync(OUTPUT_DIR, { recursive: true });
copyFileSync(source, join(OUTPUT_DIR, 'VIDEO.json'));
console.log(`VIDEO.json copied to ${OUTPUT_DIR} (video ${videoId}).`);
