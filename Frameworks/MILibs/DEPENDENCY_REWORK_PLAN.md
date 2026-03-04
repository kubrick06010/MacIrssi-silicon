# MILibs Dependency Rework Plan (Experimental)

Branch: `exp_deps_meson_rework`

## Goal
Replace legacy hand-wired vendored builds with a maintainable dependency pipeline, then upgrade libraries safely.

## Scope
- `Frameworks/MILibs` only.
- Preserve app behavior and exported symbols expected by MacIrssi.
- Keep app modernization changes separate from dependency pipeline changes where possible.

## Current State
- Legacy sources are tightly wired in `MILibs.xcodeproj`.
- Upgrading GLib/gettext by path substitution alone fails due generated headers/layout/tooling assumptions.

## Target Strategy
1. Build dependencies out-of-tree using upstream-supported build systems:
   - GLib: Meson + Ninja
   - gettext/libintl: upstream build tooling (or compatible package build)
2. Produce stable artifacts for Xcode consumption:
   - `GLib.framework` (or static lib + headers)
   - `libintl.dylib` (or static alternative if needed)
3. Consume artifacts from a deterministic `build-deps` script phase.
4. Keep source vendoring optional (`upstream/` snapshots or tarball pins).

## Execution Phases
### Phase 1: Artifact Contract
- Define required headers, library names, install names, and architectures.
- Document exact include paths consumed by app targets.

### Phase 2: Build Scripts
- Add scripts under `Frameworks/MILibs/scripts/`:
  - `build_glib.sh`
  - `build_gettext.sh`
  - `stage_artifacts.sh`
- Pin versions explicitly in scripts.

### Phase 3: Xcode Wiring
- Update `MILibs.xcodeproj` to reference staged artifacts instead of thousands of vendored source files.
- Ensure `HEADER_SEARCH_PATHS` and `LD_RUNPATH_SEARCH_PATHS` are deterministic.
- Decision (current branch): keep legacy vendored file references in project structure for now to reduce churn/risk, while build outputs come from staged artifacts.

### Phase 4: Validation
- Build `MILibs` target alone.
- Build whole app.
- Runtime smoke test: connect, join channel, open preferences, change fonts, run search.

### Phase 5: Upgrade Iteration
- Upgrade gettext first (lower blast radius than GLib runtime APIs).
- Upgrade GLib after artifact pipeline is stable.

## Risks
- ABI drift (GLib types/symbol versions).
- Packaging/linker differences on modern macOS.
- Generated-header mismatches if scripts are incomplete.

## Success Criteria
- Clean reproducible dependency build from scripts on a clean checkout.
- App builds without manual dependency patching.
- No regression in core flows (startup, IRC session, preferences UI).

## Scripted Phase 2 Scaffold (Current)

Scripts added under `Frameworks/MILibs/scripts/`:
- `common.sh` (shared paths, versions, flags)
- `bootstrap_tools.sh` (local Meson/Ninja install into `.tooling/`)
- `build_glib.sh`
- `build_gettext.sh`
- `stage_artifacts.sh`
- `build_all_deps.sh`
- `extract_artifact_contract.sh`
- `verify_artifact_contract.sh`
- `ci_verify_milibs.sh` (single entrypoint for CI-friendly dependency verification)
- `verify_app_bundle.sh` (post-build app bundle linkage/layout verification)

Runtime checklist:
- `Frameworks/MILibs/RUNTIME_SMOKE_CHECKLIST.md`

Quick start:
```bash
cd Frameworks/MILibs
./scripts/bootstrap_tools.sh
./scripts/build_all_deps.sh
./scripts/verify_artifact_contract.sh "$(pwd)/stage"
```

Notes:
- `build_all_deps.sh` currently builds GLib and stages `libintl` from GLib's `proxy-libintl`.
- Standalone gettext runtime build is optional (`BUILD_GETTEXT_RUNTIME=1`) and remains experimental.
- Artifacts are staged into `Frameworks/MILibs/stage/`.
