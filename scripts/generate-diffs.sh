#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../reference-implementation" || exit

step=2
step_prev=$((step-1))
while [[ -d "$(printf 'step-%03d' $step)" ]]; do
    PREV="$(printf 'step-%03d' $step_prev)"
    CURR="$(printf 'step-%03d' $step)"
    diff -u --label "$PREV/main.odin" --label "$CURR/main.odin" "$PREV/main.odin" "$CURR/main.odin" > "$CURR/changes.diff" || true
    echo "Generated $CURR/changes.diff"
    ((step+=1))
    ((step_prev+=1))
done

