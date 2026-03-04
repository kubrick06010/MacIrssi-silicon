#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <BUILT_PRODUCTS_DIR>"
  exit 2
fi

BPD="$1"
FAIL=0

check() {
  local path="$1"
  if [[ -e "$path" ]]; then
    echo "OK: $path"
  else
    echo "MISSING: $path"
    FAIL=1
  fi
}

check "$BPD/GLib.framework"
check "$BPD/GLib.framework/Headers"
check "$BPD/libintl.dylib"

# spot-check a few headers expected by app code
check "$BPD/GLib.framework/Headers/glib.h"
check "$BPD/GLib.framework/Headers/glib/glist.h"
check "$BPD/GLib.framework/Headers/glib/giochannel.h"

if [[ $FAIL -ne 0 ]]; then
  echo "Artifact contract verification failed."
  exit 1
fi

echo "Artifact contract verification passed."
