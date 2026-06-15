#!/usr/bin/env bash
set -euo pipefail
KIT="$HOME/Desktop/JobSystem_Kit"
OUT="$HOME/Desktop/JobSystem_Kit_$(date +%Y%m%d_%H%M%S).zip"
cd "$HOME/Desktop"
# -y to store symlinks as symlinks so logs link remains a link
zip -y -r "$OUT" "JobSystem_Kit" >/dev/null 2>&1 || true
echo "✅ Created: $OUT"
open -R "$OUT"
