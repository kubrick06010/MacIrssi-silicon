# Runtime Smoke Checklist

This checklist is for validating the staged dependency pipeline after a successful build.

## Automated checks
1. Build MILibs artifacts:
```bash
Frameworks/MILibs/scripts/build_all_deps.sh
Frameworks/MILibs/scripts/verify_artifact_contract.sh Frameworks/MILibs/stage
```
2. Build app in Xcode (`Development` or `Debug`).
3. Validate built app bundle:
```bash
Frameworks/MILibs/scripts/verify_app_bundle.sh \
  ~/Library/Developer/Xcode/DerivedData/<DerivedDataFolder>/Build/Products/Development/MacIrssi.app
```

## Manual checks
1. Launch app and confirm main window renders.
2. Open `Preferences…` and verify the panel opens without exceptions.
3. Change chat font and confirm channel ribbon updates as expected.
4. Connect to a test server and join a channel.
5. Send/receive a message in channel and in console tab.
6. Use channel search and confirm result selection/switching works.
7. Quit/relaunch and verify state restoration does not crash.

## Pass criteria
- No startup crash.
- No missing-library load errors.
- Preferences + core IRC workflows functional.
- No regression in channel bar behavior introduced in current milestone.
