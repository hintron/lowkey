#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REF_DIR="$SCRIPT_DIR/../reference-implementation"

MARKDOWN=false
for arg in "$@"; do
    case "$arg" in
        -m|--markdown) MARKDOWN=true ;;
        -h|--help)
            echo "Usage: $(basename "$0") [-m|--markdown]"
            echo ""
            echo "Options:"
            echo "  -m, --markdown  Output as a markdown table"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *) echo "Unknown argument: $arg" >&2; exit 1 ;;
    esac
done

if $MARKDOWN; then
    printf "| %-10s | %13s | %15s |\n" "Step" "Lines Added" "Lines Removed"
    printf "|%-12s|%15s:|%17s:|\n" "------------" "-------------" "---------------"
else
    printf "%-12s %16s %16s\n" "Step" "Lines Added" "Lines Removed"
    printf "%-12s %16s %16s\n" "----" "-----------" "-------------"
fi

total_added=0
total_removed=0

# Step 001 has no diff; count all lines in main.odin as added
step001="$REF_DIR/step-001/main.odin"
added=$(wc -l < "$step001")
if $MARKDOWN; then
    printf "| %-10s | %13d | %15s |\n" "step-001" "$added" "---"
else
    printf "%-12s %16d %16s\n" "step-001" "$added" "---"
fi
total_added=$((total_added + added))

for diff_file in "$REF_DIR"/step-*/changes.diff; do
    step=$(basename "$(dirname "$diff_file")")
    added=$(grep -c '^+' "$diff_file" || true)
    removed=$(grep -c '^-' "$diff_file" || true)
    # Subtract the +++ and --- header lines
    added=$((added - 1))
    removed=$((removed - 1))
    if $MARKDOWN; then
        printf "| %-10s | %13d | %15d |\n" "$step" "$added" "$removed"
    else
        printf "%-12s %16d %16d\n" "$step" "$added" "$removed"
    fi
    total_added=$((total_added + added))
    total_removed=$((total_removed + removed))
done

if $MARKDOWN; then
    printf "| %-10s | %13d | %15d |\n" "**TOTAL**" "$total_added" "$total_removed"
else
    printf "%-12s %16s %16s\n" "----" "-----------" "-------------"
    printf "%-12s %16d %16d\n" "TOTAL" "$total_added" "$total_removed"
fi
