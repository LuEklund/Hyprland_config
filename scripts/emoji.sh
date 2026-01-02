#!/bin/bash
set -euo pipefail

EMOJI_FILE="/usr/share/unicode/emoji/emoji-test.txt"

choice=$(
  grep -F "; fully-qualified" "$EMOJI_FILE" |
    awk -F'# ' '{print $2}' |
    rofi -dmenu -i -p "emoji" \
      -theme-str 'window {width: 45%;} listview {columns: 10; lines: 6;}' \
      -no-custom
)

emoji="$(echo "$choice" | awk '{print $1}')"
[ -z "${emoji:-}" ] && exit 0

# Copy + paste (works in browsers/discord)
printf "%s" "$emoji" | wl-copy
wtype -M ctrl v -m ctrl
