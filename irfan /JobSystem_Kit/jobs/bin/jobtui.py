#!/usr/bin/env python3
import os, csv, curses, textwrap, re
from datetime import date, datetime, timedelta

HOME   = os.path.expanduser("~")
JOBS   = os.path.join(HOME, "jobs")
LOG    = os.path.join(JOBS, "logs")
APPLIED= os.path.join(LOG, "applied.csv")
MAIL   = os.path.join(LOG, "mail_debug.log")
TARGETS= os.path.join(JOBS, "targets.csv")
APALL  = os.path.join(LOG, "launchd_apall.log")   # optional scheduler log

ALL, REMOTE, CHI = 0, 1, 2
wrap = lambda s, w: textwrap.shorten(str(s), width=w, placeholder="…")

def parse_dt(s):
    s = (s or "").strip()
    for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M", "%Y-%m-%d"):
        try: return datetime.strptime(s, fmt)
        except ValueError: pass
    return None

def read_applied():
    rows = []
    if not os.path.exists(APPLIED): return rows
    with open(APPLIED, newline="", encoding="utf-8", errors="ignore") as f:
        r = csv.reader(f)
        for row in r:
            if len(row) < 6: continue
            when = parse_dt(row[0])
            if not when: continue
            rows.append({
                "date": when, "company": row[1], "email": row[2],
                "role": row[3], "location": row[4], "notes": row[5],
            })
    return rows

def read_mail_tail(n=5):
    if not os.path.exists(MAIL): return ["(no mail_debug.log yet)"]
    with open(MAIL, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()
    return [l.strip() for l in lines[-n:]] or ["(empty)"]

def targets_count():
    if not os.path.exists(TARGETS): return 0
    try:
        with open(TARGETS, "r", encoding="utf-8", errors="ignore") as f:
            return max(0, sum(1 for _ in f) - 1)     # minus CSV header
    except: return 0

def country(loc):
    if not isinstance(loc, str): return "Other/Unknown"
    low = loc.lower()
    if low.startswith("remote - "): return loc.split("-", 1)[1].strip()
    if any(k in low for k in ["chicago", "lombard", "illinois", " il"]):
        return "United States (Chicago-area)"
    return "Other/Unknown"

def apply_filter(rows, mode):
    if mode == REMOTE:
        return [r for r in rows if isinstance(r["location"], str) and r["location"].lower().startswith("remote - ")]
    if mode == CHI:
        return [r for r in rows if isinstance(r["location"], str) and ("chicago" in r["location"].lower() or
                                                                      "lombard" in r["location"].lower() or
                                                                      "illinois" in r["location"].lower() or
                                                                      " il" in r["location"].lower())]
    return rows

def apply_search(rows, term):
    if not term: return rows
    t = term.lower()
    out = []
    for r in rows:
        blob = " ".join([str(r.get(k,"")) for k in ("company","role","location","email")]).lower()
        if t in blob: out.append(r)
    return out

def top_counts(rows, key, limit=6):
    from collections import Counter
    return Counter((r.get(key) or "").strip() for r in rows if r.get(key)).most_common(limit)

def top_countries(rows, limit=6):
    from collections import Counter
    return Counter(country(r.get("location")) for r in rows).most_common(limit)

def bar(v, m, w):
    if m <= 0: return ""
    filled = int((v / m) * max(1, w))
    return "█" * filled

def tail_lines(path, n=1200):
    if not os.path.exists(path): return []
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()
    return lines[-n:]

def summarize_skips():
    lines = tail_lines(APALL, 2000)
    counts = {"already":0, "suppressed":0, "location":0}
    last_sent = None
    sent_re = re.compile(r"apply_now:\s*Sent\s+(\d+)", re.IGNORECASE)
    for ln in lines:
        low = ln.lower()
        if "already sent today" in low: counts["already"] += 1
        if "suppressed:" in low: counts["suppressed"] += 1
        if "skip by location rule" in low: counts["location"] += 1
        m = sent_re.search(ln)
        if m: last_sent = int(m.group(1))
    return counts, (last_sent if last_sent is not None else 0)

def weekly_export(rows):
    today = date.today()
    start = today - timedelta(days=6)
    in7 = [r for r in rows if start <= r["date"].date() <= today]
    from collections import Counter
    day_ct = Counter(r["date"].date().isoformat() for r in in7)
    role_ct = Counter((r.get("role") or "").strip() for r in in7 if r.get("role"))
    ctry_ct = Counter(country(r.get("location")) for r in in7)
    out = os.path.join(LOG, f"weekly_summary_{today.isoformat().replace('-','')}.csv")
    with open(out, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f); w.writerow(["section","key","value"])
        for d in sorted(day_ct): w.writerow(["daily", d, day_ct[d]])
        for k,v in role_ct.most_common(): w.writerow(["role", k, v])
        for k,v in ctry_ct.most_common(): w.writerow(["country", k, v])
    return out

def get_input(stdscr, prompt, put):
    curses.echo()
    h, w = stdscr.getmaxyx()
    put(h-2, 2, " " * (w-4))
    put(h-2, 2, prompt)
    stdscr.refresh()
    try:
        s = stdscr.getstr(h-2, 2+len(prompt), 120)
        txt = s.decode("utf-8", "ignore")
    except Exception:
        txt = ""
    curses.noecho()
    return txt

def draw_help(stdscr, h, w, put):
    for i, t in enumerate([
        "Keys:",
        "  q Quit   r Refresh   ? Help",
        "  1 ALL    2 Remote    3 Chicago-only",
        "  s Skips panel (from launchd_apall.log)",
        "  / Search (company/role/location/email)  c Clear search",
        "  e Export weekly summary CSV (~/jobs/logs/weekly_summary_YYYYMMDD.csv)",
        "",
        "Panels: KPIs, Top Roles, Top Countries, Recent 20, Last 5 mail log lines"
    ]):
        put(2+i, 2, t)

def main(stdscr):
    curses.curs_set(0)
    stdscr.nodelay(False)
    mode, err, search = ALL, "", ""

    def put(y, x, s, attr=0):
        # safe print: clip to the window so addstr never throws
        h, w = stdscr.getmaxyx()
        if y < 0 or y >= h: return
        if x < 0:
            s = s[-x:]
            x = 0
        if x >= w: return
        maxlen = max(0, w - x - 1)
        stdscr.addstr(y, x, s[:maxlen], attr)

    while True:
        stdscr.erase()
        h, w = stdscr.getmaxyx()
        put(0, 2, wrap("Jobs TUI — Irfan  [1/2/3 filter | / search | s skips | e export | r refresh | ? help | q quit]", w-4), curses.A_BOLD)

        try:
            data = read_applied()
            rows = apply_filter(data, mode)
            rows = apply_search(rows, search)
            tgt  = targets_count()
        except Exception as e:
            data, rows, err = [], [], f"{e}"

        today = date.today()
        last7 = today - timedelta(days=6)
        sent_today = sum(1 for r in rows if r["date"].date() == today)
        sent_7d    = sum(1 for r in rows if last7 <= r["date"].date() <= today)
        total      = len(rows)
        kpi = f"Sent Today: {sent_today}   Last 7d: {sent_7d}   Total: {total}   Targets CSV: {tgt}"
        if search: kpi += f"   [search='{search}']"
        put(2, 2, wrap(kpi, w-4), curses.A_REVERSE)

        # Top sections
        r = 4; c1 = 2; c2 = w//2 + 1
        put(r, c1, "Top Roles", curses.A_BOLD)
        put(r, c2, "Top Countries", curses.A_BOLD); r += 1

        if rows:
            roles = top_counts(rows, "role", 6)
            cntrs = top_countries(rows, 6)
            maxr  = max([v for _, v in roles] or [0])
            maxc  = max([v for _, v in cntrs] or [0])
            wb    = (w//2) - 12

            for i,(name,val) in enumerate(roles):
                line = f"{wrap(name,16):16} {val:>4} {bar(val, maxr, wb)}"
                if r+i < h-8: put(r+i, c1, wrap(line, (w//2)-4))
            for i,(name,val) in enumerate(cntrs):
                line = f"{wrap(name,22):22} {val:>4} {bar(val, maxc, wb)}"
                if r+i < h-8: put(r+i, c2, wrap(line, (w//2)-4))
            r = r + max(len(roles), len(cntrs)) + 1
        else:
            put(r, c1, "(no data)", curses.A_DIM)
            put(r, c2, "(no data)", curses.A_DIM); r += 2

        # Recent 20
        put(r, 2, "Recent 20 applications", curses.A_BOLD); r += 1
        put(r, 2, wrap("When              Company                 Role                  Location              Email", w-4), curses.A_UNDERLINE); r += 1
        if rows:
            recent = sorted(rows, key=lambda x: x["date"], reverse=True)[:20]
            for row in recent:
                when = row["date"].strftime("%Y-%m-%d %H:%M")
                line = f"{when:16}  {wrap(row['company'],22):22}  {wrap(row['role'],20):20}  {wrap(row['location'],20):20}  {wrap(row['email'],25):25}"
                if r < h-6: put(r, 2, wrap(line, w-4)); r += 1
        else:
            put(r, 2, "(no applications yet)", curses.A_DIM); r += 1

        # Mail log tail
        put(h-6, 2, "Last 5 mail log lines", curses.A_BOLD)
        for i, ln in enumerate(read_mail_tail(5)):
            if h-5+i < h-1: put(h-5+i, 2, wrap(ln, w-4))

        # Footer (always clipped)
        fname = {ALL:"ALL", REMOTE:"REMOTE", CHI:"CHICAGO"}[mode]
        footer = f"[{fname}] r:refresh  1/2/3:filter  /:search  c:clear  s:skips  e:export  ?:help  q:quit"
        put(h-1, 2, wrap(footer, w-4))
        if err: put(h-1, max(2, w-len(err)-2), err[:max(0,w-4)], curses.A_REVERSE)

        ch = stdscr.getch()
        if ch in (ord('q'), ord('Q')): break
        elif ch in (ord('r'), ord('R')): err = ""
        elif ch == ord('?'):
            stdscr.erase(); draw_help(stdscr, h, w, put); put(h-1,2,"Press any key…"); stdscr.getch()
        elif ch == ord('1'): mode = ALL
        elif ch == ord('2'): mode = REMOTE
        elif ch == ord('3'): mode = CHI
        elif ch == ord('/'):
            txt = get_input(stdscr, "Search: ", put)
            search = (txt or "").strip()
        elif ch in (ord('c'), ord('C')): search = ""
        elif ch in (ord('s'), ord('S')):
            stdscr.erase()
            put(0,2,"Skips (from launchd_apall.log):", curses.A_BOLD)
            counts, sent_last = summarize_skips()
            put(2,2,f"Already sent today: {counts['already']}")
            put(3,2,f"Suppressed:         {counts['suppressed']}")
            put(4,2,f"Skip by location:   {counts['location']}")
            put(6,2,f"Last run 'Sent':    {sent_last}")
            put(h-1,2,"Press any key…"); stdscr.getch()
        elif ch in (ord('e'), ord('E')):
            try: out = weekly_export(read_applied()); put(h-1,2,f"Exported: {out}   (press any key)"); stdscr.getch()
            except Exception as ex: put(h-1,2,f"Export error: {ex}   (press any key)"); stdscr.getch()

if __name__ == "__main__":
    try:
        curses.wrapper(main)
    except KeyboardInterrupt:
        pass
