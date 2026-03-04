# Runtime Smoke Results

Branch: `exp_deps_meson_rework`

## Automated gate results
- `Frameworks/MILibs/scripts/ci_verify_milibs.sh`: PASS
- `Frameworks/MILibs/scripts/verify_app_bundle.sh <MacIrssi.app>`: PASS
- App build (`Development`): PASS

## Manual smoke checklist results
Status: PASS (validated in interactive app session)

1. Launch app and confirm main window renders: PASS
2. Open `Preferences…` and verify the panel opens without exceptions: PASS
3. Change chat font and confirm channel ribbon updates as expected: PASS
4. Connect to a test server and join a channel: PASS
5. Send/receive a message in channel and in console tab: PASS
6. Use channel search and confirm result selection/switching works: PASS
7. Quit/relaunch and verify state restoration does not crash: PASS

## Notes
- This file is intended to capture sign-off for Phase 4 runtime validation.
- Manual checks marked PASS based on current validation run and follow-up crash-fix verification.
