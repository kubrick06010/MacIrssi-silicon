#!/usr/bin/env bash
set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd)/common.sh"

require_tool make
require_source_tree "$GETTEXT_SRC"

mkdir -p "$BUILD_DIR" "$PREFIX_DIR"
rm -rf "$GETTEXT_BUILD"
mkdir -p "$GETTEXT_BUILD"

echo "Building gettext-runtime for arch=$BUILD_ARCH, host=$HOST_TRIPLET"

# Build gettext-runtime only; MacIrssi needs libintl.
(
    cd "$GETTEXT_BUILD"
    "$GETTEXT_SRC/gettext-runtime/configure" \
        --prefix="$GETTEXT_PREFIX" \
        --disable-java \
        --disable-csharp \
        --disable-openmp \
        --without-emacs \
        --without-git \
        --enable-relocatable \
        --with-included-gettext \
        --with-included-glib \
        --host="$HOST_TRIPLET" \
        --build="$HOST_TRIPLET" \
        CC="${CC:-cc}" \
        CFLAGS="$CFLAGS" \
        LDFLAGS="$LDFLAGS" \
        --cache-file=/dev/null \
        --srcdir="$GETTEXT_SRC/gettext-runtime" \
        > "$GETTEXT_BUILD/configure.log" 2>&1
)

make -C "$GETTEXT_BUILD" -j"$JOBS" > "$GETTEXT_BUILD/build.log" 2>&1
make -C "$GETTEXT_BUILD" install > "$GETTEXT_BUILD/install.log" 2>&1

echo "gettext-runtime built into: $GETTEXT_PREFIX"
