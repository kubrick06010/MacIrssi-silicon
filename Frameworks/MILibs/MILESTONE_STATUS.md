# Milestone Status

Branch: `exp_deps_meson_rework`

## Completed
1. Phase 2 dependency pipeline scaffold (scripts, contract extraction, verification).
2. Phase 3 Xcode wiring to staged artifacts (copy staged GLib/libintl into build products).
3. Build-stage recovery and architecture alignment (arm64 build succeeds).
4. Packaging/link sanity verification (`verify_app_bundle.sh`).
5. Runtime smoke process documentation (`RUNTIME_SMOKE_CHECKLIST.md`).
6. Legacy vendored-source strategy decision: keep existing vendored project entries for now, but make them non-authoritative for outputs (staged artifacts remain source of truth).
7. Runtime smoke results sheet created with automated gate outcomes (`RUNTIME_SMOKE_RESULTS.md`).
8. Full manual runtime smoke checklist completed and recorded as PASS.

## Current gate commands
```bash
Frameworks/MILibs/scripts/ci_verify_milibs.sh
Frameworks/MILibs/scripts/verify_app_bundle.sh <path-to-MacIrssi.app>
```

Or single command:
```bash
Frameworks/MILibs/scripts/run_local_gate.sh <path-to-MacIrssi.app>
```

## Remaining work
1. Optional follow-up: remove legacy vendored source entries in `MILibs.xcodeproj` after one full release cycle on staged artifacts.
2. If desired, modernize warning-heavy legacy ObjC code paths (non-blocking for dependency milestone).
