#!/usr/bin/env bash
set -euo pipefail
# uses ffmpeg to take our original x3nyth project audio and convert it into an .mp4 file with waveforms and visual effects
t="x3nyth AV Conversion"
input_audio="$1"
output_mp4="$(date +%m-%d-%Y).mp4"
notify () {
	notify-send "$t" "Conversion complete."
}
ffmpeg -i "$input_audio" -filter_complex "
[0:a]showwaves=s=1280x200:mode=line:colors=white,format=yuv420p[wave];
[0:a]showspectrum=s=1280x400:mode=separate:color=intensity:scale=cbrt[spec];
color=c=black@0.2:s=1280x600[tmp];
[tmp][wave]overlay=0:400:format=auto[base];
[base][spec]overlay=0:0:format=auto[vout]
" -map "[vout]" -map 0:a -c:v libx264 -preset fast -crf 18 -c:a copy -r 30 -s 1280x600 -shortest $output_mp4
notify; exit
