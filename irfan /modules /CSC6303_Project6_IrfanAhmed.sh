#!/bin/bash
 # ============================================================
 # CSC 6303 - Project #6: Bash/Batch Scripting
 # Author: Irfan Ahmed
 # System tested: macOS (Apple Silicon - M-series)
 # Description:
 #   - Create a folder named FirstnameLastnameProject6 on Desktop
 #   - Create a .txt file inside it with all even numbers 1..50 (inclusive)
 #   - Script is intended to be run from Desktop (per assignment)
 # ============================================================

 set -euo pipefail

 # 1) Ensure we're on Desktop (assignment assumes running from Desktop)
 DESKTOP="${HOME}/Desktop"
 if [[ "$(pwd)" != "$DESKTOP" ]]; then
   echo "ℹ️  Not currently in Desktop. Switching to: $DESKTOP"
   cd "$DESKTOP"
 fi

 # 2) Project folder name (FirstnameLastnameProject6)
 PROJECT_DIR="IrfanAhmedProject6"

 # 3) Create the folder (idempotent)
 mkdir -p "$PROJECT_DIR"

 # 4) Target text file path
 OUT_FILE="${PROJECT_DIR}/even_numbers.txt"

 # 5) Write even numbers 1..50 inclusive, one per line
 : > "$OUT_FILE"   # truncate/create file
 for (( i=2; i<=50; i+=2 )); do
   echo "$i" >> "$OUT_FILE"
 done

 # 6) Friendly output
 echo "✅ Folder created: $DESKTOP/$PROJECT_DIR"
 echo "✅ File created:   $OUT_FILE"
 echo "✅ Wrote even numbers 2..50 (inclusive)."
 echo "Done."
