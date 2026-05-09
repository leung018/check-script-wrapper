#!/bin/bash
set -e

real_app="${1:?Usage: $0 <path-to-RealApp.app>}"
real_app="$(cd "$real_app" && pwd)"

if [[ ! -d "$real_app" || "$real_app" != *.app ]]; then
    echo "Error: '$real_app' is not a valid .app bundle." >&2
    exit 1
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
vpn_check_src="$repo_dir/vpn_check.sh"
if [[ ! -f "$vpn_check_src" ]]; then
    echo "Error: vpn_check.sh not found at $vpn_check_src." >&2
    exit 1
fi
vpn_check_body="$(tail -n +2 "$vpn_check_src")"

app_name="$(basename "$real_app" .app)"
slug="$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/-$//')"

hidden_dir="$HOME/.hidden_from_spotlight"
mkdir -p "$hidden_dir"
new_real_app="$hidden_dir/$(basename "$real_app")"
if [[ "$real_app" != "$new_real_app" ]]; then
    mv "$real_app" "$new_real_app"
    real_app="$new_real_app"
fi

output="$HOME/Applications/${app_name}.app"

mkdir -p "$output/Contents/MacOS" "$output/Contents/Resources"

cat > "$output/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>${app_name}</string>
    <key>CFBundleDisplayName</key>
    <string>${app_name}</string>
    <key>CFBundleIdentifier</key>
    <string>com.wrapped.${slug}</string>
    <key>CFBundleExecutable</key>
    <string>wrapper</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
</dict>
</plist>
EOF

cat > "$output/Contents/MacOS/wrapper" << WRAPPER
#!/bin/bash
REAL_APP="${real_app}"
if ! ( ${vpn_check_body} ) >/dev/null 2>&1; then
    osascript -e 'display alert "VPN required" message "Connect NordVPN before launching."'
    exit 1
fi
exec /usr/bin/open -a "\$REAL_APP" --args "\$@"
WRAPPER

chmod +x "$output/Contents/MacOS/wrapper"

icon_name="$(defaults read "$real_app/Contents/Info" CFBundleIconFile 2>/dev/null || true)"
if [[ -n "$icon_name" ]]; then
    [[ "$icon_name" == *.icns ]] || icon_name="${icon_name}.icns"
    icon_src="$real_app/Contents/Resources/$icon_name"
    [[ -f "$icon_src" ]] && cp "$icon_src" "$output/Contents/Resources/AppIcon.icns"
fi

echo "Created $output"
echo "Moved real app to $real_app (hidden from Spotlight)"
echo ""
echo "Next steps:"
echo "  1. Drag '${app_name}' from ~/Applications/ to the Dock (replace any pinned original)."
echo "  2. Exclude from Spotlight (one-time, reversible):"
echo "     System Settings → Spotlight → Privacy → drag in '$hidden_dir'"
echo "  3. Confirm '$real_app' is in NordVPN's killswitch app list."
echo ""
echo "  To reverse: move '$real_app' back to /Applications/ and remove '$hidden_dir' from Spotlight Privacy."
