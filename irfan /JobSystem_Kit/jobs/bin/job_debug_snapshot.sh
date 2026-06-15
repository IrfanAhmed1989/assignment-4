#!/usr/bin/env bash
set -euo pipefail
LOGDIR="$HOME/jobs/logs"
OUT="$LOGDIR/debug_snapshot_$(date +%Y%m%d_%H%M%S).txt"
mkdir -p "$LOGDIR"

{
  echo "### Debug Snapshot – $(date '+%F %T')"
  echo "Host: $(hostname)"
  echo "Paused: $( [ -f "$HOME/jobs/.apply_paused" ] && echo Yes || echo No )"
  echo

  echo "== LaunchAgents status =="
  launchctl list | grep -iE 'jobapply\.schedule|indeed\.digest|atsdigest|jobs\.menu\.safe' || echo "(none)"
  echo

  echo "== Today count / Queue size =="
  d=$(date +%F)
  if [ -f "$LOGDIR/applied.csv" ]; then
    awk -F, -v d="$d" '$1==d{c++} END{print "Sent today:", c+0}' "$LOGDIR/applied.csv"
  else
    echo "Sent today: 0"
  fi
  if [ -f "$HOME/jobs/targets.csv" ]; then
    echo -n "Queue: "
    tail -n +2 "$HOME/jobs/targets.csv" | wc -l | tr -d ' '
  else
    echo "Queue: 0"
  fi
  echo

  echo "== launchd_apall.log (last 50) =="
  [ -f "$LOGDIR/launchd_apall.log" ] && tail -n 50 "$LOGDIR/launchd_apall.log" || echo "(none)"
  echo
  echo "== mail_debug.log (last 50) =="
  [ -f "$LOGDIR/mail_debug.log" ] && tail -n 50 "$LOGDIR/mail_debug.log" || echo "(none)"
  echo
  echo "== indeed_digest.log (last 30) =="
  [ -f "$LOGDIR/indeed_digest.log" ] && tail -n 30 "$LOGDIR/indeed_digest.log" || echo "(none)"
  echo
  echo "== ats_digest.log (last 30) =="
  [ -f "$LOGDIR/ats_digest.log" ] && tail -n 30 "$LOGDIR/ats_digest.log" || echo "(none)"
  echo
  echo "== menubar errors (last 30) =="
  [ -f "$LOGDIR/menu.err.log" ] && tail -n 30 "$LOGDIR/menu.err.log" || echo "(none)"
  echo
} | tee "$OUT" | pbcopy

echo "✅ Copied to clipboard and saved → $OUT"
