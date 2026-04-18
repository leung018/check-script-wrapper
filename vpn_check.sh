#!/bin/bash
if ! command -v nordvpn &>/dev/null; then
    echo "Error: nordvpn CLI not found." >&2
    exit 1
fi
if ! nordvpn status 2>/dev/null | grep -q "Status: Connected"; then
    echo "Error: Not connected to NordVPN. Please connect first." >&2
    exit 1
fi
