#!/bin/zsh
set -e
echo "---- WATCH ----"
tail -n 10 "$HOME/jobs/logs/auto_apply_watch.log" 2>/dev/null || true
echo ""
echo "---- READY ----"
tail -n 15 "$HOME/jobs/logs/apply_ready.log" 2>/dev/null || true
echo ""
echo "---- MAIL  ----"
tail -n 15 "$HOME/jobs/logs/mail_debug.log" 2>/dev/null || true
echo ""
echo "---- TODAY COUNT ----"
grep -c "^$(date +%F)," "$HOME/jobs/logs/applied.csv" 2>/dev/null || echo 0
echo ""
echo "---- QUEUE SIZE ----"
wc -l "$HOME/jobs/targets.csv" 2>/dev/null || echo "0 $HOME/jobs/targets.csv"
echo ""
