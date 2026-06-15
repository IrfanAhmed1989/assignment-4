#!/usr/bin/env bash
set -euo pipefail
OUT="$HOME/jobs/logs/support_$(date +%Y%m%d_%H%M%S).zip"
cd "$HOME/jobs"

INCLUDE=(
  "APP_README.md"
  "targets.csv"
  "suppress.txt"
  "bin/*.sh"
  "bin/*.py"
  "bin/roles.conf"
  "bin/rich_countries.txt"
  "logs/*.log"
  "logs/*.md"
)

zip -r "$OUT" ${INCLUDE[@]} >/dev/null 2>&1 || true
echo "✅ Support bundle → $OUT"
open -R "$OUT"
