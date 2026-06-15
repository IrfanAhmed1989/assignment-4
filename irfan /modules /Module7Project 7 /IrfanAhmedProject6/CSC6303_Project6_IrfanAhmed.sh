#!/bin/bash
# ============================================================
# CSC 6303 - Project #6: Bash/Batch Scripting
# Author: Irfan Ahmed
# System tested: macOS (Apple Silicon - M-series)
# Description:
#   - Create a folder named FirstnameLastnameProject6 on Desktop
#   - Create a .txt file inside it with all even numbers 1..50 (inclusive)
#   - Adds a timestamp to the output filename for easy identification
#   - Maintains a stable symlink: even_numbers.txt -> latest timestamped file
# ============================================================

set -euo pipefail

DESKTOP="${HOME}/Desktop"
PROJECT_DIR="IrfanAhmedProject6"
PROJECT_PATH="${DESKTOP}/${PROJECT_DIR}"

# Ensure project folder exists
mkdir -p "${PROJECT_PATH}"

# Timestamp (YYYY-MM-DD_HH-MM-SS)
TS="$(date +'%Y-%m-%d_%H-%M-%S')"

# Timestamped output file and stable symlink
OUT_FILE_TS="${PROJECT_PATH}/even_numbers_${TS}.txt"
OUT_FILE_LINK="${PROJECT_PATH}/even_numbers.txt"

# Write even numbers 1..50 inclusive, one per line, to timestamped file
: > "$OUT_FILE_TS"
for (( i=2; i<=50; i+=2 )); do
  echo "$i" >> "$OUT_FILE_TS"
done

# Refresh the stable symlink to point to the latest timestamped file
# If an old symlink/file exists, remove it safely
if [[ -L "$OUT_FILE_LINK" || -f "$OUT_FILE_LINK" ]]; then
  rm -f "$OUT_FILE_LINK"
fi
ln -s "$(basename "$OUT_FILE_TS")" "$OUT_FILE_LINK"

# Friendly output
echo "✅ Folder created/verified: ${PROJECT_PATH}"
echo "✅ Timestamped file:        ${OUT_FILE_TS}"
echo "✅ Symlink (stable name):   ${OUT_FILE_LINK} -> $(basename "$OUT_FILE_TS")"
echo "✅ Wrote even numbers 2..50 (inclusive)."
echo "Done."
