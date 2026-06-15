#!/usr/bin/env bash
set -euo pipefail

IN="$HOME/jobs/targets.csv"
OUT="$HOME/jobs/targets.tmp"
[ -f "$IN" ] || { echo "❌ Missing $IN"; exit 1; }

country_for_tld() {
  # lowercase safely for macOS bash 3.2
  local dom="$(echo "$1" | tr '[:upper:]' '[:lower:]')"

  # Multi-part TLDs first
  case "$dom" in
    *.co.uk)    echo "Remote - United Kingdom"; return ;;
    *.com.au)   echo "Remote - Australia"; return ;;
    *.co.nz)    echo "Remote - New Zealand"; return ;;
    *.co.jp)    echo "Remote - Japan"; return ;;
    *.co.kr)    echo "Remote - South Korea"; return ;;
  esac

  # Single TLDs
  case "$dom" in
    *.ca) echo "Remote - Canada" ;;
    *.uk) echo "Remote - United Kingdom" ;;
    *.de) echo "Remote - Germany" ;;
    *.nl) echo "Remote - Netherlands" ;;
    *.ch) echo "Remote - Switzerland" ;;
    *.se) echo "Remote - Sweden" ;;
    *.no) echo "Remote - Norway" ;;
    *.dk) echo "Remote - Denmark" ;;
    *.fi) echo "Remote - Finland" ;;
    *.be) echo "Remote - Belgium" ;;
    *.at) echo "Remote - Austria" ;;
    *.fr) echo "Remote - France" ;;
    *.es) echo "Remote - Spain" ;;
    *.it) echo "Remote - Italy" ;;
    *.ie) echo "Remote - Ireland" ;;
    *.sg) echo "Remote - Singapore" ;;
    *.ae) echo "Remote - UAE" ;;
    *.qa) echo "Remote - Qatar" ;;
    *.lu) echo "Remote - Luxembourg" ;;
    *.cz) echo "Remote - Czech Republic" ;;
    *)    echo "" ;;
  esac
}

{
  # header
  IFS=, read -r H1 H2 H3 H4 H5
  echo "$H1,$H2,$H3,$H4,$H5"

  # rows: company,email,role,location,notes
  while IFS=',' read -r COMPANY EMAIL ROLE LOCATION NOTES; do
    [[ -z "${COMPANY// }" && -z "${EMAIL// }" ]] && continue
    DOM="${EMAIL#*@}"
    NEWLOC="$(country_for_tld "$DOM")"
    if [ -n "$NEWLOC" ]; then
      LOCATION="$NEWLOC"
    fi
    printf '%s,%s,%s,%s,%s\n' "$COMPANY" "$EMAIL" "$ROLE" "$LOCATION" "$NOTES"
  done
} < "$IN" > "$OUT"

mv "$OUT" "$IN"
echo "✅ Remote-by-TLD tagging complete (macOS-safe)."
