#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/build_glib.sh"

if [[ "${BUILD_GETTEXT_RUNTIME:-0}" == "1" ]]; then
    "$SCRIPT_DIR/build_gettext.sh"
else
    echo "Skipping standalone gettext-runtime build (set BUILD_GETTEXT_RUNTIME=1 to enable)."
fi

"$SCRIPT_DIR/stage_artifacts.sh"
