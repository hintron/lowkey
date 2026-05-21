#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REF_IMPL_DIR=$(realpath "$SCRIPT_DIR/../reference-implementation")

PASS=0
FAIL=0


n=1
while true; do
    step="$(printf "step-%03d" "$n")"
    ((n++))
    step_dir="$REF_IMPL_DIR/$step"
    [[ -d "$step_dir" ]] || break
    echo "Building $step with \`odin build . -vet\`"
    cd "$step_dir" || exit
    if ! output=$(odin build . -vet 2>&1); then
        echo "  FAIL: $step: Build failed"
        echo "$output"
        FAIL=$((FAIL+1))
        break
    fi

    if ! output=$(odin test . -vet 2>&1); then
        echo "  FAIL: $step: Tests failed"
        echo "$output"
        FAIL=$((FAIL+1))
        break
    fi

    echo "  PASS: $step"
    PASS=$((PASS+1))
done

if [[ $FAIL -gt 0 ]]; then
    echo "Stopping at first failure"
    exit 1
fi

# Finally, check that the final implementation in src/ builds successfully
echo "Building final implementation in src/ with \`odin build . -vet\`"
cd "$REF_IMPL_DIR/src" || exit
if ! output=$(odin build . -vet 2>&1); then
    echo "  FAIL: Final implementation in src/: Build failed"
    echo "$output"
    FAIL=$((FAIL+1))
else
    if ! output=$(odin test . -vet 2>&1); then
        echo "  FAIL: Final implementation in src/: Tests failed"
        echo "$output"
        FAIL=$((FAIL+1))
    else
        echo "  PASS: Final implementation in src/"
        PASS=$((PASS+1))
    fi
fi

echo "------------------------------"
echo "Results: $PASS passed, $FAIL failed"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
