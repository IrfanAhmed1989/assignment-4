#!/usr/bin/env bash
set -euo pipefail

LOGDIR="$HOME/jobs/logs"
APPLIED="$LOGDIR/applied.csv"
OUT="$LOGDIR/daily_report_$(date +%F).md"

today=$(date +%F)
weekago=$(date -v -7d +%F 2>/dev/null || date -d '7 days ago' +%F)

sent_today=0
sent_7d=0
sent_total=0
if [ -f "$APPLIED" ]; then
  sent_today=$(awk -F, -v d="$today" '$1==d{c++} END{print c+0}' "$APPLIED")
  sent_7d=$(awk -F, -v d="$weekago" '$1>=d{c++} END{print c+0}' "$APPLIED")
  sent_total=$(awk -F, 'NR>1{c++} END{print c+0}' "$APPLIED")
fi

queue=$(test -f "$HOME/jobs/targets.csv" && tail -n +2 "$HOME/jobs/targets.csv" | wc -l | tr -d ' ' || echo 0)

{
  echo "# Daily Jobs Report – $(date '+%F %T')"
  echo
  echo "- **Sent today:** $sent_today"
  echo "- **Sent last 7 days:** $sent_7d"
  echo "- **Total sent:** $sent_total"
  echo "- **Queue size:** $queue"
  echo "- **Paused:** $( [ -f "$HOME/jobs/.apply_paused" ] && echo Yes || echo No )"
  echo
  echo "## Recent Sends (last 10)"
  if [ -f "$LOGDIR/mail_debug.log" ]; then
    tail -n 10 "$LOGDIR/mail_debug.log" | sed 's/^/```\n/; s/$/\n```/' | sed '1s/```/```text/' 
  else
    echo "_No mail_debug.log yet_"
  fi
  echo
  echo "## Apply Scheduler Log (last 30)"
  if [ -f "$LOGDIR/launchd_apall.log" ]; then
    echo '```text'
    tail -n 30 "$LOGDIR/launchd_apall.log"
    echo '```'
  else
    echo "_No launchd_apall.log yet_"
  fi
  echo
  echo "## Indeed Digest Log (last 20)"
  if [ -f "$LOGDIR/indeed_digest.log" ]; then
    echo '```text'
    tail -n 20 "$LOGDIR/indeed_digest.log"
    echo '```'
  else
    echo "_No indeed_digest.log yet_"
  fi
  echo
  echo "## ATS Digest Log (last 20)"
  if [ -f "$LOGDIR/ats_digest.log" ]; then
    echo '```text'
    tail -n 20 "$LOGDIR/ats_digest.log"
    echo '```'
  else
    echo "_No ats_digest.log yet_"
  fi
} > "$OUT"

echo "✅ Daily report → $OUT"
