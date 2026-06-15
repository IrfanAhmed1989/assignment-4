#!/bin/zsh
set -e

OUT="$HOME/jobs/inbox/indeed_$(date +%F_%H%M).csv"
echo "company,email,role,location,notes" > "$OUT"

# Your roles
ROLES=("IT Engineer" "Software Engineer" "Project Engineer" "Electrical Engineer" "Controls Engineer" "Site Engineer")

# Your locations
LOCATIONS=("Chicago" "Illinois" "Remote")

# Pull Indeed RSS feeds
for ROLE in "${ROLES[@]}"; do
  for LOC in "${LOCATIONS[@]}"; do
    FEED=$(echo "https://www.indeed.com/rss?q=${ROLE// /+}&l=${LOC// /+}")
    curl -s "$FEED" | grep -E "<title>|<link>" |
    sed 's/<[^>]*>//g' |
    paste - - |
    while IFS=$'\t' read -r TITLE URL; do
      COMPANY=$(echo "$TITLE" | awk -F"-" '{print $2}' | xargs)
      ROLE=$(echo "$TITLE" | awk -F"-" '{print $1}' | xargs)

      # Try guessing HR email
      HR="careers@${COMPANY// /}.com"
      
      echo "$COMPANY,$HR,$ROLE,$LOC,Indeed RSS" >> "$OUT"
    done
  done
done
