#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REF_DIR="$SCRIPT_DIR/../reference-implementation"

printf "%-12s %16s %16s\n" "Step" "Lines Added" "Lines Removed"
printf "%-12s %16s %16s\n" "----" "-----------" "-------------"

total_added=0
total_removed=0

# Step 001 has no diff; count all lines in main.odin as added
step001="$REF_DIR/step-001/main.odin"
added=$(wc -l < "$step001")
printf "%-12s %16d %16s\n" "step-001" "$added" "---"
total_added=$((total_added + added))

for diff_file in "$REF_DIR"/step-*/changes.diff; do
    step=$(basename "$(dirname "$diff_file")")
    added=$(grep -c '^+' "$diff_file" || true)
    removed=$(grep -c '^-' "$diff_file" || true)
    # Subtract the +++ and --- header lines
    added=$((added - 1))
    removed=$((removed - 1))
    printf "%-12s %16d %16d\n" "$step" "$added" "$removed"
    total_added=$((total_added + added))
    total_removed=$((total_removed + removed))
done

printf "%-12s %16s %16s\n" "----" "-----------" "-------------"
printf "%-12s %16d %16d\n" "TOTAL" "$total_added" "$total_removed"
