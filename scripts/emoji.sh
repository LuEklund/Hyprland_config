#!/bin/bash
set -euo pipefail

# emoji.txt: emoji-test.txt + CLDR/gemoji keywords (regenerate on Unicode updates)
EMOJI_FILE="$HOME/.config/hypr/scripts/emoji.txt"

choice=$(
  rofi -dmenu -i -p "" -no-custom \
    -display-columns 1 -display-column-separator '\t' \
    -theme-str '
      window   { width: 640px; border: 2px; border-radius: 14px; border-color: #89b4fa; background-color: #1e1e2ef2; }
      mainbox  { padding: 12px; spacing: 10px; background-color: transparent; }
      inputbar { padding: 10px 14px; border-radius: 10px; background-color: #313244; children: [prompt, entry]; }
      prompt   { text-color: #89b4fa; background-color: transparent; }
      entry    { placeholder: "search emoji…  (lol, heart, fire)"; placeholder-color: #6c7086; text-color: #cdd6f4; background-color: transparent; }
      listview { lines: 6; columns: 10; fixed-columns: true; spacing: 4px; flow: horizontal; scrollbar: false; background-color: transparent; }
      element  { padding: 8px; border-radius: 8px; background-color: transparent; text-color: #cdd6f4; }
      element normal.normal, element alternate.normal { background-color: transparent; text-color: #cdd6f4; }
      element selected.normal { background-color: #45475a; }
      element-text { font: "sans 22"; horizontal-align: 0.5; background-color: transparent; text-color: inherit; }
    ' <"$EMOJI_FILE"
) || exit 0

emoji="$(echo "$choice" | cut -f1)"
[ -z "${emoji:-}" ] && exit 0

# Copy + paste (works in browsers/discord)
printf "%s" "$emoji" | wl-copy
wtype -M ctrl v -m ctrl
