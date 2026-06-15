#!/bin/zsh
set -euo pipefail

# 1) Merge inbox leads → targets.csv
bash ~/jobs/bin/inbox_merge.sh || true

# 2) Normalize emails/locations
bash ~/jobs/bin/pre_apply_clean.sh

# 3) Build ready queue + apply up to 200 (handles Chicago/Remote rules)
bash ~/jobs/bin/apply_ready.sh
