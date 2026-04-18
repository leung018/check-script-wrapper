#!/bin/bash
if ! ifconfig 2>/dev/null | grep -q "inet 10\.5\.0\."; then
    echo "Error: Not connected to NordVPN. Please connect first." >&2
    exit 1
fi
