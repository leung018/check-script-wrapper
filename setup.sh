#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRAPPERS_DIR="$REPO_DIR/wrappers"
BIN_DIR="$HOME/.local/bin"

if ! grep -qF "$WRAPPERS_DIR" "$HOME/.zshrc" 2>/dev/null; then
    echo "export PATH=\"$WRAPPERS_DIR:\$PATH\"" >> "$HOME/.zshrc"
    echo "Added $WRAPPERS_DIR to PATH in ~/.zshrc"
fi

mkdir -p "$BIN_DIR"
ln -sf "$REPO_DIR/vpn_check.sh" "$BIN_DIR/vpn_check"
chmod +x "$REPO_DIR/vpn_check.sh"
echo "Installed vpn_check -> $BIN_DIR/vpn_check"

echo ""
echo "Setup complete. Run: source ~/.zshrc"
