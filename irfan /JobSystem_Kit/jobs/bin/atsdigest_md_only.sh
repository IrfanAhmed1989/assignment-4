#!/usr/bin/env bash
set -euo pipefail
CSV="$HOME/jobs/ats.csv"
OUT="$HOME/jobs/logs/ats_digest_$(date +%F).md"
[ -f "$CSV" ] || { echo "date,company,url,role,notes" > "$CSV"; }

if date -v -7d +%F >/dev/null 2>&1; then CUT=$(date -v -7d +%F); else CUT=$(date -d '7 days ago' +%F); fi

{
  echo "# ATS Digest (last 7 days) – $(date '+%F %T')"
  echo
  echo "Since **$CUT**."
  echo
  echo "| Date | Company | Role | Link | Notes |"
  echo "|---|---|---|---|---|"
  awk -F, -v cut="$CUT" 'NR>1 && $1>=cut {
    for(i=2;i<=5;i++){ gsub(/^"|"$/, "", $i) }
    gsub(/\|/, "\\|", $2); gsub(/\|/, "\\|", $4); gsub(/\|/, "\\|", $5);
    printf("| %s | %s | %s | %s | %s |\n", $1, $2, $4, $3, $5);
  }' "$CSV"
} > "$OUT"

echo "$OUT"
