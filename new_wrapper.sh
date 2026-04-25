#!/bin/bash
set -e

cmd="${1:?Usage: $0 <command>}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRAPPERS_DIR="$REPO_DIR/wrappers"

real_path=$(PATH="${PATH//$WRAPPERS_DIR:/}" command -v "$cmd" 2>/dev/null) || {
    echo "Error: '$cmd' not found in PATH (excluding wrappers)." >&2
    exit 1
}

wrapper_file="$WRAPPERS_DIR/$cmd"

cat > "$wrapper_file" << EOF
#!/bin/bash
vpn_check || exit 1
exec "$real_path" "\$@"
EOF

chmod +x "$wrapper_file"
echo "Created wrappers/$cmd (wraps $real_path)"
echo "Ensure '$WRAPPERS_DIR' is on your PATH before system paths."
