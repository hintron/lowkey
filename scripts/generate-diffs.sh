#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../reference-implementation" || exit

# The default mode is to generate and overwrite the diffs
MODE="${1:-generate}"

generate_diffs() {
    local step=2
    local step_prev=1
    while [[ -d "$(printf 'step-%03d' "$step")" ]]; do
        local PREV
        local CURR
        PREV="$(printf 'step-%03d' "$step_prev")"
        CURR="$(printf 'step-%03d' "$step")"
        diff \
        -u \
        --label "$PREV/main.odin" \
        --label "$CURR/main.odin" \
        "$PREV/main.odin" \
        "$CURR/main.odin" > "$CURR/changes.diff" || true
        echo "Generated $CURR/changes.diff"
        ((step+=1))
        ((step_prev+=1))
    done
}

check_diffs() {
    local step=2
    local step_prev=1
    local mismatch=0

    while [[ -d "$(printf 'step-%03d' "$step")" ]]; do
        local PREV
        local CURR
        local expected_diff
        local changes_file

        PREV="$(printf 'step-%03d' "$step_prev")"
        CURR="$(printf 'step-%03d' "$step")"
        changes_file="$CURR/changes.diff"
        expected_diff="$(mktemp)"

        diff -u --label "$PREV/main.odin" --label "$CURR/main.odin" "$PREV/main.odin" "$CURR/main.odin" > "$expected_diff" || true

        if [[ ! -f "$changes_file" ]]; then
            echo "Missing: $changes_file"
            mismatch=1
        elif ! cmp -s "$expected_diff" "$changes_file"; then
            echo "Outdated: $changes_file"
            mismatch=1
        fi

        rm -f "$expected_diff"
        ((step+=1))
        ((step_prev+=1))
    done

    if [[ $mismatch -eq 0 ]]; then
        echo "All changes.diff files are up to date"
        return 0
    fi

    echo "Run scripts/generate-diffs.sh to regenerate diffs"
    return 1
}

case "$MODE" in
    generate)
        generate_diffs
        ;;
    --check|check)
        check_diffs
        ;;
    *)
        echo "Usage: $0 [generate|--check]"
        exit 2
        ;;
esac

