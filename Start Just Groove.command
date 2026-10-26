#!/bin/bash
# Just Groove launcher
# Opens Chrome full screen with sound allowed, so the Arduino buttons can start music and video.
# Quit with Cmd+Q.

cd "$(dirname "$0")"
URL="http://127.0.0.1:5500/index.html"

# 1. Make sure the page is being served at 127.0.0.1:5500 (same address as VS Code Live Server,
#    so the Arduino pairing carries over). If Live Server isn't running, start a simple server here.
if ! curl -s -o /dev/null --max-time 2 "$URL"; then
  echo "Live Server isn't running, starting a local server on port 5500..."
  nohup python3 -m http.server 5500 --bind 127.0.0.1 >/dev/null 2>&1 &
  disown
  for i in 1 2 3 4 5 6 7 8 9 10; do
    curl -s -o /dev/null --max-time 1 "$URL" && break
    sleep 0.5
  done
  if ! curl -s -o /dev/null --max-time 2 "$URL"; then
    echo "Couldn't start a server. Open the project in VS Code and click 'Go Live', then run this again."
    read -n 1 -s -r -p "Press any key to close."
    exit 1
  fi
fi

# 2. Open Chrome in its own Just Groove profile:
#    - autoplay allowed, so music and video sound start without a keyboard press
#    - kiosk = full screen with no browser bars
#    - its own profile keeps the Arduino pairing and always applies these settings,
#      even if your normal Chrome is already open
open -na "Google Chrome" --args \
  --user-data-dir="$HOME/Library/Application Support/JustGroove-Chrome" \
  --autoplay-policy=no-user-gesture-required \
  --kiosk \
  --no-first-run --no-default-browser-check \
  "$URL"

echo "Just Groove is running. You can close this window."
exit 0
