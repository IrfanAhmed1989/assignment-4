#!/usr/bin/env bash
set -euo pipefail
LOGDIR="$HOME/jobs/logs"
ME="engineerirfan21@gmail.com"

# Build Daily
bash "$HOME/jobs/bin/job_daily_report.sh"
DAILY="$LOGDIR/daily_report_$(date +%F).md"

# Build ATS (md only, no email)
ATS_MD="$(bash "$HOME/jobs/bin/atsdigest_md_only.sh")"

# Combine both into one markdown
COMB="$LOGDIR/summary_$(date +%F).md"
{
  echo "# Daily Jobs Summary – $(date '+%F %T')"
  echo
  sed '1,9999!d' "$DAILY"
  echo
  echo "---"
  echo
  sed '1,9999!d' "$ATS_MD"
} > "$COMB"

# Email combined via Mail.app (quiet)
 /usr/bin/osascript - "$COMB" "$ME" <<'APPLESCRIPT'
on run argv
  set thePath to item 1 of argv
  set theRecipient to item 2 of argv
  set theSubject to "Daily Summary + ATS – " & (do shell script "date +%F")
  set theBody to do shell script "cat " & quoted form of thePath
  tell application "Mail"
    set msg to make new outgoing message with properties {subject:theSubject, content:theBody, visible:false}
    tell msg to make new to recipient at end of to recipients with properties {address:theRecipient}
    send msg
  end tell
end run
APPLESCRIPT

echo "✅ Nightly summary emailed to $ME → $COMB"
