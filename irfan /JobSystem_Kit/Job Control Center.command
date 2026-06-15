#!/bin/zsh

echo "------------------------------------"
echo "        JOB CONTROL CENTER          "
echo "------------------------------------"
echo

# 1) Open Menubar app quietly
open -gj -a "$HOME/Applications/Jobs Menu Safe.app"

# 2) Show today's stats
echo "📨 TODAY SENT:"
grep "^$(date +%F)," "$HOME/jobs/logs/applied.csv" | wc -l
echo

# 3) Show queue
echo "📬 QUEUE SIZE:"
tail -n +2 "$HOME/jobs/targets.csv" 2>/dev/null | wc -l
echo

# 4) Show recent sends
echo "📝 LAST 10 APPLICATIONS:"
tail -n 10 "$HOME/jobs/logs/mail_debug.log"
echo

# 5) Open dashboard (optional)
echo "Opening Dashboard..."
open -gj -a Terminal "$HOME/Applications/Jobs Dashboard.app"

echo
echo "✔ READY — everything is running."
read "?Press ENTER to close..."
