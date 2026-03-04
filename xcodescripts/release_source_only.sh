#!/usr/bin/env bash
set -euo pipefail

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "error: missing required command: $1" >&2
    exit 1
  }
}

need_cmd git
need_cmd gh

REPO="${GH_REPO:-kubrick06010/MacIrssi-silicon}"
TARGET="${TARGET_BRANCH:-main}"
TAG="${TAG:-}"
TITLE="${TITLE:-}"
NOTES="${NOTES:-}"

VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' Info.plist 2>/dev/null || echo "0.0.0")"
COMMIT="$(git rev-parse --short HEAD)"
DATE_TAG="$(date +%Y%m%d)"

if [[ -z "$TAG" ]]; then
  TAG="v${VERSION}-src-${DATE_TAG}-${COMMIT}"
fi

if [[ -z "$TITLE" ]]; then
  TITLE="MacIrssi ${VERSION} source release (${COMMIT})"
fi

if [[ -z "$NOTES" ]]; then
  NOTES=$(cat <<EON
Source-only release.

This release intentionally ships no prebuilt app bundle.
Build locally from source with Xcode:

1. Open MacIrssi.xcodeproj
2. Select scheme MacIrssi
3. Build configuration Development or Debug
4. Build and run

Reason: avoids Gatekeeper/notarization issues for unsigned binaries.
EON
)
fi

if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
  echo "error: release tag already exists: $TAG" >&2
  exit 1
fi

echo "==> Creating source-only release $TAG on $REPO"
gh release create "$TAG" --repo "$REPO" --target "$TARGET" --title "$TITLE" --notes "$NOTES"

echo "==> Done: $(gh release view "$TAG" --repo "$REPO" --json url -q .url)"
