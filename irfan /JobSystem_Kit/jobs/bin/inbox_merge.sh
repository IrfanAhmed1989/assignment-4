#!/usr/bin/env bash
set -euo pipefail

INBOX="$HOME/jobs/inbox"
TARGETS="$HOME/jobs/targets.csv"
SUPPRESS="$HOME/jobs/suppress.txt"
LOG="$HOME/jobs/logs/inbox_merge.log"
mkdir -p "$INBOX" "$HOME/jobs/logs"
touch "$SUPPRESS"
[ -f "$TARGETS" ] || echo "company,email,role,location,notes" > "$TARGETS"

ROLES_FILE="$HOME/jobs/bin/roles.conf"
RICH_FILE="$HOME/jobs/bin/rich_countries.txt"

# Core + suburbs for Chicago area
CHI_CORE='chicago|lombard|illinois| il'
CHI_SUBURBS='schaumburg|naperville|oak brook|oakbrook|downers grove|aurora|evanston|skokie|des plaines|desplaines|oak park|oakpark|elmhurst|addison|lisle|wheaton|rosemont|itasca|arlington heights|arlingtonheights|glendale heights|glendaleheights|maywood|river forest|riverforest|berwyn|cicero|westmont|villa park|villapark|melrose park|melrosepark|bolingbrook|oak lawn|oakwawn|palatine|park ridge|hoffman estates|hoffmanestates|northbrook|deerfield|lake forest|lakeforest|highland park|highlandpark|elk grove|elkgrove|elgin|glenview|niles|lincolnshire|tinley park|tinleypark|north chicago|northchicago|downers grove|downersgrove'

normalize_email() {
  local raw="$1"
  # extract inside <...> if present
  if [[ "$raw" == *'<'*'>'* ]]; then
    raw="${raw#*<}"; raw="${raw%%>*}"
  fi
  # strip quotes and spaces
  raw="${raw%\"}"; raw="${raw#\"}"
  raw="$(echo "$raw" | tr '[:upper:]' '[:lower:]' | tr -d ' ')"
  # if still contains a name + email, pick the token with @
  if [[ "$raw" != *'@'* ]]; then
    raw="$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d '"' | tr ' ' '\n' | awk '/@/ {print; exit}')"
  fi
  echo "$raw"
}

shopt -s nullglob
for f in "$INBOX"/*.csv; do
  {
    echo "[$(date '+%F %T')] merging $f"
    tail -n +2 "$f" | while IFS=, read -r company email role location notes; do
      # strip simple quotes
      company="${company%\"}"; company="${company#\"}"
      role="${role%\"}";     role="${role#\"}"
      location="${location%\"}"; location="${location#\"}"
      notes="${notes%\"}";   notes="${notes#\"}"

      email="$(normalize_email "$email")"
      [[ -z "$email" || "$email" != *"@"* ]] && { echo "bad email: $email" >> "$LOG"; continue; }
      if grep -qi "^${email}$" "$SUPPRESS" 2>/dev/null; then
        echo "skip suppressed: $email" >> "$LOG"; continue
      fi

      # role filter
      rolelow="$(echo "$role" | tr '[:upper:]' '[:lower:]')"
      keep=0
      while read -r r; do
        [ -z "$r" ] && continue
        rlow="$(echo "$r" | tr '[:upper:]' '[:lower:]')"
        if [[ "$rolelow" == *"$rlow"* ]]; then keep=1; break; fi
      done < "$ROLES_FILE"
      [[ $keep -eq 0 ]] && { echo "skip role: $role ($email)" >> "$LOG"; continue; }

      # location rules
      loclow="$(echo "$location" | tr '[:upper:]' '[:lower:]')"
      if [[ "$location" =~ ^[Rr]emote[[:space:]]*-[[:space:]]* ]]; then
        country="${location#Remote - }"; country="${country#remote - }"
        allow_remote=0
        while read -r c; do
          [ -z "$c" ] && continue
          if [[ "$country" =~ $c ]]; then allow_remote=1; break; fi
        done < "$RICH_FILE"
        [[ $allow_remote -eq 0 ]] && { echo "skip remote not-rich: $email ($location)" >> "$LOG"; continue; }
      else
        if echo "$loclow" | grep -Eq "$CHI_CORE"; then
          : # ok
        elif echo "$loclow" | grep -Eq "$CHI_SUBURBS"; then
          location="$location (Chicago area)"
        else
          echo "skip non-Chicago: $email ($location)" >> "$LOG"; continue
        fi
      fi

      echo "\"$company\",\"$email\",\"$role\",\"$location\",\"$notes\"" >> "$TARGETS"
    done

    # dedupe exact rows but keep header
    awk -F, 'NR==1{print;next}!seen[$0]++' "$TARGETS" > "$TARGETS.clean" && mv "$TARGETS.clean" "$TARGETS"

    mkdir -p "$INBOX/processed"
    mv "$f" "$INBOX/processed/$(basename "$f").$(date +%s)"
    echo "done $f"
  } >> "$LOG" 2>&1
done
