#!/usr/bin/env bash
set -euo pipefail
LOG="$HOME/jobs/logs/apply_ready.log"
DATE=$(date '+%F %T')

TARGET="$HOME/jobs/targets.csv"
READY="$HOME/jobs/targets.ready.csv"
BAK="$HOME/jobs/targets.csv.BAK.$(date +%Y%m%d%H%M%S)"
RICH="$HOME/jobs/bin/rich_countries.txt"

echo "[$DATE] build READY from targets.csv" >> "$LOG"

python3 - <<'PY'
import csv, os, re
from pathlib import Path
rich = [l.strip() for l in open(os.path.expanduser('~/jobs/bin/rich_countries.txt')) if l.strip()]
chi_pat = re.compile(r'(chicago|lombard|illinois| il|schaumburg|naperville|oak brook|oakbrook|downers grove|aurora|evanston|skokie|des plaines|desplaines|oak park|oakpark|elmhurst|addison|lisle|wheaton|rosemont|itasca|arlington heights|arlingtonheights|glendale heights|glendaleheights|maywood|river forest|riverforest|berwyn|cicero|westmont|villa park|villapark|melrose park|melrosepark|bolingbrook|oak lawn|palatine|park ridge|hoffman estates|hoffmanestates|northbrook|deerfield|lake forest|lakeforest|highland park|highlandpark|elk grove|elkgrove|elgin|glenview|niles|lincolnshire|tinley park|tinleypark|north chicago|northchicago|downers grove|downersgrove|chicago area)', re.I)

def norm_email(raw):
    if not raw: return raw
    r = raw.strip().strip('"').strip()
    if '<' in r and '>' in r:
        r = r.split('<',1)[1].split('>',1)[0]
    r = r.replace(' ', '').lower().strip('"').strip("'")
    if '@' not in r:
        for t in re.split(r'[\s,;]', raw.lower().replace('"','').replace("'","")):
            if '@' in t: r = t; break
    return r

src = Path(os.path.expanduser('~/jobs/targets.csv'))
dst = Path(os.path.expanduser('~/jobs/targets.ready.csv'))
with src.open(newline='') as f, dst.open('w', newline='') as g:
    r = csv.reader(f); w = csv.writer(g)
    header = next(r, [])
    if header: w.writerow(header)
    for row in r:
        if len(row) < 5: continue
        company, email, role, location, notes = row[:5]
        email = norm_email(email)
        if not email or '@' not in email: continue
        loc = (location or '')

        # Remote — only rich countries
        if re.match(r'(?i)^remote\s*-\s*', loc):
            country = re.sub(r'(?i)^remote\s*-\s*', '', loc).strip()
            if any(country == rc or rc in country for rc in rich):
                w.writerow([company, email, role, location, notes])
        else:
            # Chicago or suburbs — normalize to engine-friendly location
            if chi_pat.search(loc.lower()):
                location_norm = "Chicago (IL)"
                w.writerow([company, email, role, location_norm, notes])
PY

# Swap in; apply; restore original file
cp "$TARGET" "$BAK" 2>/dev/null || true
mv "$HOME/jobs/targets.ready.csv" "$HOME/jobs/targets.csv"
{
  echo "[$DATE] READY swapped in → applying..."
  bash "$HOME/jobs/bin/apply_now.sh" 200
  echo "[$DATE] apply done; restoring original targets.csv"
} >> "$LOG" 2>&1
mv "$BAK" "$HOME/jobs/targets.csv" 2>/dev/null || true
echo "[$DATE] complete" >> "$LOG"
