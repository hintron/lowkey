#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
REF_IMPL="$REPO_ROOT/reference-implementation"

usage() { echo "Usage: $(basename "$0") [-o|--odinfmt] [-l|--lucyfmt] [-h|--help]" >&2; }

help() {
    cat <<EOF
Usage: $(basename "$0") [OPTION]

Format all .odin files in the reference-implementation/ directory.

Options:
  -o, --odinfmt   Use odinfmt as the formatter (default)
  -l, --lucyfmt   Use lucyfmt as the formatter
  -h, --help      Show this help message and exit

Examples:
  $(basename "$0")           # format with odinfmt (default)
  $(basename "$0") -o        # format with odinfmt explicitly
  $(basename "$0") -l        # format with lucyfmt
EOF
}

case "${1:-}" in
    ""|"-o"|"--odinfmt") FMT="odinfmt" ;;
    "-l"|"--lucyfmt")    FMT="lucyfmt" ;;
    "-h"|"--help"|"-help") help; exit 0 ;;
    *)       echo "Error: unknown option '${1}'" >&2; usage; exit 1 ;;
esac

if ! command -v "$FMT" &>/dev/null; then
    echo "Error: '$FMT' not found in PATH" >&2
    exit 1
fi

echo "Using formatter: $FMT"

find "$REF_IMPL" -name '*.odin' | while read -r file; do
    echo "  Formatting $file"
    "$FMT" -w "$file"
done

echo "Done."
