#!/usr/bin/env bash
set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd)/common.sh"

mkdir -p "$STAGE_DIR"
rm -rf "$STAGE_DIR/GLib.framework"
mkdir -p "$STAGE_DIR/GLib.framework/Headers"

GLIB_DYLIB="$(find "$GLIB_PREFIX/lib" -maxdepth 1 -name 'libglib-2.0*.dylib' | head -n 1 || true)"
if [[ -z "$GLIB_DYLIB" ]]; then
    echo "Could not find built libglib dylib under $GLIB_PREFIX/lib"
    exit 1
fi
cp "$GLIB_DYLIB" "$STAGE_DIR/GLib.framework/GLib"
install_name_tool -id "@executable_path/../Frameworks/GLib.framework/GLib" "$STAGE_DIR/GLib.framework/GLib" || true

# Stage headers with old project-compatible layout.
if [[ -d "$GLIB_PREFIX/include/glib-2.0" ]]; then
    cp -R "$GLIB_PREFIX/include/glib-2.0/"* "$STAGE_DIR/GLib.framework/Headers/"
fi
if [[ -f "$GLIB_PREFIX/lib/glib-2.0/include/glibconfig.h" ]]; then
    cp "$GLIB_PREFIX/lib/glib-2.0/include/glibconfig.h" "$STAGE_DIR/GLib.framework/Headers/"
fi

LIBINTL_DYLIB=""
if [[ -d "$GETTEXT_PREFIX/lib" ]]; then
    LIBINTL_DYLIB="$(find "$GETTEXT_PREFIX/lib" -maxdepth 1 -name 'libintl*.dylib' | head -n 1 || true)"
fi
if [[ -z "$LIBINTL_DYLIB" ]]; then
    LIBINTL_DYLIB="$(find "$GLIB_PREFIX/lib" -maxdepth 1 -name 'libintl*.dylib' | head -n 1 || true)"
fi
if [[ -z "$LIBINTL_DYLIB" ]]; then
    echo "Could not find built libintl dylib under:"
    echo "  - $GETTEXT_PREFIX/lib"
    echo "  - $GLIB_PREFIX/lib"
    exit 1
fi
cp "$LIBINTL_DYLIB" "$STAGE_DIR/libintl.dylib"
install_name_tool -id "@loader_path/Resources/libintl.dylib" "$STAGE_DIR/libintl.dylib" || true

echo "Staged artifacts:"
ls -la "$STAGE_DIR"
