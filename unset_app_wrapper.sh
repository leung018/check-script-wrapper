#!/bin/bash
set -e

name="${1:?Usage: $0 <AppName>}"
wrapper="$HOME/Applications/${name}.app"

if [[ ! -d "$wrapper" ]]; then
    echo "Error: no wrapper found at $wrapper" >&2
    exit 1
fi

real_app="$(grep '^REAL_APP=' "$wrapper/Contents/MacOS/wrapper" | cut -d= -f2- | tr -d '"')"

rm -rf "$wrapper"
echo "Removed $wrapper"

if [[ -d "$real_app" ]]; then
    mv "$real_app" "/Applications/${name}.app"
    echo "Restored real app to /Applications/${name}.app"
else
    echo "Error: could not find real app to restore at '$real_app'" >&2
    exit 1
fi

