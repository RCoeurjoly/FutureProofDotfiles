#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RULE_SRC="$ROOT/udev/60-task6-ypcb-pcie.rules"
HELPER_SRC="$ROOT/udev/task6-pcie-pci-permissions"
RULE_DST="/etc/udev/rules.d/60-task6-ypcb-pcie.rules"
HELPER_DST="/usr/local/libexec/task6-pcie/task6-pcie-pci-permissions"

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "This script must be run as root. Use: sudo $0" >&2
  exit 1
fi

install -d -o root -g root -m 0755 /usr/local/libexec/task6-pcie
install -o root -g root -m 0644 "$RULE_SRC" "$RULE_DST"
install -o root -g root -m 0755 "$HELPER_SRC" "$HELPER_DST"

udevadm control --reload-rules
udevadm trigger --subsystem-match=pci --attr-match=vendor=0x10ee || true

echo "Installed $RULE_DST"
echo "Installed $HELPER_DST"
echo "Verify with:"
echo "  ls -l /sys/bus/pci/devices/0000:42:00.0/resource0"
echo "  setpci -s 0000:42:00.0 COMMAND"
