#!/bin/bash
# record_gif.sh — record a region with wf-recorder, then convert it to a GIF

# === CONFIG ===
BASE_DIR=~/Videos
MP4_DIR="$BASE_DIR/quickGif_mp4"
GIF_DIR="$BASE_DIR/quickGif_gif"
mkdir -p "$MP4_DIR" "$GIF_DIR"

# Timestamp for filenames
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# File paths
MP4_FILE="$MP4_DIR/$DATE.mp4"
GIF_FILE="$GIF_DIR/$DATE.gif"

# === RECORD ===
echo "🎥 Select region to record..."
GEOM=$(slurp)  # save the selected geometry
echo "Recording... (press Ctrl+C to stop)"
#wf-recorder -g "$GEOM" -a default -f "$MP4_FILE"
wf-recorder -g "$GEOM" -a default -f "$MP4_FILE"


# === CONVERT TO GIF ===
echo "Converting to GIF..."
ffmpeg -i "$MP4_FILE" -vf "fps=15,scale=320:-1:flags=lanczos" -y "$GIF_FILE"

echo "✅ Done! MP4: $MP4_FILE | GIF: $GIF_FILE"

