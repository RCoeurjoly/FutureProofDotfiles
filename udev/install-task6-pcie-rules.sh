#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [[ -f "$SCRIPT_DIR/60-task6-ypcb-pcie.rules" ]]; then
  SOURCE_DIR="$SCRIPT_DIR"
elif [[ -f "$SCRIPT_DIR/../share/task6-udev/60-task6-ypcb-pcie.rules" ]]; then
  SOURCE_DIR="$(cd "$SCRIPT_DIR/../share/task6-udev" && pwd)"
else
  echo "Could not find Task 6 PCIe udev payload next to $0 or in ../share/task6-udev" >&2
  exit 1
fi

RULE_SRC="$(readlink -f "$SOURCE_DIR/60-task6-ypcb-pcie.rules")"
HELPER_SRC="$(readlink -f "$SOURCE_DIR/task6-pcie-pci-permissions")"
BRIDGE_HELPER_SRC="$(readlink -f "$SOURCE_DIR/task6-pcie-bridge-permissions")"
RULE_DST="/etc/udev/rules.d/60-task6-ypcb-pcie.rules"
HELPER_DST="/usr/local/libexec/task6-pcie/task6-pcie-pci-permissions"
BRIDGE_HELPER_DST="/usr/local/libexec/task6-pcie/task6-pcie-bridge-permissions"

for src in "$RULE_SRC" "$HELPER_SRC" "$BRIDGE_HELPER_SRC"; do
  if [[ ! -s "$src" ]]; then
    echo "Refusing to install missing or empty Task 6 udev payload: $src" >&2
    exit 1
  fi
done

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "This script must be run as root. Use: sudo $0" >&2
  exit 1
fi

install -d -o root -g root -m 0755 /usr/local/libexec/task6-pcie
install -o root -g root -m 0644 "$RULE_SRC" "$RULE_DST"
install -o root -g root -m 0755 "$HELPER_SRC" "$HELPER_DST"
install -o root -g root -m 0755 "$BRIDGE_HELPER_SRC" "$BRIDGE_HELPER_DST"

for dst in "$RULE_DST" "$HELPER_DST" "$BRIDGE_HELPER_DST"; do
  if [[ ! -s "$dst" ]]; then
    echo "Installed Task 6 udev file is empty: $dst" >&2
    exit 1
  fi
done

udevadm control --reload-rules
udevadm trigger --subsystem-match=pci --attr-match=vendor=0x8086 || true
udevadm trigger --subsystem-match=pci --attr-match=vendor=0x10ee || true

echo "Installed $RULE_DST"
echo "Installed $HELPER_DST"
echo "Installed $BRIDGE_HELPER_DST"
echo "Verify with:"
echo "  ls -l /sys/bus/pci/devices/0000:42:00.0/resource0"
echo "  setpci -s 0000:42:00.0 COMMAND"
