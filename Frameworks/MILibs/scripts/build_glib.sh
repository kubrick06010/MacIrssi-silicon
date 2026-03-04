#!/usr/bin/env bash
set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd)/common.sh"

require_tool meson
require_tool ninja
require_tool rsync
require_source_tree "$GLIB_SRC"

mkdir -p "$BUILD_DIR" "$PREFIX_DIR"
rm -rf "$GLIB_BUILD"

echo "Building GLib for arch=$BUILD_ARCH, host=$HOST_TRIPLET"

GLIB_SANITIZED_SRC="$BUILD_DIR/glib-src"
rm -rf "$GLIB_SANITIZED_SRC"
rsync -a --delete --exclude='.git' "$GLIB_SRC/" "$GLIB_SANITIZED_SRC/"

# Strip stale generated headers/sources from legacy vendor drops so Meson's
# generated artifacts win during include resolution.
rm -f "$GLIB_SANITIZED_SRC/glibconfig.h"
rm -f "$GLIB_SANITIZED_SRC/gio/gioenumtypes.h" "$GLIB_SANITIZED_SRC/gio/gioenumtypes.c"
rm -f "$GLIB_SANITIZED_SRC/gobject/glib-enumtypes.h" "$GLIB_SANITIZED_SRC/gobject/glib-enumtypes.c"
rm -f "$GLIB_SANITIZED_SRC/gobject/glibenumtypes.h" "$GLIB_SANITIZED_SRC/gobject/glibenumtypes.c"

meson setup "$GLIB_BUILD" "$GLIB_SANITIZED_SRC" \
    --prefix "$GLIB_PREFIX" \
    --default-library shared \
    -Dbuildtype=release \
    -Dtests=false \
    -Dglib_assert=false \
    -Dglib_checks=false \
    -Dintrospection=disabled \
    -Dman-pages=disabled \
    -Ddocumentation=false

ninja -C "$GLIB_BUILD"
ninja -C "$GLIB_BUILD" install

echo "GLib built into: $GLIB_PREFIX"
