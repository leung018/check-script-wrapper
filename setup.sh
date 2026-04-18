#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$BIN_DIR"

if ! grep -qF "$BIN_DIR" "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    echo "Added $BIN_DIR to PATH in ~/.zshrc"
fi

ln -sf "$REPO_DIR/vpn_check.sh" "$BIN_DIR/vpn_check"
chmod +x "$REPO_DIR/vpn_check.sh"
echo "Installed vpn_check -> $BIN_DIR/vpn_check"

for wrapper in "$REPO_DIR/wrappers"/*; do
    [ -f "$wrapper" ] || continue
    [[ "$(basename "$wrapper")" == ".gitkeep" ]] && continue
    name="$(basename "$wrapper")"
    ln -sf "$wrapper" "$BIN_DIR/$name"
    chmod +x "$wrapper"
    echo "Installed wrapper: $name -> $BIN_DIR/$name"
done

echo ""
echo "Setup complete. Run: source ~/.zshrc"
