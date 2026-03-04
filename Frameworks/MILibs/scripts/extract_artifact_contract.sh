#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
MILIBS_PBXPROJ="$ROOT_DIR/Frameworks/MILibs/MILibs.xcodeproj/project.pbxproj"
APP_PBXPROJ="$ROOT_DIR/MacIrssi.xcodeproj/project.pbxproj"
OUT_MD="$ROOT_DIR/Frameworks/MILibs/ARTIFACT_CONTRACT.md"

extract_between() {
  local start="$1"
  local end="$2"
  local file="$3"
  awk "/$start/{flag=1} flag{print} /$end/{if(flag){flag=0; print \"\"}}" "$file"
}

{
  echo "# MILibs Artifact Contract"
  echo
  echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo
  echo "## Producer Targets (Frameworks/MILibs.xcodeproj)"
  echo
  echo "- Target: \`GLib\`"
  echo "  - Product: \`GLib.framework\`"
  echo "  - Product type: framework"
  echo "  - Install path: \`@executable_path/../Frameworks\`"
  echo "  - Header search paths used while building GLib:"
  grep -n "HEADER_SEARCH_PATHS = (" -A6 "$MILIBS_PBXPROJ" | sed 's/^/    /' | head -n 16
  echo
  echo "- Target: \`libintl\`"
  echo "  - Product: \`libintl.dylib\`"
  echo "  - Product type: dynamic library"
  echo "  - Install name: \`@loader_path/Resources/\$(EXECUTABLE_PATH)\`"
  echo "  - Header search path: \`\$(SRCROOT)/gettext-0.17/gettext-runtime\`"
  echo
  echo "## Consumer Wiring (MacIrssi.xcodeproj)"
  echo
  echo "### Project Reference"
  grep -n "MILibs.xcodeproj\|projectReferences" "$APP_PBXPROJ" | sed 's/^/- /'
  echo
  echo "### Linked / Embedded Products"
  grep -n "GLib.framework\|libintl.dylib\|Copy Libraries\|CopyFiles" "$APP_PBXPROJ" | sed 's/^/- /'
  echo
  echo "### Consumer Header Search Paths"
  grep -n "\$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers\|HEADER_SEARCH_PATHS = (" "$APP_PBXPROJ" | sed 's/^/- /' | head -n 40
  echo
  echo "## Required Build Artifacts"
  echo
  echo "- \`\$(BUILT_PRODUCTS_DIR)/GLib.framework\`"
  echo "- \`\$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers\` (must expose glib headers)"
  echo "- \`\$(BUILT_PRODUCTS_DIR)/libintl.dylib\`"
  echo
  echo "## Notes"
  echo
  echo "- Current projects assume source-vendored layouts for GLib/gettext (not generated/header-installed layouts)."
  echo "- Any migration to Meson/CMake should stage artifacts so these paths remain valid or update both projects together."
} > "$OUT_MD"

echo "Wrote $OUT_MD"
