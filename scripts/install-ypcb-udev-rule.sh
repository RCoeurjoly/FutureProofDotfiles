#!/usr/bin/env bash
set -euo pipefail

RULE_SRC="$(cd "$(dirname "$0")/.." && pwd)/udev/99-ypcb-ft232h.rules"
RULE_DST="/etc/udev/rules.d/99-ypcb-ft232h.rules"

if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root. Use: sudo $0" >&2
  exit 1
fi

install -m 0644 "${RULE_SRC}" "${RULE_DST}"
udevadm control --reload-rules
udevadm trigger --subsystem-match=usb
udevadm trigger --subsystem-match=tty

echo "Installed ${RULE_DST}. Replug the YPCB board." 
