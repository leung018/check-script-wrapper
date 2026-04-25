#!/bin/bash
set -e

cmd="${1:?Usage: $0 <command>}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

wrapper_file="$REPO_DIR/wrappers/$cmd"

if [[ ! -f "$wrapper_file" ]]; then
    echo "Error: no wrapper found for '$cmd' at $wrapper_file" >&2
    exit 1
fi

rm -f "$wrapper_file"
echo "Removed wrappers/$cmd"
