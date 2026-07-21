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

# Returns "<total_lines> <non_test_lines>" for a given main.odin file.
# Non-test lines are lines before the "//\n// Tests\n//" section marker.
file_line_counts() {
    local file="$1"
    local total
    total=$(wc -l < "$file")

    local tests_line
    tests_line=$(grep -n '^// Tests$' "$file" | head -1 | cut -d: -f1 || true)

    local non_test
    if [[ -n "$tests_line" ]]; then
        # The section marker starts one line before "// Tests"; exclude it too
        non_test=$((tests_line - 2))
    else
        non_test=$total
    fi

    echo "$total $non_test"
}

print_header() {
    local separator="${1:-true}"
    if $MARKDOWN; then
        if [[ "$separator" == "true" ]]; then
            printf "| %s | %s | %s | %s | %s |\n" \
                "**Step**" "**Lines Added**" "**Lines Removed**" "**Total Lines**" "**Non-test Lines**"
            printf "|%-12s|%13s:|%15s:|%13s:|%15s:|\n" \
                "------------" "-------------" "---------------" "-------------" "---------------"
        else
            printf "| %s | %s | %s | %s | %s |\n" \
                "_Step_" "_Lines Added_" "_Lines Removed_" "_Total Lines_" "_Non-test Lines_"
        fi
    else
        printf "%-12s %12s %14s %12s %14s\n" \
            "Step" "Lines Added" "Lines Removed" "Total Lines" "Non-test Lines"
        if [[ "$separator" == "true" ]]; then
            printf "%-12s %12s %14s %12s %14s\n" \
                "----" "-----------" "-------------" "-----------" "--------------"
        fi
    fi
}

print_row() {
    local step="$1" added="$2" removed="$3" total="$4" non_test="$5"
    if $MARKDOWN; then
        printf "| %-10s | %11s | %13s | %11s | %13s |\n" \
            "$step" "$added" "$removed" "$total" "$non_test"
    else
        printf "%-12s %12s %14s %12s %14s\n" \
            "$step" "$added" "$removed" "$total" "$non_test"
    fi
}

print_header

total_added=0
total_removed=0
row=0

# Step 001 has no diff; count all lines in main.odin as added
step001="$REF_DIR/step-001/main.odin"
added=$(wc -l < "$step001")
read -r tl nt < <(file_line_counts "$step001")
print_row "step-001" "$added" "---" "$tl" "$nt"
total_added=$((total_added + added))
row=$((row + 1))

for diff_file in "$REF_DIR"/step-*/changes.diff; do
    if (( row % 10 == 0 )); then
        print_header false
    fi
    step=$(basename "$(dirname "$diff_file")")
    added=$(grep -c '^+' "$diff_file" || true)
    removed=$(grep -c '^-' "$diff_file" || true)
    # Subtract the +++ and --- header lines
    added=$((added - 1))
    removed=$((removed - 1))
    main_odin="$(dirname "$diff_file")/main.odin"
    read -r tl nt < <(file_line_counts "$main_odin")
    print_row "$step" "$added" "$removed" "$tl" "$nt"
    total_added=$((total_added + added))
    total_removed=$((total_removed + removed))
    row=$((row + 1))
done

if $MARKDOWN; then
    print_row "_**TOTAL**_" "$total_added" "$total_removed" "---" "---"
else
    printf "%-12s %12s %14s %12s %14s\n" \
        "----" "-----------" "-------------" "-----------" "--------------"
    print_row "TOTAL" "$total_added" "$total_removed" "---" "---"
fi
