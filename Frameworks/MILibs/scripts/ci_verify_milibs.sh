#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MILIBS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

"$SCRIPT_DIR/bootstrap_tools.sh"
"$SCRIPT_DIR/build_all_deps.sh"
"$SCRIPT_DIR/verify_artifact_contract.sh" "$MILIBS_DIR/stage"
