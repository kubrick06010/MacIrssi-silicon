#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <path-to-MacIrssi.app>"
    exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/ci_verify_milibs.sh"
"$SCRIPT_DIR/verify_app_bundle.sh" "$1"

echo "Local gate passed."
