#!/bin/bash
set -e

name="${1:?Usage: $0 <AppName>}"
wrapper="$HOME/Applications/${name}.app"
hidden_dir="$HOME/.hidden_from_spotlight"
hidden_app="$hidden_dir/${name}.app"

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
elif [[ -d "$hidden_app" ]]; then
    mv "$hidden_app" "/Applications/${name}.app"
    echo "Restored real app to /Applications/${name}.app"
else
    echo "Warning: could not find real app to restore (looked in $real_app and $hidden_app)"
fi

if [[ -d "$hidden_dir" ]] && [[ -z "$(ls -A "$hidden_dir")" ]]; then
    rm -rf "$hidden_dir"
    echo "Removed $hidden_dir (now empty)"
    echo ""
    echo "Note: remove '$hidden_dir' from System Settings → Spotlight → Privacy manually."
fi
