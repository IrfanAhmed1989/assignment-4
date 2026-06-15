#!/usr/bin/env bash
set -euo pipefail

# -------- Settings --------
IRFAN_JOBS="$HOME/jobs"
IRFAN_EMAIL="${IRFAN_EMAIL:-engineerirfan21@gmail.com}"
IRFAN_NAME="Irfan Ahmed"
IRFAN_PHONE="470-647-6376"
IRFAN_RESUME="$HOME/irfan-portfolio/resume.pdf"
TARGETS="$IRFAN_JOBS/targets.csv"
APPLIED="$IRFAN_JOBS/logs/applied.csv"
SUPPRESS="$IRFAN_JOBS/suppress.txt"
MAILLOG="$IRFAN_JOBS/logs/mail_debug.log"
LIMIT="${1:-200}"                # default to 200
COOLDOWN_DAYS=3                  # <-- 7-day no-repeat window (email+role)

# Chicago area whitelist (add more if you like)
CHICAGO_AREAS="chicago|lombard|arlington heights|northbrook|tinley park|lisle|deerfield|north chicago|downers grove|oak brook|naperville|schaumburg|evanston|elmhurst|rosemont|bridgeview|cicero|berwyn|oak park|chicagoland|illinois|il"

# -------- Guards --------
mkdir -p "$IRFAN_JOBS/logs"
[ -f "$IRFAN_RESUME" ] || { echo "❌ Missing resume: $IRFAN_RESUME"; exit 1; }
[ -f "$TARGETS" ]      || { echo "❌ Missing targets file: $TARGETS"; exit 1; }
[ -f "$APPLIED" ]      || touch "$APPLIED"
[ -f "$SUPPRESS" ]     || touch "$SUPPRESS"

# -------- Helpers --------
email_syntax_ok() {
  python3 - "$1" <<'PY'
import re,sys
e=sys.argv[1].strip()
print("OK" if re.match(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$", e) else "BAD")
PY
}
email_mx_ok() {
  local dom="${1##*@}"
  if command -v dig >/dev/null 2>&1; then
    [ -n "$(dig +short MX "$dom" 2>/dev/null)" ] && echo OK || echo BAD
  else
    local out
    out="$(nslookup -type=mx "$dom" 2>/dev/null | grep -i 'mail exchanger' || true)"
    [ -n "$out" ] && echo OK || echo BAD
  fi
}
allow_by_location() {
  # If 'Remote' present -> allowed worldwide; otherwise only Chicago-area whitelist
  local LOC_LOWER; LOC_LOWER="$(echo "${1:-}" | tr '[:upper:]' '[:lower:]')"
  if echo "$LOC_LOWER" | grep -qi 'remote'; then return 0; fi
  echo "$LOC_LOWER" | grep -Eq "(^|,| |/|-)(${CHICAGO_AREAS})(,| |/|-|$)"
}
last_sent_days() {
  local EMAIL="$1" ROLE="$2" LOG="$APPLIED"
  [ -f "$LOG" ] || { echo 999; return; }
  local LAST
  LAST="$(awk -F, -v e="$EMAIL" -v r="$ROLE" '($3==e && $4==r){d=$1} END{print d}' "$LOG")"
  python3 - "$LAST" <<'PY'
import sys
from datetime import date
d=sys.argv[1].strip()
if not d:
  print(999); sys.exit(0)
y,m,da=map(int,d.split('-'))
print((date.today()-date(y,m,da)).days)
PY
}
role_intro() {
  local RLOW; RLOW="$(echo "${1:-}" | tr '[:upper:]' '[:lower:]')"
  if   echo "$RLOW" | grep -qE "electrical|e&i|controls|scada|mmis"; then
    echo "I focus on Electrical/Controls (SCADA/MMIS, PM, troubleshooting)."
  elif echo "$RLOW" | grep -qE "software|python|embedded|devops"; then
    echo "I build reliable software/automation (Python, Linux, CI)."
  elif echo "$RLOW" | grep -qE "it |network|systems"; then
    echo "I manage IT/systems and automation in Linux/macOS."
  elif echo "$RLOW" | grep -qE "site|project"; then
    echo "I handle site/project engineering with coordination and PM."
  elif echo "$RLOW" | grep -qE "maint|reliability"; then
    echo "I drive maintenance/reliability programs and uptime."
  else
    echo "I bring 10+ years of practical engineering with automation."
  fi
}
build_body() {
  local COMPANY="$1" ROLE="$2" LOC="$3"
  local INTRO; INTRO="$(role_intro "$ROLE")"
  cat <<TXT
Dear ${COMPANY} Hiring Team,

I’m applying for the ${ROLE:-Engineer} role in ${LOC:-Chicago}. ${INTRO}

Portfolio:  https://IrfanAhmed1989.github.io
GitHub:     https://github.com/IrfanAhmed1989
Resume:     https://IrfanAhmed1989.github.io/resume.pdf

Thank you,
$IRFAN_NAME
$IRFAN_EMAIL
$IRFAN_PHONE
TXT
}
send_one() {
  local TO="$1" SUB="$2" BODYFILE="$3"
  local OUT
  OUT=$(/usr/bin/osascript "$HOME/.mailsend.scpt" "$TO" "$SUB" "$BODYFILE" "$IRFAN_RESUME" "$IRFAN_EMAIL" 2>&1)
  echo "$(date '+%F %T')  TO=$TO  SUB=$SUB  OUT=$OUT  ATT=$IRFAN_RESUME" >> "$MAILLOG"
  [[ "$OUT" == OK* ]]
}

# -------- Main loop (no subshell; correct SENT) --------
D="$(date +%F)"
SENT=0

{
  IFS=, read -r _h1 _h2 _h3 _h4 _h5 || true   # skip header
  while IFS=',' read -r COMPANY EMAIL ROLE LOCATION NOTES; do
    [[ -z "${COMPANY:-}" || -z "${EMAIL:-}" ]] && continue

    EMAIL_LC="$(echo "$EMAIL" | tr '[:upper:]' '[:lower:]')"

    # Location rule
    if ! allow_by_location "${LOCATION:-}"; then
      echo "⏭️  Skip by location rule: $COMPANY <$EMAIL_LC> — ${ROLE:-Engineer} (${LOCATION:-})"
      continue
    fi

    # Suppression + same-day dedupe
    grep -qi "^${EMAIL_LC}$" "$SUPPRESS" && { echo "⏭️  Suppressed: $EMAIL_LC"; continue; }
    if grep -q "^$D,.*,$EMAIL_LC,${ROLE:-Engineer}," "$APPLIED" 2>/dev/null; then
      echo "⏭️  Already sent today: $EMAIL_LC"; continue
    fi

    # 7-day cooldown (email+role)
    DAYS="$(last_sent_days "$EMAIL_LC" "${ROLE:-Engineer}")"
    if [ "$DAYS" -lt "$COOLDOWN_DAYS" ]; then
      echo "⏭️  Skip 7d window: $EMAIL_LC (${DAYS} d)"
      continue
    fi

    # Validation
    [[ "$(email_syntax_ok "$EMAIL_LC")" == "OK" ]] || { echo "⏭️  Bad syntax: $EMAIL_LC"; continue; }
    [[ "$(email_mx_ok "$EMAIL_LC")" == "OK" ]]     || { echo "⏭️  No MX: $EMAIL_LC"; continue; }

    # Subject + body
    SUB="Application – ${ROLE:-Engineer} – $IRFAN_NAME"
    TMP_BODY="$(mktemp)"; build_body "$COMPANY" "${ROLE:-Engineer}" "${LOCATION:-Chicago}" > "$TMP_BODY"

    if send_one "$EMAIL_LC" "$SUB" "$TMP_BODY"; then
      echo "📨 Sent: $COMPANY <$EMAIL_LC> — ${ROLE:-Engineer} (${LOCATION:-Chicago})"
      printf '%s,%s,%s,%s,%s,%s\n' "$D" "$COMPANY" "$EMAIL_LC" "$ROLE" "$LOCATION" "$NOTES" >> "$APPLIED"
      SENT=$((SENT+1))
    else
      echo "❌ Send error: $COMPANY <$EMAIL_LC>"
    fi
    rm -f "$TMP_BODY"

    # small pause for Mail stability
    sleep 0.5

    [[ "$SENT" -ge "$LIMIT" ]] && break
  done
} < "$TARGETS"

echo "✅ apply_now: Sent $SENT (limit $LIMIT). Log: $MAILLOG"

# --- BEGIN IRFAN LOCATION OVERRIDE (Chicago + suburbs) ---
is_chicago_ok() {
  loc_l="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  case "$loc_l" in
    *"chicago"*|*"lombard"*|*"illinois"*|" il"*|*"schaumburg"*|*"naperville"*|*"oak brook"*|*"oakbrook"*|*"downers grove"*|*"aurora"*|*"evanston"*|*"skokie"*|*"des plaines"*|*"oak park"*|*"elmhurst"*|*"addison"*|*"lisle"*|*"wheaton"*|*"rosemont"*|*"itasca"*|*"arlington heights"*|*"glendale heights"*|*"maywood"*|*"river forest"*|*"berwyn"*|*"cicero"*|*"westmont"*|*"villa park"*|*"melrose park"*|*"bolingbrook"*|*"oak lawn"*|*"palatine"*|*"park ridge"*|*"hoffman estates"*|*"northbrook"*|*"deerfield"*|*"lake forest"*|*"highland park"*|*"elk grove"*|*"elgin"*|*"glenview"*|*"niles"*|*"lincolnshire"*|*"tinley park"*|*"north chicago"*|*"downers grove"* )
      return 0;;
  esac
  return 1
}
# --- END IRFAN LOCATION OVERRIDE ---
