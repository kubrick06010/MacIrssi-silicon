#!/usr/bin/env bash
set -euo pipefail

PROJECT_PATH="${PROJECT_PATH:-MacIrssi.xcodeproj}"
SCHEME="${SCHEME:-MacIrssi}"
BUILD_CONFIGURATION="${BUILD_CONFIGURATION:-Development}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$(mktemp -d /tmp/macirssi-release-deriveddata.XXXXXX)}"
OUTPUT_DIR="${OUTPUT_DIR:-Releases}"
APP_NAME="${APP_NAME:-MacIrssi.app}"

SIGN_IDENTITY="${APPLE_SIGN_IDENTITY:-}"
NOTARY_PROFILE="${NOTARY_PROFILE:-}"

GH_PUBLISH="${GH_PUBLISH:-0}"
GH_REPO="${GH_REPO:-kubrick06010/MacIrssi-silicon}"
GH_TAG="${GH_TAG:-}"
GH_TITLE="${GH_TITLE:-}"
GH_NOTES="${GH_NOTES:-}"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "error: missing required command: $1" >&2
    exit 1
  }
}

need_cmd xcodebuild
need_cmd codesign
need_cmd xcrun
need_cmd ditto
need_cmd git
need_cmd /usr/libexec/PlistBuddy

if [[ -z "$SIGN_IDENTITY" ]]; then
  echo "error: set APPLE_SIGN_IDENTITY (Developer ID Application certificate)" >&2
  exit 1
fi

if [[ -z "$NOTARY_PROFILE" ]]; then
  echo "error: set NOTARY_PROFILE (stored notarytool keychain profile)" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "==> Building ${SCHEME} (${BUILD_CONFIGURATION})"
xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -configuration "$BUILD_CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  build >/tmp/macirssi-release-build.log

APP_PATH="$DERIVED_DATA_PATH/Build/Products/$BUILD_CONFIGURATION/$APP_NAME"
if [[ ! -d "$APP_PATH" ]]; then
  echo "error: built app not found at $APP_PATH" >&2
  exit 1
fi

VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP_PATH/Contents/Info.plist" 2>/dev/null || echo "0.0.0")"
COMMIT="$(git rev-parse --short HEAD)"
DATE_TAG="$(date +%Y%m%d)"
BASENAME="MacIrssi-${VERSION}-${DATE_TAG}-${COMMIT}-macos"
SUBMIT_ZIP="$OUTPUT_DIR/${BASENAME}-submit.zip"
FINAL_ZIP="$OUTPUT_DIR/${BASENAME}.zip"

echo "==> Signing nested code"
if [[ -d "$APP_PATH/Contents/Frameworks" ]]; then
  while IFS= read -r -d '' f; do
    codesign --force --timestamp --options runtime --sign "$SIGN_IDENTITY" "$f"
  done < <(find "$APP_PATH/Contents/Frameworks" -type f \( -name "*.dylib" -o -perm -111 \) -print0)

  while IFS= read -r -d '' f; do
    codesign --force --timestamp --options runtime --sign "$SIGN_IDENTITY" "$f"
  done < <(find "$APP_PATH/Contents/Frameworks" -type d -name "*.framework" -print0)
fi

echo "==> Signing app bundle"
codesign --force --timestamp --options runtime --sign "$SIGN_IDENTITY" "$APP_PATH"

codesign --verify --deep --strict --verbose=2 "$APP_PATH"

echo "==> Creating notarization upload zip"
rm -f "$SUBMIT_ZIP" "$FINAL_ZIP"
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" "$SUBMIT_ZIP"

echo "==> Submitting for notarization"
xcrun notarytool submit "$SUBMIT_ZIP" --keychain-profile "$NOTARY_PROFILE" --wait

echo "==> Stapling notarization ticket"
xcrun stapler staple "$APP_PATH"
xcrun stapler validate "$APP_PATH"

echo "==> Creating final distributable zip"
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" "$FINAL_ZIP"

if command -v spctl >/dev/null 2>&1; then
  spctl --assess --type execute -vv "$APP_PATH" || true
fi

echo "==> Artifact ready: $FINAL_ZIP"

if [[ "$GH_PUBLISH" == "1" ]]; then
  need_cmd gh

  if [[ -z "$GH_TAG" ]]; then
    GH_TAG="v${VERSION}-${DATE_TAG}-${COMMIT}"
  fi
  if [[ -z "$GH_TITLE" ]]; then
    GH_TITLE="MacIrssi ${VERSION} (${COMMIT})"
  fi
  if [[ -z "$GH_NOTES" ]]; then
    GH_NOTES="Notarized macOS build for commit ${COMMIT}."
  fi

  echo "==> Publishing GitHub release $GH_TAG"
  if gh release view "$GH_TAG" --repo "$GH_REPO" >/dev/null 2>&1; then
    gh release upload "$GH_TAG" "$FINAL_ZIP" --repo "$GH_REPO" --clobber
  else
    gh release create "$GH_TAG" "$FINAL_ZIP" --repo "$GH_REPO" --target main --title "$GH_TITLE" --notes "$GH_NOTES"
  fi
fi

echo "==> Done"
