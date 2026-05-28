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
    local debug_build_out="$target_dir/.lowkey-debug-build-${target_name}-$$"
    local debug_test_out="$target_dir/.lowkey-debug-test-${target_name}-$$"

    echo "Building and testing $target_name"
    cd "$target_dir" || exit

    if ! output=$(odin build . -vet 2>&1); then
        echo "  BUILD FAIL: $target_name: Build failed for \`odin build . -vet\`"
        echo "$output"
        FAIL=$((FAIL+1))
        return 1
    fi

    if ! output=$(odin build . -vet -debug -out:"$debug_build_out" 2>&1); then
        rm -f "$debug_build_out"
        echo "  BUILD FAIL: $target_name: Debug build failed for \`odin build . -vet -debug -out:$debug_build_out\`"
        echo "$output"
        FAIL=$((FAIL+1))
        return 1
    fi
    rm -f "$debug_build_out"

    if ! output=$(odin test . -vet 2>&1); then
        echo "  TEST FAIL: $target_name: Tests failed for \`odin test . -vet\`"
        echo "$output"
        FAIL=$((FAIL+1))
        return 1
    fi

    if ! output=$(odin test . -vet -debug -out:"$debug_test_out" 2>&1); then
        echo "  TEST FAIL: $target_name: Debug tests failed for \`odin test . -vet -debug -out:$debug_test_out\`"
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

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

target_names=()
pids=()

for target_dir in "$REF_IMPL_DIR"/step-* "$REF_IMPL_DIR"/src; do
    [[ -d "$target_dir" ]] || continue
    target_name="$(basename "$target_dir")"
    target_names+=("$target_name")

    (
        if run_checks "$target_dir" "$target_name"; then
            echo "PASS" > "$tmp_dir/$target_name.status"
        else
            echo "FAIL" > "$tmp_dir/$target_name.status"
        fi
    ) > "$tmp_dir/$target_name.log" 2>&1 &
    pids+=("$!")
done

for pid in "${pids[@]}"; do
    wait "$pid" || true
done

PASS=0
FAIL=0
for target_name in "${target_names[@]}"; do
    cat "$tmp_dir/$target_name.log"
    if [[ -f "$tmp_dir/$target_name.status" ]] && [[ "$(<"$tmp_dir/$target_name.status")" == "PASS" ]]; then
        PASS=$((PASS+1))
    else
        FAIL=$((FAIL+1))
    fi
done

echo "------------------------------"
echo "Results: $PASS passed, $FAIL failed"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
