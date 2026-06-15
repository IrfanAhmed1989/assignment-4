#!/usr/bin/env bash
set -euo pipefail

CSV="$HOME/jobs/targets.csv"
BAK="$HOME/jobs/targets.csv.BAK.$(date +%Y%m%d%H%M%S)"
LOG="$HOME/jobs/logs/pre_apply_clean.log"
mkdir -p "$HOME/jobs/logs"

# Chicago words + suburbs we accept as Chicago area
CHI_WORDS='chicago|lombard|illinois| il|schaumburg|naperville|oak brook|oakbrook|downers grove|aurora|evanston|skokie|des plaines|desplaines|oak park|oakpark|elmhurst|addison|lisle|wheaton|rosemont|itasca|arlington heights|arlingtonheights|glendale heights|glendaleheights|maywood|river forest|riverforest|berwyn|cicero|westmont|villa park|villapark|melrose park|melrosepark|bolingbrook|oak lawn|palatine|park ridge|hoffman estates|hoffmanestates|northbrook|deerfield|lake forest|lakeforest|highland park|highlandpark|elk grove|elkgrove|elgin|glenview|niles|lincolnshire|tinley park|tinleypark|north chicago|northchicago|downers grove|downersgrove'

cp "$CSV" "$BAK" 2>/dev/null || true

python3 - <<'PY'
import csv, os, re, sys
from pathlib import Path

csv_path = Path(os.path.expanduser('~/jobs/targets.csv'))
bak_path = Path(str(csv_path) + '.TMP')
chi_rx = re.compile(r'(chicago|lombard|illinois| il|schaumburg|naperville|oak brook|oakbrook|downers grove|aurora|evanston|skokie|des plaines|desplaines|oak park|oakpark|elmhurst|addison|lisle|wheaton|rosemont|itasca|arlington heights|arlingtonheights|glendale heights|glendaleheights|maywood|river forest|riverforest|berwyn|cicero|westmont|villa park|villapark|melrose park|melrosepark|bolingbrook|oak lawn|palatine|park ridge|hoffman estates|hoffmanestates|northbrook|deerfield|lake forest|lakeforest|highland park|highlandpark|elk grove|elkgrove|elgin|glenview|niles|lincolnshire|tinley park|tinleypark|north chicago|northchicago|downers grove|downersgrove)', re.I)

def norm_email(raw):
    if not raw: return raw
    r = raw.strip().strip('"').strip()
    # extract <...> if present
    if '<' in r and '>' in r:
        r = r.split('<',1)[1].split('>',1)[0]
    r = r.replace(' ', '').strip().lower().strip('"').strip("'")
    # if still weird, try pick token with '@'
    if '@' not in r:
        parts = re.split(r'\s|,|;', raw.lower().replace('"','').replace("'",''))
        for p in parts:
            if '@' in p:
                r = p
                break
    return r

with csv_path.open(newline='') as f, bak_path.open('w', newline='') as g:
    r = csv.reader(f)
    w = csv.writer(g)
    header = next(r, [])
    if header:
        w.writerow(header)
    for row in r:
        if len(row) < 5:
            continue
        company, email, role, location, notes = row[:5]
        email = norm_email(email)
        # If non-remote AND matches a suburb, annotate as Chicago area
        if not re.match(r'(?i)^remote\s*-\s*', location or ''):
            loc_low = (location or '').lower()
            if chi_rx.search(loc_low) and 'chicago area' not in loc_low:
                location = f"{location} (Chicago area)"
        w.writerow([company, email, role, location, notes])

bak_path.replace(csv_path)
print('✅ pre_apply_clean: targets.csv normalized')
PY

echo "[$(date '+%F %T')] cleaned targets.csv" >> "$LOG"
