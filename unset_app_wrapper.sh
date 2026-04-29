#!/bin/bash
set -e

name="${1:?Usage: $0 <AppName>}"
wrapper="$HOME/Applications/${name}.app"

if [[ ! -d "$wrapper" ]]; then
    echo "Error: no wrapper found at $wrapper" >&2
    exit 1
fi

rm -rf "$wrapper"
echo "Removed $wrapper"
