#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REF_IMPL_DIR=$(realpath "$SCRIPT_DIR/../reference-implementation")

PASS=0
FAIL=0

echo "Checking that step diffs are up to date"
if ! bash "$SCRIPT_DIR/generate-diffs.sh" --check; then
    echo "Stopping because step diffs are outdated"
    exit 1
fi

run_checks() {
    local target_dir="$1"
    local target_name="$2"

    echo "Building and testing $target_name"
    cd "$target_dir" || exit

    if ! output=$(odin build . -vet 2>&1); then
        echo "  BUILD FAIL: $target_name: Build failed for \`odin build . -vet\`"
        echo "$output"
        FAIL=$((FAIL+1))
        return 1
    fi

    if ! output=$(odin build . -vet -debug 2>&1); then
        echo "  BUILD FAIL: $target_name: Debug build failed for \`odin build . -vet -debug\`"
        echo "$output"
        FAIL=$((FAIL+1))
        return 1
    fi

    if ! output=$(odin test . -vet 2>&1); then
        echo "  TEST FAIL: $target_name: Tests failed for \`odin test . -vet\`"
        echo "$output"
        FAIL=$((FAIL+1))
        return 1
    fi

    if ! output=$(odin test . -vet -debug 2>&1); then
        echo "  TEST FAIL: $target_name: Debug tests failed for \`odin test . -vet -debug\`"
        echo "$output"
        FAIL=$((FAIL+1))
        return 1
    fi

    if echo "$output" | grep -qE 'WARN|\+\+\+ leak'; then
        echo "  WARN: $target_name: Warnings in test output"
        echo "$output" | grep -E 'WARN|\+\+\+ leak'
    fi

    echo "  PASS: $target_name"
    PASS=$((PASS+1))
    return 0
}

for target_dir in "$REF_IMPL_DIR"/step-* "$REF_IMPL_DIR"/src; do
    [[ -d "$target_dir" ]] || continue
    target_name="$(basename "$target_dir")"
    if ! run_checks "$target_dir" "$target_name"; then
        break
    fi
done

if [[ $FAIL -gt 0 ]]; then
    echo "Stopping at first failure"
    exit 1
fi

echo "------------------------------"
echo "Results: $PASS passed, $FAIL failed"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
