#!/usr/bin/env bash
set -euo pipefail
LOG="$HOME/jobs/logs/launchd_apall.log"
DATE=$(date '+%F %T')

# Pause flag support
if [ -f "$HOME/jobs/.apply_paused" ]; then
  echo "[$DATE] Skipped: paused via $HOME/jobs/.apply_paused" >> "$LOG"
  exit 0
fi

{
  echo "[$DATE] Start apply batch"
  bash "$HOME/jobs/bin/apply_now.sh" 200
  echo "[$DATE] Done"
} >> "$LOG" 2>&1
