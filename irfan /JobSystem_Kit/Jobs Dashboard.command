#!/bin/zsh
printf '\e[8;40;120t' 2>/dev/null || true
exec "$HOME/jobs/bin/jobdash"
