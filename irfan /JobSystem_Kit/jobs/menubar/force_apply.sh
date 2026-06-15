#!/bin/zsh
set -e
bash "$HOME/jobs/bin/inbox_merge.sh" || true
bash "$HOME/jobs/bin/pre_apply_clean.sh"
bash "$HOME/jobs/bin/apply_ready.sh"
