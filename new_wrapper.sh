#!/bin/bash
set -e

cmd="${1:?Usage: $0 <command>}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

real_path=$(which "$cmd" 2>/dev/null) || {
    echo "Error: '$cmd' not found in PATH." >&2
    exit 1
}

if [[ "$real_path" == "$HOME/.local/bin/"* ]]; then
    echo "Error: '$cmd' resolves to a wrapper in ~/.local/bin — would create infinite loop." >&2
    exit 1
fi

wrapper_file="$REPO_DIR/wrappers/$cmd"

cat > "$wrapper_file" << EOF
#!/bin/bash
vpn_check || exit 1
exec "$real_path" "\$@"
EOF

chmod +x "$wrapper_file"

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
ln -sf "$wrapper_file" "$BIN_DIR/$cmd"
echo "Created wrappers/$cmd (wraps $real_path) and linked to $BIN_DIR/$cmd"
