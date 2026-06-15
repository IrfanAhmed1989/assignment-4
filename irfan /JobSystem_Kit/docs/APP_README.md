THIS_IS_TEMP
# Irfan's Job Automation — Master Runbook

Owner: Irfan Ahmed
Sender (From): engineerirfan21@gmail.com
Location of this file: ~/jobs/APP_README.md
Open from menubar: Jobs icon -> Open Runbook
Open from Desktop: ~/Desktop/APP_README.md

NOTE: Paste this ENTIRE file to Copilot if you ever need help. It contains everything about your app, rules, schedules, logs, and repair steps.

----------------------------------------------------------------

0) What this system does (in one look)

- Collect leads (Indeed/LinkedIn/boards/company sites) as CSV in an inbox
- Merge & clean -> validates role, fixes email syntax, applies location rules
- Apply automatically with resume attached (quiet, logged, cooldown)
- Runs hourly (or every 10 minutes) and on-demand via menubar
- Sends nightly email at 18:20 with Daily KPIs + ATS digest

Pipeline (text diagram):

Inbox CSVs  -->  inbox_merge.sh  -->  targets.csv
                     |
                     +-> pre_apply_clean.sh (emails + suburbs tagging)
                     |
                     +-> apply_ready.sh (filter/normalize) --> apply_now.sh 200
                                                             (resume, logs, cooldown)

----------------------------------------------------------------

1) Folder map (authoritative)

~/jobs/
  bin/                      # all scripts used by the system
  inbox/                    # drop CSVs here (company,email,role,location,notes)
  targets.csv               # master queue (header + rows)
  suppress.txt              # do-not-contact emails (one per line)
  logs/
    applied.csv             # YYYY-MM-DD,company,email,role,location,notes
    mail_debug.log          # OUT=OK proofs (+ ATT=/Users/irfan/irfan-portfolio/resume.pdf)
    inbox_merge.log         # merge/validation decisions
    pre_apply_clean.log     # email + location normalization
    apply_ready.log         # build 'ready' list, swap/apply/restore
    auto_apply_watch.log    # hourly (or 10-min) watcher
    daily_report_email.log  # nightly summary sender
    indeed_digest.log       # Indeed digest
    ats_digest.log          # ATS digest
    menu.out.log / menu.err.log  # menubar outputs

~/Applications/Jobs Menu Safe.app       # menubar app (safe; quiet)
~/Desktop/Job Control Center.app        # Desktop console (Dashboard/Readme/Support bundle)

~/Desktop/JobSystem_Kit/
  docs/APP_README.md                    # copy of this file
  apps/                                 # Desktop app copy + menubar symlink
  scripts/ configs/ launchagents/       # snapshot of your setup
  logs  ->  ~/jobs/logs                 # symlink (live)
  inbox_example/new_leads_TEMPLATE.csv  # feeder template

----------------------------------------------------------------

2) Roles & locations

Roles file: ~/jobs/bin/roles.conf (one per line)
- electrical engineer
- site engineer
- project engineer
- it engineer
- software engineer
- data engineer
- controls engineer
- systems engineer
- maintenance engineer
- supervisor engineer
- engineer

Location policy
- "Remote - COUNTRY" -> allowed only if COUNTRY is in rich countries list (below).
- Otherwise must be Chicago-area (Chicago or suburbs).
  * Merger tags suburbs as "(Chicago area)".
  * Wrapper coerces non-remote to "Chicago (IL)" so the engine never rejects by location.

Chicago-area examples (accepted):
Schaumburg, Naperville, Oak Brook, Oakbrook, Downers Grove, Aurora, Evanston, Skokie, Des Plaines, Oak Park, Elmhurst, Addison, Lisle, Wheaton, Rosemont, Itasca, Arlington Heights, Glendale Heights, Maywood, River Forest, Berwyn, Cicero, Westmont, Villa Park, Melrose Park, Bolingbrook, Oak Lawn, Palatine, Park Ridge, Hoffman Estates, Northbrook, Deerfield, Lake Forest, Highland Park, Elk Grove, Elgin, Glenview, Niles, Lincolnshire, Tinley Park, North Chicago, etc.

Rich countries for Remote (allowed):
United States, Canada, United Kingdom, Germany, Switzerland, Netherlands, Sweden, Norway, Denmark, Ireland, Australia, New Zealand, Singapore.

----------------------------------------------------------------

3) Automation pipeline (hourly / 10-min)

LaunchAgent: com.irfan.jobapply.watch
Default: hourly (set StartInterval=600 for every 10 minutes)

Steps each run
1. inbox_merge.sh
   - Reads ~/jobs/inbox/*.csv
   - Validates roles (roles.conf), emails (strips quotes & <...>), locations (Remote-rich or Chicago-area)
   - Appends valid rows to targets.csv (dedupe); archives processed files
   - Log: logs/inbox_merge.log

2. pre_apply_clean.sh
   - Normalizes emails in targets.csv ("Name" <mail@co.com> -> mail@co.com)
   - Tags suburbs with "(Chicago area)"
   - Log: logs/pre_apply_clean.log

3. apply_ready.sh (wrapper)
   - Builds a ready queue (Remote-rich OR Chicago-area)
   - For non-remote, sets location = "Chicago (IL)" (engine-friendly)
   - Swaps in ready file -> runs apply_now.sh 200 -> restores original targets.csv
   - Log: logs/apply_ready.log

4. apply_now.sh (engine)
   - Quiet email send with ~/irfan-portfolio/resume.pdf attached
   - Same-day dedupe & 7-day cooldown; honors suppress.txt
   - Proofs: logs/mail_debug.log | Tracker: logs/applied.csv

----------------------------------------------------------------

4) Menubar app (Jobs Menu Safe.app)

Open using:
open -a ~/Applications/"Jobs Menu Safe.app"

Starts at login using:
~/Library/LaunchAgents/com.irfan.jobs.menu.safe.plist

Title format:
T:<today> · Q:<queue> 
Automatically updates every 5 minutes. Shows "⏸" when paused.

Menu actions:
- Apply 50 / 200 (uses apply_ready wrapper so location never blocks)
- Pause/Resume Auto‑Apply
- Send Indeed Digest
- Send ATS Digest
- Generate Daily Report
- Copy Debug Snapshot (clipboard)
- Health Check (clipboard)
- Install or Repair Schedules
- Open Dashboard
- Open Logs
- Open targets.csv
- Open applied.csv
- Open mail_debug.log
- Open Runbook (this file)
- Refresh Now
- Quit

----------------------------------------------------------------

5) Desktop app (Job Control Center.app)

Open:
Double‑click ~/Desktop/Job Control Center.app

Menu options:
1) Open Dashboard (TUI interface)
2) Open Full System Readme (this file)
3) Make Support Bundle (zip)

Support bundles created here:
~/jobs/logs/support_YYYYMMDD_HHMMSS.zip

Bundle contains:
- ALL logs
- ALL scripts
- ALL configs
- THIS runbook
- System snapshot for troubleshooting

----------------------------------------------------------------

6) Nightly email (Daily + ATS)

LaunchAgent:
com.irfan.dailyreport.email

Runs daily at:
18:20 local time (Chicago timezone)

Builder script:
~/jobs/bin/job_daily_email.sh

Outputs:
- logs/daily_report_YYYY-MM-DD.md
- logs/ats_digest_YYYY-MM-DD.md
- logs/summary_YYYY-MM-DD.md
- logs/daily_report_email.log

Manual trigger:
bash ~/jobs/bin/job_daily_email.sh

----------------------------------------------------------------

7) Feeding the system (Inbox CSVs)

CSV format:
company,email,role,location,notes

Example:
company,email,role,location,notes
Blue Maple,hr@bluemaple.ca,IT Engineer,Remote - Canada,LinkedIn
Chi Controls,hr@chicontrols.com,Controls Engineer,Chicago,Company site

Drop CSVs into:
~/jobs/inbox/

Process immediately:
bash ~/jobs/bin/inbox_merge.sh
bash ~/jobs/bin/pre_apply_clean.sh
bash ~/jobs/bin/apply_ready.sh


----------------------------------------------------------------

8) Health checks (30 seconds)

# Agents
launchctl list | grep -E 'jobapply\.watch|jobapply\.schedule|dailyreport\.email' || echo "agents missing"

# Logs (tails)
tail -n 30 ~/jobs/logs/inbox_merge.log
tail -n 30 ~/jobs/logs/pre_apply_clean.log
tail -n 30 ~/jobs/logs/auto_apply_watch.log

# Today count
grep -c "^$(date +%F)," ~/jobs/logs/applied.csv

# Proof attachments
tail -n 10 ~/jobs/logs/mail_debug.log

If anything looks off: use the menubar item “Copy Debug Snapshot” and paste to Copilot.

----------------------------------------------------------------

9) Tuning and configuration

Frequency (every 10 minutes instead of hourly):
plutil -replace StartInterval -integer 600 ~/Library/LaunchAgents/com.irfan.jobapply.watch.plist
launchctl unload ~/Library/LaunchAgents/com.irfan.jobapply.watch.plist 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.irfan.jobapply.watch.plist
launchctl enable   gui/$(id -u)/com.irfan.jobapply.watch
launchctl kickstart -k gui/$(id -u)/com.irfan.jobapply.watch

Cooldown (default 7 days; optional 3 days):
cp ~/jobs/bin/apply_now.sh ~/jobs/bin/apply_now.sh.BAK.$(date +%Y%m%d%H%M%S)
sed -i '' 's/\(COOLDOWN_DAYS=\)7/\13/' ~/jobs/bin/apply_now.sh || true

Roles and countries:
- Edit roles:  ~/jobs/bin/roles.conf
- Edit rich remote countries:  ~/jobs/bin/rich_countries.txt

Suppress list:
- Add emails to ~/jobs/suppress.txt (one per line)
- Deduplicate:  sort -u ~/jobs/suppress.txt -o ~/jobs/suppress.txt

----------------------------------------------------------------

10) Repair and reinstall

Reinstall all schedules (apply + digests + nightly + menubar):
bash ~/jobs/bin/schedules_install.sh

Rebuild menubar app and ensure start at login:
osacompile -l JavaScript -o ~/Applications/"Jobs Menu Safe.app" ~/jobs/menubar/JobsMenuBar_Safe.js
xattr -dr com.apple.quarantine ~/Applications/"Jobs Menu Safe.app"
open -gj -a ~/Applications/"Jobs Menu Safe.app"

plutil -lint ~/Library/LaunchAgents/com.irfan.jobs.menu.safe.plist
launchctl unload   ~/Library/LaunchAgents/com.irfan.jobs.menu.safe.plist 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.irfan.jobs.menu.safe.plist
launchctl enable   gui/$(id -u)/com.irfan.jobs.menu.safe
launchctl kickstart -k gui/$(id -u)/com.irfan.jobs.menu.safe

Reset Desktop app quarantine (if prompted):
xattr -dr com.apple.quarantine ~/Desktop/"Job Control Center.app"

----------------------------------------------------------------

11) Support bundle (for deep troubleshooting)

Desktop app option 3 creates:
~/jobs/logs/support_YYYYMMDD_HHMMSS.zip

Manual:
bash ~/jobs/bin/make_support_bundle.sh

Bundle includes logs, configs, scripts, and this README.

----------------------------------------------------------------

12) Known benign messages

- "Skip 7d window: … (1 d)" = cooldown working; yesterday’s contacts were skipped.
- "skip non-Chicago: …" = not Chicago-area and not Remote-rich.
- "skip remote not-rich: …" = remote country not in rich list.
- "Bad syntax: email" = quoted or angle-bracketed emails; cleaner fixes new rows.

----------------------------------------------------------------

13) Handy one-liners

# Open this Runbook
open -a TextEdit ~/jobs/APP_README.md

# Apply now (full pipeline)
bash ~/jobs/bin/inbox_merge.sh && bash ~/jobs/bin/pre_apply_clean.sh && bash ~/jobs/bin/apply_ready.sh

# Generate nightly email now
bash ~/jobs/bin/job_daily_email.sh

# Make support bundle now
bash ~/jobs/bin/make_support_bundle.sh

----------------------------------------------------------------

14) Files and scripts index

Core:
- ~/jobs/bin/inbox_merge.sh
- ~/jobs/bin/pre_apply_clean.sh
- ~/jobs/bin/apply_ready.sh
- ~/jobs/bin/apply_now.sh

Reports / summary:
- ~/jobs/bin/job_daily_report.sh
- ~/jobs/bin/job_daily_email.sh

ATS:
- ~/jobs/bin/atsdigest
- ~/jobs/bin/ats_digest_now.sh
- ~/jobs/bin/atsdigest_md_only.sh

Digests:
- ~/jobs/bin/indeed_mail_now.sh

Menubar / Desktop:
- ~/jobs/menubar/JobsMenuBar_Safe.js
- ~/Applications/Jobs Menu Safe.app
- ~/Desktop/Job Control Center.app

LaunchAgents:
- ~/Library/LaunchAgents/com.irfan.jobapply.watch.plist
- ~/Library/LaunchAgents/com.irfan.jobapply.schedule.plist
- ~/Library/LaunchAgents/com.irfan.indeed.digest.plist
- ~/Library/LaunchAgents/com.irfan.atsdigest.plist
- ~/Library/LaunchAgents/com.irfan.dailyreport.email.plist
- ~/Library/LaunchAgents/com.irfan.jobs.menu.safe.plist

End of master runbook.
