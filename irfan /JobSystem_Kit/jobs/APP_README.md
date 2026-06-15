# 📘 Irfan’s Fully‑Automated Job Application System — MASTER README
**Mode:** Headless
**Home:** `~/Desktop/JobSystem_Kit/`
**Symlink:** `~/jobs` → `~/Desktop/JobSystem_Kit/jobs`

(… FULL README CONTENT FROM PREVIOUS MESSAGE …)

# MASTER RULE: Document FIRST → THEN change system.

# 📁 Folder Structure (Single‑Home System)

All components live inside ONE folder:

~/Desktop/JobSystem_Kit/
├── jobs/
│   ├── bin/               (main engine scripts)
│   ├── menubar/           (force_apply + health_check)
│   ├── inbox/             (incoming job CSV)
│   ├── logs/              (all logs)
│   ├── outbox/
│   ├── sent/
│   ├── templates/
│   ├── targets.csv        (main queue)
│   ├── suppress.txt
│   └── APP_README.md
├── apps/Core/Jobs Menu Safe.app
└── launchagents/

Symlink:
~/jobs → ~/Desktop/JobSystem_Kit/jobs



# 🔄 Auto‑Apply Pipeline (Every 10 Minutes)

Every 10 minutes, your system automatically performs:

1. **inbox_merge.sh**  
   - Merges new CSV job leads from ~/jobs/inbox/

2. **pre_apply_clean.sh**  
   - Fixes formatting  
   - Normalizes emails  
   - Cleans invalid entries  
   - Applies location rules (Chicago area + Remote‑rich countries)

3. **apply_ready.sh**  
   - Builds READY queue  
   - Filters cooldown  
   - Filters same‑day dedupe  
   - Filters No‑MX domains

4. **apply_now.sh**  
   - Sends job applications using Apple Mail  
   - Attaches resume  
   - Writes OUT=OK into mail_debug.log  
   - Writes success entry in applied.csv

5. **realtime_success_alert.sh**  
   - Sends instant email to you for every OUT=OK

6. Restores original targets.csv

This ensures maximum job applying with zero manual work.


# 📨 Email Engine (Apple Mail Automation)

The system uses Apple Mail to send job applications silently.

- Apple Mail attaches your resume automatically
- Sends emails to HR addresses
- Logs each application in mail_debug.log
- Tracks successful applications in applied.csv
- OUT=OK means the application email was sent successfully

Important:
Mail.app must remain OPEN in the background for automation to work.

Key files:
~/jobs/logs/mail_debug.log
~/jobs/logs/applied.csv



# 🛑 Eligibility Rules (Safety Filters)

The system uses multiple filters to avoid duplicates and invalid job posts:

- Same‑day dedupe: skip if applied today
- 3‑day cooldown: skip if applied recently
- No‑MX: skip emails without a working mail server
- Suppress list: skip blocked emails/companies
- Chicago area locations accepted
- Remote jobs accepted ONLY if the country is in rich_countries.txt

Rich countries file:
~/jobs/bin/rich_countries.txt



# ⚡ Real-Time Success Alerts

Script: ~/jobs/bin/realtime_success_alert.sh

Triggered automatically after every OUT=OK.

Each time your resume is successfully sent,
you receive an instant email alert at:
engineerirfan21@gmail.com

Alert contains:
- HR email
- Role
- Company
- Time of send
- Resume path



# 📨 Daily Success Report (20:00)

Script:
~/jobs/bin/daily_success_report.sh

LaunchAgent:
com.irfan.daily_success_report

Runs every day at 20:00 (8 PM):
- Counts all today's OUT=OK applications
- Emails you the summary
- Saves Markdown report to:
  ~/jobs/logs/success_report_YYYY-MM-DD.md



# 🌐 Indeed + LinkedIn Auto‑Collector (Every 6 Hours)

To maximize daily job applying, the system automatically collects new jobs from:

1. Indeed (via RSS)
2. LinkedIn (public feed API)

Scripts:
~/jobs/bin/indeed_pull.sh
~/jobs/bin/linkedin_pull.sh

Workflow:
- Collect new jobs (roles + companies)
- Guess HR emails (careers@company.com)
- Create inbox CSV
- Auto‑start pipeline:
    inbox_merge.sh
    pre_apply_clean.sh
    apply_ready.sh
    apply_now.sh
    realtime_success_alert.sh

LaunchAgent:
~/Library/LaunchAgents/com.irfan.jobcollector.plist
Runs every 6 hours.

This makes the system apply MAXIMUM JOBS daily.



# 🕕 Daily Report Email (18:20)

At 18:20 (6:20 PM), the system sends a daily status email with:
- Today's total applications
- Key logs
- Queue status
- Health summary

LaunchAgent:
com.irfan.dailyreport.email

Where:
~/Library/LaunchAgents/com.irfan.dailyreport.email.plist

Manual run:
bash ~/jobs/bin/job_daily_email.sh

Outputs:
~/jobs/logs/daily_report_YYYY-MM-DD.md
~/jobs/logs/ats_digest_YYYY-MM-DD.md
~/jobs/logs/summary_YYYY-MM-DD.md
~/jobs/logs/daily_report_email.log


# 🗂 Indeed Digest (optional)

Purpose:
Summarize Indeed activity or send a curated digest.

Scripts (if enabled in your setup):
~/jobs/bin/indeed_mail_now.sh
Log:
~/jobs/logs/indeed_digest.log

Manual run:
bash ~/jobs/bin/indeed_mail_now.sh

# 🗂 ATS Digest (optional)

Purpose:
Summarize ATS‑tracked interactions or daily ATS‑focused report.

Scripts (if enabled):
~/jobs/bin/ats_digest_now.sh
~/jobs/bin/atsdigest
~/jobs/bin/atsdigest_md_only.sh

Manual run:
bash ~/jobs/bin/ats_digest_now.sh

Outputs:
~/jobs/logs/ats_digest_YYYY-MM-DD.md
Log:
~/jobs/logs/atsdigest.log (if used)


# 🧩 LaunchAgents — Summary

All agents run in headless mode and must reference paths under ~/jobs (symlinked to your kit).

- com.irfan.jobapply.watch
  - Every 10 minutes: apply pipeline
  - File: ~/Library/LaunchAgents/com.irfan.jobapply.watch.plist

- com.irfan.jobcollector
  - Every 6 hours: Indeed + LinkedIn collector → pipeline
  - File: ~/Library/LaunchAgents/com.irfan.jobcollector.plist

- com.irfan.daily_success_report
  - Daily 20:00: sends success summary
  - File: ~/Library/LaunchAgents/com.irfan.daily_success_report.plist

- com.irfan.dailyreport.email
  - Daily 18:20: sends daily status email
  - File: ~/Library/LaunchAgents/com.irfan.dailyreport.email.plist

- com.irfan.indeed.digest (optional)
  - Daily or manual: send Indeed digest
  - File: ~/Library/LaunchAgents/com.irfan.indeed.digest.plist

- com.irfan.atsdigest (optional)
  - Daily or manual: ATS digest
  - File: ~/Library/LaunchAgents/com.irfan.atsdigest.plist

- com.irfan.jobs.menu.safe
  - Headless app controller at login
  - File: ~/Library/LaunchAgents/com.irfan.jobs.menu.safe.plist


# 🕶 Headless Mode (B)

- No Dock icon, no menubar icon (LSUIElement app)
- All UI‑less; controlled by LaunchAgents + Terminal buttons
- Keep Apple Mail open in background for sending
- Force Apply & Health Check are terminal shortcuts:
  ~/jobs/menubar/force_apply.sh
  ~/jobs/menubar/health_check.sh

If you ever move the kit:
- Update LaunchAgents paths if needed
- Ensure the compatibility symlink exists:
  ln -sfn ~/Desktop/JobSystem_Kit/jobs ~/jobs


# 🧪 Manual Commands — Quick Cheat‑Sheet

# Apply now (full pipeline)
bash ~/jobs/bin/inbox_merge.sh && bash ~/jobs/bin/pre_apply_clean.sh && bash ~/jobs/bin/apply_ready.sh

# Terminal buttons (headless replacements)
~/jobs/menubar/force_apply.sh
~/jobs/menubar/health_check.sh

# Watcher heartbeat
tail -n 12 ~/jobs/logs/auto_apply_watch.log

# Today count
grep -c "^\$(date +%F)," ~/jobs/logs/applied.csv || echo 0

# Proof of successful sends
tail -n 20 ~/jobs/logs/mail_debug.log

# Collector log (Indeed+LinkedIn)
tail -n 50 ~/jobs/logs/jobcollector.log

# LaunchAgents present
launchctl list | grep -E 'jobapply\.watch|jobcollector|daily_success_report|dailyreport\.email|indeed\.digest|atsdigest|jobs\.menu\.safe'


# 🧯 Troubleshooting

No real‑time alert?
- No new OUT=OK occurred
- Mail.app closed
- Automation permissions to control Mail not granted

Sent 0?
- Blocked by:
  - Same‑day dedupe
  - 3‑day cooldown
  - No‑MX
  - Suppress list
- Feed new leads or wait until cooldown expires

Collector not running?
- Check agent:
  launchctl list | grep jobcollector
- Check log:
  tail -n 50 ~/jobs/logs/jobcollector.log

Wrong paths?
- Ensure symlink:
  ls -ld ~/jobs
  # should point to ~/Desktop/JobSystem_Kit/jobs

If still stuck:
- Use Health Check:
  ~/jobs/menubar/health_check.sh


# 🚀 Maximum Job Strategy (Daily)

- Keep Apple Mail open at all times
- Ensure all LaunchAgents are loaded and enabled
- Expand roles in ~/jobs/bin/roles.conf (add synonyms)
- Keep rich countries updated in ~/jobs/bin/rich_countries.txt
- Feed fresh leads:
  - Indeed + LinkedIn collectors (6‑hourly)
  - Add manual CSVs into ~/jobs/inbox/ when needed
- Avoid 'No‑MX' by correcting HR emails (careers@company.com, jobs@company.com, hr@company.com)
- Use Force Apply between collector cycles:
  ~/jobs/menubar/force_apply.sh
- Monitor Health Check once per day:
  ~/jobs/menubar/health_check.sh


# 🧷 Change Log (Key Items)
- 2026-02-24: Indeed + LinkedIn collectors added (6‑hourly). README updated.
- 2026-02-24: Real‑Time alerts + Daily success report documented.
- 2026-02-22: Headless Mode B; single‑home folder + ~/jobs symlink policy.
- 2026-02-22: Eligibility rules (dedupe, cooldown=3d, No‑MX) fixed and documented.
- 2026-02-22: Force Apply + Health Check (terminal) added.

# ⚠️ MASTER RULE — ALWAYS UPDATE THIS README
Document FIRST → THEN change the system.
This keeps everything stable, discoverable, and easy to extend.


# 🧩 LaunchAgents — Summary Table

These LaunchAgents run your entire job system in headless mode:

- com.irfan.jobapply.watch  
  → Runs auto‑apply pipeline every 10 minutes  
  → File: ~/Library/LaunchAgents/com.irfan.jobapply.watch.plist

- com.irfan.jobcollector  
  → Runs Indeed + LinkedIn collectors every 6 hours  
  → File: ~/Library/LaunchAgents/com.irfan.jobcollector.plist

- com.irfan.daily_success_report  
  → Sends daily success summary at 20:00  
  → File: ~/Library/LaunchAgents/com.irfan.daily_success_report.plist

- com.irfan.dailyreport.email  
  → Sends daily status report at 18:20  
  → File: ~/Library/LaunchAgents/com.irfan.dailyreport.email.plist

- com.irfan.indeed.digest (optional)  
  → Sends Indeed digest  

- com.irfan.atsdigest (optional)  
  → Sends ATS digest  

- com.irfan.jobs.menu.safe  
  → Loads headless Jobs Menu Safe.app at login

All these agents must be loaded and pointing to ~/jobs/ paths.


# 🧪 Manual Commands — Quick Cheat Sheet

# Run full pipeline now
bash ~/jobs/bin/inbox_merge.sh && \
bash ~/jobs/bin/pre_apply_clean.sh && \
bash ~/jobs/bin/apply_ready.sh

# Force Apply (clean UI)
~/jobs/menubar/force_apply.sh

# Health Check (system status)
~/jobs/menubar/health_check.sh

# Today's total applications
grep -c "^\$(date +%F)," ~/jobs/logs/applied.csv || echo 0

# Success log preview
tail -n 20 ~/jobs/logs/mail_debug.log

# Collector log
tail -n 50 ~/jobs/logs/jobcollector.log

# Watcher heartbeat
tail -n 12 ~/jobs/logs/auto_apply_watch.log

# LaunchAgents status
launchctl list | grep -E 'jobapply|collector|daily|indeed|atsdigest|menu.safe'


# 🕶 Headless Mode (B) — Fully Silent Operation

- No Dock icon  
- No menu bar icon  
- No window  
- Controlled only via LaunchAgents + Terminal  
- Apple Mail must stay open  
- All logs in ~/jobs/logs/  
- Force Apply / Health Check via terminal buttons

Why headless?
To keep system fast, clean, and running 24/7 without interruption.


# 🌐 Indeed + LinkedIn Auto‑Collector (6-Hour Cycle)

To maximize job intake, the system automatically collects NEW jobs:

1. **Indeed** (using RSS feeds)  
2. **LinkedIn** (public job feed API)

Scripts:
- ~/jobs/bin/indeed_pull.sh  
- ~/jobs/bin/linkedin_pull.sh  

Both create CSV files into:
~/jobs/inbox/

After each collector run, the system automatically:
- merges leads  
- cleans  
- builds READY queue  
- applies  
- sends resume  
- triggers real-time alert  
- logs OUT=OK  

LaunchAgent:
~/Library/LaunchAgents/com.irfan.jobcollector.plist

Collector runs at:
- Boot  
- Every 6 hours  


# 🕕 Daily Report (18:20)

At 18:20 every day, the system emails a daily status summary:
- Applications today
- Logs snapshot
- Queue size
- System health

LaunchAgent:
com.irfan.dailyreport.email

Location:
~/Library/LaunchAgents/com.irfan.dailyreport.email.plist


# 📘 System Overview

Your job automation system performs:
- 10-minute apply cycles  
- 6-hour job collection cycles  
- Real-time success alerts  
- Daily reports  
- ATS/Indeed digests  
- Headless background running  
- Maximum job application strategy  
- Resume attached automatically  
- Full logs for every action

This README documents the entire system completely.

