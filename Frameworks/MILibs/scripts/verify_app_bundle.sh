#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <path-to-MacIrssi.app>"
    exit 2
fi

APP_PATH="$1"
APP_BIN="$APP_PATH/Contents/MacOS/MacIrssi"
GLIB_BIN="$APP_PATH/Contents/Frameworks/GLib.framework/GLib"
LIBINTL_BIN="$APP_PATH/Contents/Frameworks/GLib.framework/Resources/libintl.dylib"

fail=0

check_file() {
    local p="$1"
    if [[ -e "$p" ]]; then
        echo "OK: $p"
    else
        echo "MISSING: $p"
        fail=1
    fi
}

check_contains() {
    local text="$1"
    local needle="$2"
    if echo "$text" | grep -Fq "$needle"; then
        echo "OK: found link -> $needle"
    else
        echo "MISSING LINK: $needle"
        fail=1
    fi
}

check_file "$APP_BIN"
check_file "$GLIB_BIN"
check_file "$LIBINTL_BIN"

if [[ $fail -eq 0 ]]; then
    app_links="$(otool -L "$APP_BIN")"
    glib_links="$(otool -L "$GLIB_BIN")"

    check_contains "$app_links" "@executable_path/../Frameworks/GLib.framework/Versions/A/GLib"
    check_contains "$glib_links" "@loader_path/Resources/libintl.dylib"
fi

if [[ $fail -ne 0 ]]; then
    echo "Bundle verification failed."
    exit 1
fi

echo "Bundle verification passed."
