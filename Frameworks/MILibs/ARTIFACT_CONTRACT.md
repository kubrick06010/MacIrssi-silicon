# MILibs Artifact Contract

Generated: 2026-03-03T23:05:02Z

## Producer Targets (Frameworks/MILibs.xcodeproj)

- Target: `GLib`
  - Product: `GLib.framework`
  - Product type: framework
  - Install path: `@executable_path/../Frameworks`
  - Header search paths used while building GLib:
    13659:				HEADER_SEARCH_PATHS = (
    13660-					"glib-2.24.1/",
    13661-					"glib-2.24.1/glib/",
    13662-					"gettext-0.17/gettext-runtime/intl",
    13663-				);
    13664-				INFOPLIST_FILE = "GLib-Info.plist";
    13665-				INSTALL_PATH = "@executable_path/../Frameworks";
    --
    13735:				HEADER_SEARCH_PATHS = (
    13736-					"glib-2.24.1/",
    13737-					"glib-2.24.1/glib/",
    13738-					"gettext-0.17/gettext-runtime/intl",
    13739-				);
    13740-				INFOPLIST_FILE = "GLib-Info.plist";
    13741-				INSTALL_PATH = "@executable_path/../Frameworks";

- Target: `libintl`
  - Product: `libintl.dylib`
  - Product type: dynamic library
  - Install name: `@loader_path/Resources/$(EXECUTABLE_PATH)`
  - Header search path: `$(SRCROOT)/gettext-0.17/gettext-runtime`

## Consumer Wiring (MacIrssi.xcodeproj)

### Project Reference
- 611:			containerPortal = C91792C90F743801005241A4 /* MILibs.xcodeproj */;
- 618:			containerPortal = C91792C90F743801005241A4 /* MILibs.xcodeproj */;
- 625:			containerPortal = C91792C90F743801005241A4 /* MILibs.xcodeproj */;
- 632:			containerPortal = C91792C90F743801005241A4 /* MILibs.xcodeproj */;
- 1203:		C91792C90F743801005241A4 /* MILibs.xcodeproj */ = {isa = PBXFileReference; lastKnownFileType = "wrapper.pb-project"; name = MILibs.xcodeproj; path = MILibs/MILibs.xcodeproj; sourceTree = "<group>"; };
- 1961:				C91792C90F743801005241A4 /* MILibs.xcodeproj */,
- 3375:			projectReferences = (
- 3378:					ProjectRef = C91792C90F743801005241A4 /* MILibs.xcodeproj */;

### Linked / Embedded Products
- 14:				C95430BB1305AE8700C19A0C /* CopyFiles */,
- 271:		C95430BF1305AE9E00C19A0C /* GLib.framework in CopyFiles */ = {isa = PBXBuildFile; fileRef = C9C762AB12EFD5850072D1E8 /* GLib.framework */; };
- 312:		C9E1AEEB12EFFF42004E75B0 /* GLib.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = C9C762AB12EFD5850072D1E8 /* GLib.framework */; };
- 457:		C9E1B1C512F00273004E75B0 /* GLib.framework in Copy Libraries */ = {isa = PBXBuildFile; fileRef = C9C762AB12EFD5850072D1E8 /* GLib.framework */; };
- 653:/* Begin PBXCopyFilesBuildPhase section */
- 654:		B322D70305EF930400E640C2 /* Copy Libraries */ = {
- 655:			isa = PBXCopyFilesBuildPhase;
- 660:				C9E1B1C512F00273004E75B0 /* GLib.framework in Copy Libraries */,
- 662:			name = "Copy Libraries";
- 666:			isa = PBXCopyFilesBuildPhase;
- 798:			isa = PBXCopyFilesBuildPhase;
- 933:			isa = PBXCopyFilesBuildPhase;
- 943:			isa = PBXCopyFilesBuildPhase;
- 964:			isa = PBXCopyFilesBuildPhase;
- 990:		C95430BB1305AE8700C19A0C /* CopyFiles */ = {
- 991:			isa = PBXCopyFilesBuildPhase;
- 996:				C95430BF1305AE9E00C19A0C /* GLib.framework in CopyFiles */,
- 1000:/* End PBXCopyFilesBuildPhase section */
- 1851:				C9E1AEEB12EFFF42004E75B0 /* GLib.framework in Frameworks */,
- 2302:				C9C7636112EFE26B0072D1E8 /* libintl.dylib */,
- 2303:				C9C762AB12EFD5850072D1E8 /* GLib.framework */,
- 3314:				B322D70305EF930400E640C2 /* Copy Libraries */,
- 3392:		C9C762AB12EFD5850072D1E8 /* GLib.framework */ = {
- 3395:			path = GLib.framework;
- 3399:		C9C7636112EFE26B0072D1E8 /* libintl.dylib */ = {
- 3402:			path = libintl.dylib;
- 3818:					"$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers",
- 3861:					"$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers",
- 3946:					"$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers",
- 3976:					"$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers",

### Consumer Header Search Paths
- 3816:				HEADER_SEARCH_PATHS = (
- 3818:					"$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers",
- 3859:				HEADER_SEARCH_PATHS = (
- 3861:					"$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers",
- 3945:				HEADER_SEARCH_PATHS = (
- 3946:					"$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers",
- 3975:				HEADER_SEARCH_PATHS = (
- 3976:					"$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers",

## Required Build Artifacts

- `$(BUILT_PRODUCTS_DIR)/GLib.framework`
- `$(BUILT_PRODUCTS_DIR)/GLib.framework/Headers` (must expose glib headers)
- `$(BUILT_PRODUCTS_DIR)/libintl.dylib`

## Notes

- Current projects assume source-vendored layouts for GLib/gettext (not generated/header-installed layouts).
- Any migration to Meson/CMake should stage artifacts so these paths remain valid or update both projects together.
