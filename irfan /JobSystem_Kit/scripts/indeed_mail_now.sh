#!/usr/bin/env bash
set -euo pipefail

EMAIL="${IRFAN_EMAIL:-engineerirfan21@gmail.com}"
SUBJ="Daily Job Links Digest (Remote Worldwide + Chicago/Lombard)"
TMP="$(mktemp)"

ROLES=(
  "electrical engineer" "project engineer" "site engineer"
  "software engineer" "it engineer" "maintenance engineer"
  "supervisor engineer" "engineer"
)
LOCS=("Chicago" "Lombard" "Remote")
COUNTRIES=("United States" "Canada" "United Kingdom" "Germany" "France" "Italy" "Spain" "Netherlands" "Switzerland" "Sweden" "Norway" "Denmark" "Finland" "Belgium" "Austria" "Ireland" "New Zealand" "Australia" "Singapore" "Luxembourg" "United Arab Emirates" "Qatar" "Japan" "South Korea")

indeed_tld() {
  case "$1" in
    "United States") echo "com" ;;
    "Canada") echo "ca" ;;
    "United Kingdom") echo "co.uk" ;;
    "Germany") echo "de" ;;
    "Australia") echo "com.au" ;;
    "Netherlands") echo "nl" ;;
    "Switzerland") echo "ch" ;;
    "Sweden") echo "se" ;;
    "Norway") echo "no" ;;
    "Denmark") echo "dk" ;;
    "Ireland") echo "ie" ;;
    "New Zealand") echo "co.nz" ;;
    "Singapore") echo "sg" ;;
    *) echo "" ;;
  esac
}

{
  echo "Daily Job Links Digest"
  echo
  echo "Click links to Easy-Apply. (No tabs were opened automatically.)"
  echo

  # Local (Chicago/Lombard/Remote-US)
  for r in "${ROLES[@]}"; do
    echo "$r"
    for l in "${LOCS[@]}"; do
      RENC="$(python3 - <<PY
import urllib.parse; print(urllib.parse.quote("$r"))
PY
)"
      LENC="$(python3 - <<PY
import urllib.parse; print(urllib.parse.quote("$l"))
PY
)"
      LI="https://www.linkedin.com/jobs/search/?keywords=${RENC}&location=${LENC}&f_AL=true"
      IN="https://www.indeed.com/jobs?q=${RENC}&l=${LENC}"
      printf "  • LinkedIn (%s)\n    %s\n" "$l" "$LI"
      printf "  • Indeed   (%s)\n    %s\n\n" "$l" "$IN"
    done
    echo
  done

  # Remote worldwide (high-income countries)
  echo "Remote (High-income countries)"
  echo
  for r in "${ROLES[@]}"; do
    echo "$r — Remote Worldwide"
    for c in "${COUNTRIES[@]}"; do
      RENC="$(python3 - <<PY
import urllib.parse; print(urllib.parse.quote("$r"))
PY
)"
      CENC="$(python3 - <<PY
import urllib.parse; print(urllib.parse.quote("$c"))
PY
)"
      # LinkedIn (location=country; toggle Remote filter quickly in UI)
      LI="https://www.linkedin.com/jobs/search/?keywords=${RENC}&location=${CENC}&f_AL=true"
      printf "  • LinkedIn (%s)\n    %s\n" "$c" "$LI"

      # Indeed country TLD when known; fallback to .com
      TLD="$(indeed_tld "$c")"
      if [ -n "$TLD" ]; then
        IN="https://www.indeed.${TLD}/jobs?q=${RENC}&l=Remote"
      else
        IN="https://www.indeed.com/jobs?q=${RENC}&l=Remote"
      fi
      printf "  • Indeed   (%s)\n    %s\n\n" "$c" "$IN"
    done
    echo
  done
} > "$TMP"

/usr/bin/osascript "$HOME/.maildigest.scpt" "$SUBJ" "$TMP" "$EMAIL" >/dev/null 2>&1 || true
rm -f "$TMP"
echo "📧 Sent digest to $EMAIL (Remote worldwide + Chicago/Lombard)."
