#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MILIBS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

python3 -m pip install --target "$MILIBS_DIR/.tooling" meson ninja
echo "Installed local tooling in $MILIBS_DIR/.tooling"
