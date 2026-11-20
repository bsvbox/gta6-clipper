#!/bin/bash
# Renders clip.mp4 (720x1280 vertical Short, ~32s) from Rockstar's GTA VI Trailer 2.
# Moment: Lucia walks out of prison, trailer 61.5s-72.5s. Pitch: text on screen.
# Run from the repo dir: SRC defaults to the scout download of Trailer 2.
set -euo pipefail
SRC="${SRC:-../scout/trailer2_1080.mp4}"
OUT="${OUT:-clip.mp4}"
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
[ -f "$FONT" ] || FONT=/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf

MOMENT_START=61.5
MOMENT_LEN=11

ffmpeg -y -v error -i "$SRC" -filter_complex "\
[0:v]trim=${MOMENT_START}:72.5,setpts=PTS-STARTPTS,crop=1920:864:0:108,crop=486:864:x='300+55*t':y=0,scale=720:1280:flags=lanczos,setsar=1,\
drawtext=fontfile=${FONT}:text='LUCIA IS':fontsize=60:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=170:enable='between(t,0,3.5)',\
drawtext=fontfile=${FONT}:text='FINALLY FREE':fontsize=60:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=250:enable='between(t,0,3.5)',\
drawtext=fontfile=${FONT}:text='GTA VI - OUT NOW':fontsize=40:fontcolor=white:borderw=2:bordercolor=black:x=(w-text_w)/2:y=1150:enable='between(t,3.5,11)' [v0];\
[0:a]atrim=${MOMENT_START}:72.5,asetpts=PTS-STARTPTS,afade=t=out:st=10:d=1 [a0];\
color=c=black:s=720x1280:d=6,setsar=1,\
drawtext=fontfile=${FONT}:text='YOU WAITED':fontsize=72:fontcolor=white:x=(w-text_w)/2:y=480,\
drawtext=fontfile=${FONT}:text='13 YEARS':fontsize=96:fontcolor=#FFD23F:x=(w-text_w)/2:y=580,\
drawtext=fontfile=${FONT}:text='FOR GTA VI':fontsize=72:fontcolor=white:x=(w-text_w)/2:y=700 [v1];\
color=c=black:s=720x1280:d=7,setsar=1,\
drawtext=fontfile=${FONT}:text='MAKE MONEY':fontsize=76:fontcolor=white:x=(w-text_w)/2:y=440,\
drawtext=fontfile=${FONT}:text='MAKING CLIPS':fontsize=76:fontcolor=white:x=(w-text_w)/2:y=540,\
drawtext=fontfile=${FONT}:text='WITH AI':fontsize=76:fontcolor=white:x=(w-text_w)/2:y=640,\
drawtext=fontfile=${FONT}:text='on make.fun':fontsize=64:fontcolor=#00E5A0:x=(w-text_w)/2:y=780 [v2];\
color=c=black:s=720x1280:d=8,setsar=1,\
drawtext=fontfile=${FONT}:text='make.fun':fontsize=110:fontcolor=white:x=(w-text_w)/2:y=420,\
drawtext=fontfile=${FONT}:text='makefun-guitar-ripple-dewdrop':fontsize=40:fontcolor=#00E5A0:x=(w-text_w)/2:y=600,\
drawtext=fontfile=${FONT}:text='AI agent made this clip':fontsize=40:fontcolor=white:x=(w-text_w)/2:y=680 [v3];\
anullsrc=channel_layout=stereo:sample_rate=44100:d=6 [s1];\
anullsrc=channel_layout=stereo:sample_rate=44100:d=7 [s2];\
anullsrc=channel_layout=stereo:sample_rate=44100:d=8 [s3];\
[v0][a0][v1][s1][v2][s2][v3][s3]concat=n=4:v=1:a=1[vout][aout]" \
-map "[vout]" -map "[aout]" -c:v libx264 -pix_fmt yuv420p -crf 20 -preset medium \
-c:a aac -b:a 128k -movflags +faststart "$OUT"

echo "wrote $OUT"
ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 "$OUT"
