#!/usr/bin/env bash

set -euo pipefail

direction="${1:-}"
step="${2:-10%}"

case "$direction" in
  up)
    if command -v brightnessctl >/dev/null 2>&1; then
      exec brightnessctl set "+${step}"
    fi
    if command -v xbacklight >/dev/null 2>&1; then
      exec xbacklight -inc "${step%\%}"
    fi
    ;;
  down)
    if command -v brightnessctl >/dev/null 2>&1; then
      exec brightnessctl set "${step}-"
    fi
    if command -v xbacklight >/dev/null 2>&1; then
      exec xbacklight -dec "${step%\%}"
    fi
    ;;
esac

echo "usage: $0 <up|down> [step-percent]" >&2
exit 1
