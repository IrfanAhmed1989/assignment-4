#!/bin/zsh
set -e

OUT="$HOME/jobs/inbox/linkedin_$(date +%F_%H%M).csv"
echo "company,email,role,location,notes" > "$OUT"

ROLES=("IT Engineer" "Software Engineer" "Electrical Engineer" "Project Engineer")
LOC="Chicago"

for ROLE in "${ROLES[@]}"; do
  FEED="https://www.linkedin.com/jobs-guest/jobs/api/seeMoreJobPostings/search?keywords=${ROLE// /+}&location=${LOC// /+}"
  curl -s "$FEED" |
  grep -oP 'data-company-name="[^"]+"' |
  sed 's/data-company-name="//;s/"$//' |
  while read COMPANY; do
    HR="careers@${COMPANY// /}.com"
    echo "$COMPANY,$HR,$ROLE,$LOC,LinkedIn Feed" >> "$OUT"
  done
done
