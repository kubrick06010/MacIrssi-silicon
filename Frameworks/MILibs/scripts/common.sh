#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MILIBS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TOOLING_BIN="$MILIBS_DIR/.tooling/bin"

if [[ -d "$TOOLING_BIN" ]]; then
    export PATH="$TOOLING_BIN:$PATH"
fi

if [[ -d "$MILIBS_DIR/.tooling/mesonbuild" ]]; then
    export PYTHONPATH="$MILIBS_DIR/.tooling${PYTHONPATH:+:$PYTHONPATH}"
fi

UPSTREAM_DIR="$MILIBS_DIR/upstream"
BUILD_DIR="$MILIBS_DIR/.build-deps"
PREFIX_DIR="$BUILD_DIR/prefix"
STAGE_DIR="$MILIBS_DIR/stage"

GLIB_VERSION="2.86.4"
GETTEXT_VERSION="0.25"

GLIB_SRC="$UPSTREAM_DIR/glib-$GLIB_VERSION"
GETTEXT_SRC="$UPSTREAM_DIR/gettext-$GETTEXT_VERSION"

GLIB_PREFIX="$PREFIX_DIR/glib"
GETTEXT_PREFIX="$PREFIX_DIR/gettext"

GLIB_BUILD="$BUILD_DIR/glib"
GETTEXT_BUILD="$BUILD_DIR/gettext-runtime"

TARGET_ARCH="x86_64"
BUILD_ARCH="${BUILD_ARCH:-$(uname -m)}"
MACOSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-10.13}"

case "$BUILD_ARCH" in
    arm64)
        HOST_TRIPLET="arm-apple-darwin"
        ;;
    x86_64)
        HOST_TRIPLET="x86_64-apple-darwin"
        ;;
    *)
        echo "Unsupported BUILD_ARCH: $BUILD_ARCH"
        echo "Set BUILD_ARCH to one of: arm64, x86_64"
        exit 1
        ;;
esac

export CFLAGS="-arch $BUILD_ARCH -mmacosx-version-min=$MACOSX_DEPLOYMENT_TARGET"
export CXXFLAGS="$CFLAGS"
export OBJCFLAGS="$CFLAGS"
export OBJCXXFLAGS="$CFLAGS"
export LDFLAGS="-arch $BUILD_ARCH -mmacosx-version-min=$MACOSX_DEPLOYMENT_TARGET"

require_tool() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Missing tool: $1"
        echo "Install with Homebrew: brew install $1"
        exit 1
    }
}

require_source_tree() {
    local path="$1"
    [[ -d "$path" ]] || {
        echo "Missing source tree: $path"
        echo "Populate upstream sources first."
        exit 1
    }
}

detect_jobs() {
    local n
    n="$(getconf _NPROCESSORS_ONLN 2>/dev/null || true)"
    if [[ -z "$n" || "$n" -lt 1 ]]; then
        n=1
    fi
    echo "$n"
}

JOBS="${JOBS:-$(detect_jobs)}"
