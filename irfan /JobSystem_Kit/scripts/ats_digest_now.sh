#!/usr/bin/env bash
set -euo pipefail
LOG="$HOME/jobs/logs/ats_digest.log"
{
  echo "[$(date '+%F %T')] ats_digest_now start"
  if [ -x "$HOME/jobs/bin/atsdigest" ]; then
    "$HOME/jobs/bin/atsdigest"
  elif command -v atsdigest >/dev/null 2>&1; then
    atsdigest
  else
    echo "WARN: atsdigest not found. Expect ~/jobs/bin/atsdigest to exist."
  fi
  echo "[$(date '+%F %T')] ats_digest_now done"
} >> "$LOG" 2>&1
