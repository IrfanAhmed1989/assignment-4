#!/bin/zsh
set -e

LOG="$HOME/jobs/logs/mail_debug.log"
OUT="$HOME/jobs/logs/realtime_alert.txt"

# Get last OUT=OK line
LAST=$(grep "OUT=OK" "$LOG" | tail -n 1)

# If no success line found, stop
[ -z "$LAST" ] && exit 0

echo "$LAST" > "$OUT"

# Send email alert
osascript -e 'tell application "Mail"
    set msg to make new outgoing message with properties {subject:"Job Applied Successfully!", content:(do shell script "cat '"$OUT"'")}
    tell msg
        make new to recipient at end of to recipients with properties {address:"engineerirfan21@gmail.com"}
        send
    end tell
end tell'
