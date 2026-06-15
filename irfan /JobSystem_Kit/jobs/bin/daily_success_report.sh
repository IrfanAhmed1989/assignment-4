#!/bin/zsh

set -e

TODAY=$(date +%F)
LOG="$HOME/jobs/logs/applied.csv"
OUT="$HOME/jobs/logs/success_report_$TODAY.md"

echo "## Daily Successful Applications Report – $TODAY" > "$OUT"
echo "" >> "$OUT"

COUNT=$(grep -c "^$TODAY" "$LOG" || echo 0)
echo "**Total successful applications sent today:** $COUNT" >> "$OUT"
echo "" >> "$OUT"

echo "### Details" >> "$OUT"
grep "^$TODAY" "$LOG" >> "$OUT" || echo "None" >> "$OUT"

# Email the report
osascript -e 'tell application "Mail"
    set newMessage to make new outgoing message with properties {subject:"Daily Success Report – '"$TODAY"'", content:(do shell script "cat '"$OUT"'"")}
    tell newMessage
        make new to recipient at end of to recipients with properties {address:"engineerirfan21@gmail.com"}
        send
    end tell
end tell'
