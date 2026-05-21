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
    echo "Building and testing $step"
    cd "$step_dir" || exit
    if ! output=$(odin build . -vet 2>&1); then
        echo "  FAIL: $step: Build failed for \`odin build . -vet\`"
        echo "$output"
        FAIL=$((FAIL+1))
        break
    fi

    if ! output=$(odin test . -vet 2>&1); then
        echo "  FAIL: $step: Tests failed for \`odin test . -vet\`"
        echo "$output"
        FAIL=$((FAIL+1))
        break
    fi
    if echo "$output" | grep -qE 'WARN|\+\+\+ leak'; then
        echo "  WARN: $step: Warnings in test output"
        echo "$output" | grep -E 'WARN|\+\+\+ leak'
    fi

    echo "  PASS: $step"
    PASS=$((PASS+1))
done

if [[ $FAIL -gt 0 ]]; then
    echo "Stopping at first failure"
    exit 1
fi

# Finally, check that the final implementation in src/ builds successfully
echo "Building final implementation in src/"
cd "$REF_IMPL_DIR/src" || exit
if ! output=$(odin build . -vet 2>&1); then
    echo "  FAIL: Final implementation in src/: Build failed for \`odin build . -vet\`"
    echo "$output"
    FAIL=$((FAIL+1))
else
    if ! output=$(odin test . -vet 2>&1); then
        echo "  FAIL: Final implementation in src/: Tests failed for \`odin test . -vet\`"
        echo "$output"
        FAIL=$((FAIL+1))
    else
        if echo "$output" | grep -qE 'WARN|\+\+\+ leak'; then
            echo "  WARN: Final implementation in src/: Warnings in test output"
            echo "$output" | grep -E 'WARN|\+\+\+ leak'
        fi
        echo "  PASS: Final implementation in src/"
        PASS=$((PASS+1))
    fi
fi

echo "------------------------------"
echo "Results: $PASS passed, $FAIL failed"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
